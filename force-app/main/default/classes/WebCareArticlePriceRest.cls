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
 * Created: 24/11/2022
 * Last Updated: 24/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
Description:

Change Log:

Dependencies:

*/

@RestResource(urlMapping='/v1/ArticlePrice')
global class WebCareArticlePriceRest {


    @HttpPost
    global static List<String> updateArticlePrice(){

        //----------------------------------------INITIALIZE----------------------------------------------------------//



        RestRequest request = RestContext.request;
        String body = (String) request.requestBody.toString();

        WebCareArticlePrice.Article wcArticlePrice = WebCareArticlePrice.parseSingleArticle(body);
        System.debug('articlePrice: ' + wcArticlePrice);
        WebCareArticlePrice articlePrices = new WebCareArticlePrice();
        articlePrices.articles = new List<WebCareArticlePrice.Article>();
        articlePrices.articles.add(wcArticlePrice);
        System.debug('webCareArticlePrice.articles: ' + articlePrices.articles);

        WebCareArticlePriceSync wAPS = new WebCareArticlePriceSync();
        wAPS.init();

        //----------------------------------------TRANSFORM-----------------------------------------------------------//

        List<PricebookEntry> standardPrices = new List<PricebookEntry>();
        List<PricebookEntry> wcPrices = new List<PricebookEntry>();
        List<Product2> products = new List<Product2>();
        List<ProductAttributeSetProduct> attributeSetProducts = new List<ProductAttributeSetProduct>();
        List<ProductAttribute> productAttributes = new List<ProductAttribute>();
        List<String> resultList = new List<String>();

        List<ProductAttributeSetProduct> existingPAP;
        existingPAP = [SELECT Id, Webcare_Id__c FROM ProductAttributeSetProduct WHERE Product.Webcare_Id__c = :wcArticlePrice.article];
        Map<String, String> existingPAPMap = new Map<String, String>();

        for(ProductAttributeSetProduct pap : existingPAP){
            existingPAPMap.put(pap.Webcare_Id__c, pap.Id);
        }

        for(WebCareArticlePrice.Article articlePrice : articlePrices.articles){

            //First create standard pricebook entry for parent articles
            standardPrices.add(wAPS.createPriceBPricebookEntry(articlePrice));


            for(WebCareArticlePrice.Supplier supplier : articlePrice.supplier){

                //Then create Variation Product records for each supplier
                products.add(wAPS.createVariationProduct(supplier, articlePrice));

                //Create Product Attribute Set Products
                ProductAttributeSetProduct pap = wAPS.createProductAttributeSetProduct(articlePrice, supplier);
                if(!existingPAPMap.containsKey(pap.Webcare_Id__c)){
                    attributeSetProducts.add(pap);
                }

                //Create Product Attributes
                productAttributes.add(wAPS.createProductAttribute(supplier, articlePrice));

                //Create StandardPricebookEntries for each supplier article
                standardPrices.add(wAPS.createStandardPriceBookEntriesForVariations(supplier, articlePrice));

                for(WebCareArticlePrice.Prices prices : supplier.prices){
                    //Create PricebookEntries for each WebCare Pricebook
                    wcPrices.add(wAPS.createSupplierPriceBookEntry(supplier, prices, articlePrice));
                }
            }
        }

        //----------------------------------------INSERT-------------------------------------------------------------//


        Schema.SObjectField fPRod = Product2.Fields.Webcare_Id__c;
        Schema.SObjectField fPBE = PricebookEntry.Fields.Webcare_Id__c;
        Schema.SObjectField fPASP = ProductAttributeSetProduct.Fields.Webcare_Id__c;
        Schema.SObjectField fPA = ProductAttribute.Fields.Webcare_Id__c;

        //Create product
        resultList.add(handleDML(products, 'Webcare Product Upsert', fPRod ));

        //Create Standard PricebookEntries
        resultList.add(handleDML(standardPrices, 'Webcare Product Upsert', fPBE ));

        //Create Webcare Prices
        resultList.add(handleDML(wcPrices, 'Webcare Product Upsert',fPBE));

        //Create Product Attribute Set Products
        if(!attributeSetProducts.isEmpty()){
            handleDML(attributeSetProducts, 'Webcare Product Attribute Set Products Upsert', fPASP);
        }


        //Create product attributes
        resultList.add(handleDML(productAttributes, 'Webcare Product Attributes Upsert', fPA));


        return resultList;

    }

    global static String handleDML(List<SObject> records, String operation, Schema.SObjectField field){


        String result = '';
        List<DataBase.UpsertResult> upsertResult = Database.upsert(records, field, false);
        Database.UpsertResult ur = upsertResult[0];
        System.debug('ur: ' + ur);
        if(ur.isSuccess()) {
            result = 'Success, ' + operation + ' Id:' + ur.getId();
            return result;
        } else {
            result = 'Error: ' + ur.getErrors()[0].getMessage();
            Error_Log__c errorLog = DMLhandler.errorLogger(ur.getErrors()[0], records[0], operation);
            insert errorLog;
            return result;
        }
    }

}