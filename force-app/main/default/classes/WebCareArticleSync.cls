/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description:
 *
 *
 * Created: 16/11/2022
 * Last Updated: 16/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
Description:
Main class that handles the article sync from Webcare. The actual DML is handled in the WebCareArticleSyncBatch.
Webcare can only send records in batches of 4000. This class will do a first callout to the endpoint to parse the first
page. It will then keep calling the endpoint as long as the records returned on a page is equal to 3999.

Authentication is handled using the WebcareRest class.

Change Log:

Dependencies:

    - WebCareArticleSyncBatch
    - WebCareArticle
    - WebCareArticleRest
    - WebCareRest


*/

public class WebCareArticleSync {

    List<SObject> prodList;
    List<SObject> pbeList;
    Map<String, String> profileMap;
    Map<String, String> rtMap;
    PriceBook2 priceBook;
    Pricebook2 storePriceBook;
    Map<String, String> ArticleRecordTypeMap;



    //----------------------------------------INITIALIZE-------------------------------------------------------------//


    // Constructor used to initialize the class, used to set the class variables that are used in the
    // WebCareArticleRest class
    public void initialize() {
        prodList = new List<SObject>();
        pbeList = new List<SObject>();
        rtMap = new Map<String, String>();
        ArticleRecordTypeMap = new Map<String, String>();
        profileMap = new Map<String, String>();
        priceBook = [SELECT Id FROM PriceBook2 WHERE IsStandard = true LIMIT 1];
        storePriceBook = [SELECT Id FROM PriceBook2 WHERE Name = 'QTeam B2B Price Book' LIMIT 1];

        for(RecordType rt : [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Product2']){
            if(rt.Name == 'Car'){
                rtMap.put('Car', rt.Id);
            }
            if(rt.Name == 'Truck'){
                rtMap.put('Truck', rt.Id);
            }
            if(rt.Name == 'Moto'){
                rtMap.put('Moto', rt.Id);
            }
        }

        for(Article_Type__c at : [SELECT Name, abbreviation__c, group__c, split1__c FROM Article_Type__c]){

            if(at.split1__c == 'T'  || at.split1__c == 'CT' || at.split1__c == '4x4'){
                ArticleRecordTypeMap.put(at.abbreviation__c, rtMap.get('Car'));
            }
            if(at.Name.startsWith('MO')){
                ArticleRecordTypeMap.put(at.abbreviation__c, rtMap.get('Moto'));
            }
            if(at.Name.startsWith('PL')){
                ArticleRecordTypeMap.put(at.abbreviation__c, rtMap.get('Truck'));
            }
        }


    }

    //----------------------------------------MAIN-------------------------------------------------------------//

    public List<Product2> startSync(Integer pageNumber){

        initialize();

        //Do the first callout to get the first page of articles, page return 3999 articles max
        //Then we loop through the pages until we get a page with less than 3999 articles
        //The parsePage method will handle the actual parsing of the articles, it calls the tranformProduct
        //method to transform the article into a Product2 record
        HttpResponse resp = WebCareRest.doCallOut('/portal/article/'+pageNumber, 'GET');
        WebCareArticle obj = WebCareArticle.parseMultipleArticles(resp.getBody());

        parsePage(obj);

        //Save refresh token after last callout
        Map<String, String> tokens = WebCareRest.refreshToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));

        //returns the list of all products that are ready to be created. The DML will happen in WebCareArticleSyncBatch
        system.debug('prodList: '+prodList.size());
        return prodList;

    }
    //----------------------------------------PARSE------------------------------------------------------------------//


    public Integer parsePage(WebCareArticle obj){

        //Create a list of all the article External Ids
        List<String> extIds = new List<String>();
        for(WebCareArticle.Article article : obj.articles){
            extIds.add(article.id);
        }

        //Get a list of all Product2 records that have a Webcare_Id__c that is in the list of extIds
        //Add them to a map so we can check whether the product already exists
        Map<String, String> prodMap = new Map<String, String>();
        for(Product2 sfProd : [SELECT Id, Webcare_Id__c FROM Product2 WHERE Webcare_Id__c IN :extIds]){
            prodMap.put(sfProd.Webcare_Id__c, sfProd.Id);
        }

        for(Linked_Profile__c lProf : [SELECT Webcare_Id__c, Profile_Webcare_Id__c FROM Linked_Profile__c]){
            profileMap.put(lProf.Webcare_Id__c, lProf.Profile_Webcare_Id__c);
        }



        for(Integer i = 0;i < obj.articles.size();i++){
            WebCareArticle.Article article = obj.articles[i];
            Product2 prod = tranformProduct(article);
            if(!prodMap.containsKey(article.id)){
                prod.Type = 'Base';
            }
            prodList.add(prod);
        }

        return obj.count;
    }


    //--------------------------------------TRANSFORM----------------------------------------------------------------//


    public PricebookEntry transformPricebookEntry(Product2 prod){
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2 = new Product2(Webcare_Id__c = prod.Webcare_Id__c);
        pbe.Webcare_Id__c = prod.Webcare_Id__c + '-std';
        pbe.Pricebook2Id = priceBook.Id;
        pbe.UnitPrice = 0;
        pbe.IsActive = true;
        return pbe;
    }

    public PricebookEntry transformStorePricebookEntry(Product2 prod){
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2 = new Product2(Webcare_Id__c = prod.Webcare_Id__c);
        pbe.Webcare_Id__c = prod.Webcare_Id__c + '-store';
        pbe.Pricebook2Id = storePriceBook.Id;
        pbe.UnitPrice = 0;
        pbe.IsActive = true;
        return pbe;
    }

    public Product2 tranformProduct(WebCareArticle.Article article){

        Product2 prod = new Product2();
        if(article.reference != ''){
            prod.Name = article.reference;
        } else {
            prod.Name = article.id;
        }
        prod.IsActive = true;
        prod.ProductCode = article.id;
        prod.Brand__r = new Brand__c(Abbreviation__c = article.brand);
        prod.Article_Type__r = new Article_Type__c(code__c = article.type);
        prod.EAN_Code__c = article.ean;
        prod.Webcare_Id__c = article.id;
        prod.Dim1__c = article.dim1;
        prod.Dim2__c = article.dim2;
        prod.Dim3__c = article.dim3;
        prod.Serie__c = article.series;
        prod.Profile__c = article.profile;
        if(profileMap.get(article.profile) != null){
            prod.Profile_Lookup__r = new Profile__c(Webcare_Id__c = profileMap.get(article.profile));
        }
        prod.XLRF__c = article.xlrf;
        prod.Speed__c = article.speed;
        prod.Drvm__c = article.loadbalancing;
        prod.Reclass__c = article.REclass;
        prod.Grip__c = article.grip;
        prod.Ecotax__c = Decimal.valueOf(article.ecotax);
        prod.Category__c = article.category;
        prod.Special_Designation__c = article.specialDesignation;
        prod.Specification__c = article.specification;
        prod.REvalue__c = article.REvalue;
        prod.BEclass__c = article.BEclass;
        prod.Application__c = article.application;
        prod.Ranking__c = article.ranking;
        prod.Ranking_Dist__c = article.rankingdist;
        prod.Fitm__c = article.fitm;
        prod.truckappl__c = article.truckappl;
        prod.truckax__c = article.truckax;

        //The following fields need to be set to true if they are not null
        prod.X3PMSF__c = article.pmsf != '' ? TRUE : FALSE;
        prod.Seal__c = article.seal != '' ? TRUE : FALSE;
        prod.Sound__c = article.sound != '' ? TRUE : FALSE;
        prod.Elt__c = article.elt != '' ? TRUE : FALSE;
        prod.Rof__c = article.rof != '' ? TRUE : FALSE;





        try {
            prod.VAT__c = article.vat != '' ? Decimal.valueOf(article.vat.replace(',', '.')) : 0;
        } catch (Exception e) {
            prod.VAT__c = 0;
        }

        // Get Product2 RecordType based on article.type
        if(ArticleRecordTypeMap.containsKey(article.type)){
            prod.RecordTypeId = ArticleRecordTypeMap.get(article.type);
        }

        for(WebCareArticle.EcoTaxDescription ecoTax : article.ecoTaxDescription){
            if(ecoTax.lang == 'nl') {
                prod.Ecotax_Description_NL__c = ecoTax.value;
            }
            if(ecoTax.lang == 'fr') {
                prod.Ecotax_Description_FR__c = ecoTax.value;
            }
        }

        for(WebCareArticle.Description descr : article.description){
            if(descr.lang == 'nl'){
                prod.Description_NL__c = descr.value;
            }
            if(descr.lang == 'fr'){
                prod.Description_FR__c = descr.value;
            }
        }

        for(WebCareArticle.Description descr : article.commercial){
            if(descr.lang == 'nl'){
                prod.Commercial_Description__c = descr.value;
            }
        }

        for(WebCareArticle.Qr QR : article.Qr){
            if(QR.type == 'eprel'){
                prod.QR_Eprel__c = QR.value;
            }
            if(QR.type == 'fr'){
                prod.QR_Supplier__c = QR.value;
            }
        }

        prod.Dimension_Indexed__c = productDimension(prod);


        return prod;
    }

    public static String productDimension(Product2 prod){
        //Dim1__c & ' ' & Serie__c & ' ' & Category__c & ' ' & Dim3__c & ' ' & Drvm__c & ' ' & Speed__c

        String dimension;

        dimension = prod.Dim1__c + ' ' + prod.Serie__c + ' ' + prod.Category__c + ' ' + prod.Dim3__c + ' ' + prod.Drvm__c + ' ' + prod.Speed__c;

        return dimension;
    }

}