/**
 * Created by fpardon on 21/11/2022.
 */

public class WebCareArticlePriceSync {

    List<Pricebook2> wcPricebooks;
    PriceBook2 standardPricebook;

    ProductAttributeSet wcAttributeSet;
    Map<String, String> wcPricebookMap;
    List<Account> suppliers;
    Map<String, String> supplierCodes;
    Pricebook2 storePriceBook;
    String policyId;
    List<CommerceEntitlementProduct> existingProducts;
    Map<String, String> existingProductMap;
    List<ProductAttributeSetProduct> existingPAP;
    Map<String, String> existingPAPMap;



    public void init() {

        wcPricebooks = [SELECT Id, Name, Type__c FROM Pricebook2 WHERE IsStandard = false];
        standardPricebook = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true];
        wcAttributeSet = [SELECT Id FROM ProductAttributeSet LIMIT 1];
        wcPricebookMap = new Map<String, String>();
        suppliers = [select id, name, Webcare_Id__c from Account where type = 'manufacturer' OR type = 'alternative'];
        supplierCodes = new Map<String, String>();
        storePriceBook = [SELECT Id FROM PriceBook2 WHERE Name = 'QTeam B2B Price Book' LIMIT 1];
        policyId = [select id from CommerceEntitlementPolicy LIMIT 1].Id;

        for(Account supplier : suppliers) {
            supplierCodes.put(supplier.Webcare_Id__c, supplier.Name);
        }

        for(Pricebook2 pb : wcPricebooks){
            wcPricebookMap.put(pb.Type__c, pb.Id);
        }

    }
    @Future(callout=true)
    public static void getArticlePrices(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/articleprice', 'GET');
        WebCareArticlePrice articlePrices = WebCareArticlePrice.parse(resp.getBody());
        WebCareArticlePriceSync sync = new WebCareArticlePriceSync();
        sync.transformArticlePrices(articlePrices.articles);
    }

    public WebCareArticlePrice startsync(Integer pageNumber){
        init();

        HttpResponse resp = WebCareRest.doCallOut('/portal/articleprice/'+pageNumber, 'GET');
        System.debug('resp code = ' +resp.getStatusCode());
        WebCareArticlePrice articlePrices = WebCareArticlePrice.parse(resp.getBody());

        return articlePrices;


    }

    public void transformArticlePrices(List<WebCareArticlePrice.Article> articlePrices){

        Map<String, String> tokens = WebCareRest.getToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));

        wcPricebooks = [SELECT Id, Name, Type__c FROM Pricebook2 WHERE IsStandard = false];
        standardPricebook = [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = true];
        wcAttributeSet = [SELECT Id FROM ProductAttributeSet LIMIT 1];
        policyId = [select id from CommerceEntitlementPolicy LIMIT 1].Id;
        wcPricebookMap = new Map<String, String>();
        existingProducts = new List<CommerceEntitlementProduct>();
        existingProductMap = new Map<String, String>();
        existingPAP = new List<ProductAttributeSetProduct>();
        existingPAPMap = new Map<String, String>();



        List<PricebookEntry> standardPrices = new List<PricebookEntry>();
        List<PricebookEntry> wcPrices = new List<PricebookEntry>();
        List<PricebookEntry> storePrices = new List<PricebookEntry>();
        List<Product2> products = new List<Product2>();
        List<Product2> mainProducts = new List<Product2>();
        List<ProductAttributeSetProduct> attributeSetProducts = new List<ProductAttributeSetProduct>();
        List<ProductAttribute> productAttributes = new List<ProductAttribute>();
        List<CommerceEntitlementProduct > entitlementProducts = new List<CommerceEntitlementProduct >();

        //Create Map of WebCare Pricebook types and their Ids
        for(Pricebook2 pb : wcPricebooks){
            wcPricebookMap.put(pb.Type__c, pb.Id);
        }

        //Create List of current webcare Ids in the transaction
        List<String> webcareIds = new List<String>();
        List<String> mainWebcareIds = new List<String>();
        for(WebCareArticlePrice.Article article : articlePrices){
            String webcareId = article.article;
            mainWebcareIds.add(webcareId);
            webcareIds.add(webcareId);
            for(WebCareArticlePrice.Supplier supplier : article.supplier){
                webcareIds.add(article.article + '-' + supplier.id);
            }
        }

        //Query existing Entitlement Products
        existingProducts = [select id, ProductId, Webcare_Id__c from CommerceEntitlementProduct where Webcare_Id__c in :webcareIds];
        system.debug('existingProducts: ' + existingProducts.size());
        List<Product2> parentProducts = [select id, Webcare_Id__c from Product2 where Webcare_Id__c in :mainWebcareIds];
        system.debug('parentProducts: ' + parentProducts.size());
        Map<String, String> parentProductMap = new Map<String, String>();

        for(Product2 parentProduct : parentProducts){
            parentProductMap.put(parentProduct.Webcare_Id__c, parentProduct.Id);
        }

        //Create a map of existing Entitlement Products and webcare ids with the webcare id as the key and the entitlement product id as the value
        existingProductMap = new Map<String, String>();
        for(CommerceEntitlementProduct product : existingProducts){
            existingProductMap.put(product.Webcare_Id__c, product.Id);
        }

        existingPAP = [SELECT Id, Webcare_Id__c FROM ProductAttributeSetProduct WHERE Webcare_Id__c in :webcareIds];
        System.debug('existingPAP: ' + existingPAP.size());
        System.debug('webcareIds: ' + webcareIds.size());
        for(ProductAttributeSetProduct pap : existingPAP){
            existingPAPMap.put(pap.Webcare_Id__c, pap.Id);
        }


        //Create PricebookEntries for each WebCare Pricebook

        for(WebCareArticlePrice.Article articlePrice : articlePrices) {

            string externalParentId = articlePrice.article;
            if (parentProductMap.containsKey(externalParentId)) {

                //First create standard pricebook entry for parent articles
                PricebookEntry pbe = this.createPriceBPricebookEntry(articlePrice);
                PricebookEntry pbeStore = this.createPricePricebookStoreEntry(articlePrice);
                standardPrices.add(pbe);
                storePrices.add(pbeStore);

                //Add the parent article to the Entitlement Policy List
                CommerceEntitlementProduct cepParent = new CommerceEntitlementProduct();
                if (!existingProductMap.containsKey(articlePrice.article)) {
                    System.debug('adding parent to entitlements');
                    cepParent.PolicyId = policyId;
                    cepParent.Product = new Product2(Webcare_Id__c = articlePrice.article);
                    cepParent.Webcare_Id__c = articlePrice.article;
                    entitlementProducts.add(cepParent);
                }

                ProductAttributeSetProduct papParent = new ProductAttributeSetProduct();
                if (!existingPAPMap.containsKey(articlePrice.article)) {
                    System.debug('adding parent to attribute set');
                    papParent.ProductAttributeSetId = wcAttributeSet.Id;
                    papParent.Product = new Product2(Webcare_Id__c = articlePrice.article);
                    papParent.Webcare_Id__c = articlePrice.article;
                    attributeSetProducts.add(papParent);
                }


                //Then create Variation Product records
                for (WebCareArticlePrice.Supplier supplier : articlePrice.supplier) {

                    string externalChildId = articlePrice.article + '-' + supplier.id;

                    Product2 variationProduct = this.createVariationProduct(supplier, articlePrice);
                    products.add(variationProduct);

                    //Create Product Attribute Set Products

                    /*
                ProductAttributeSetProduct pasp = this.createProductAttributeSetProduct(articlePrice, supplier);
                if(!existingPAPMap.containsKey(articlePrice.article)){
                    System.debug('pasp: ' + pasp.Webcare_Id__c);
                    system.debug('pasp from map: ' + existingPAPMap.get(pasp.Webcare_Id__c));
                    attributeSetProducts.add(pasp);
                }
                
                 */

                    //Create Product Attributes
                    ProductAttribute pa = this.createProductAttribute(supplier, articlePrice);
                    productAttributes.add(pa);

                    //Create StandardPricebookEntries for each supplier article
                    PricebookEntry standardVariationPbe = this.createStandardPriceBookEntriesForVariations(supplier, articlePrice);
                    standardPrices.add(standardVariationPbe);

                    //Use the current standard price book entry record to update the list price on the main product
                    Product2 mainProduct = new Product2();
                    mainProduct.Webcare_Id__c = articlePrice.article;
                    mainProduct.List_Price__c = standardVariationPbe.UnitPrice;
                    mainProduct.hasVariations__c = true;
                    if (!mainProducts.contains(mainProduct)) {
                        mainProducts.add(mainProduct);
                    }

                    CommerceEntitlementProduct cep = this.createCommerceEntitlementProduct(supplier, articlePrice);
                    cep.webcare_id__c = articlePrice.article + '-' + supplier.id;
                    if (!existingProductMap.containsKey(cep.Webcare_Id__c)) {
                        system.debug('adding entitlement product: ' + cep.Webcare_Id__c);
                        entitlementProducts.add(cep);
                    }

                    //Create PricebookEntries for each WebCare Pricebook
                    for (WebCareArticlePrice.Prices prices : supplier.prices) {

                        PricebookEntry wcPbe = this.createSupplierPriceBookEntry(supplier, prices, articlePrice);
                        wcPrices.add(wcPbe);
                    }
                }
            }
        }


        //Create product
        Schema.SObjectField fPRod = Product2.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fPRod, products);
        DMLHandler.upsertRecords(fPRod, mainProducts);

        //Create Standard PricebookEntries
        Schema.SObjectField fPBE = PricebookEntry.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fPBE, standardPrices);
        DMLHandler.upsertRecords(fPBE, storePrices);

        //Create Webcare PricebookEntries
        DMLHandler.upsertRecords(fPBE, wcPrices);

        //Create Product Attribute Set Products
        Schema.SObjectField fPASP = ProductAttributeSetProduct.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fPASP, attributeSetProducts);

        //Create product attributes
        Schema.SObjectField fPA = ProductAttribute.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fPA, productAttributes);

        //Create commerce entitlement products
        Schema.SObjectField fCEP = CommerceEntitlementProduct.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fCEP, entitlementProducts);

    }

    public CommerceEntitlementProduct  createCommerceEntitlementProduct(WebCareArticlePrice.Supplier supplier, WebCareArticlePrice.Article articlePrice){

        CommerceEntitlementProduct cep = new CommerceEntitlementProduct();

        cep.Product = new Product2(Webcare_Id__c = articlePrice.article + '-' + supplier.id);
        cep.PolicyId = policyId;
        cep.Webcare_Id__c = articlePrice.article;

        return cep;

    }

    public PricebookEntry createPriceBPricebookEntry(WebCareArticlePrice.Article articlePrice){

        PricebookEntry pbe = new PricebookEntry();
        pbe.Webcare_Id__c = articlePrice.article+'-std';
        pbe.Product2 = new Product2(Webcare_Id__c = articlePrice.article);
        pbe.Pricebook2Id = standardPricebook.Id;
        pbe.UnitPrice = DMLHandler.stringToDecimal(articlePrice.priceRate);
        pbe.IsActive = true;
        return pbe;

    }

    public PricebookEntry createPricePricebookStoreEntry(WebCareArticlePrice.Article articlePrice){

        PricebookEntry pbe = new PricebookEntry();
        pbe.Webcare_Id__c = articlePrice.article+ '-store';
        pbe.Product2 = new Product2(Webcare_Id__c = articlePrice.article);
        pbe.Pricebook2Id = storePriceBook.Id;
        pbe.UnitPrice = DMLHandler.stringToDecimal(articlePrice.priceRate);
        pbe.IsActive = true;
        return pbe;

    }

    public Product2 createVariationProduct(WebCareArticlePrice.Supplier supplier, WebCareArticlePrice.Article articlePrice){
        String uniqueId = articlePrice.article + '-' + supplier.id;
        Product2 variationProduct = new Product2();
        variationProduct.Webcare_Id__c = uniqueId;
        variationProduct.Name = uniqueId;
        variationProduct.ProductCode = articlePrice.article;
        variationProduct.Supplier__r = new Account(Webcare_Id__c = supplier.id);
        variationProduct.Available_Quantity_1__c = supplier.quantity1;
        variationProduct.Available_Quantity_2__c = supplier.quantity2;
        variationProduct.Available_Quantity_3__c = supplier.quantity3;
        variationProduct.Delivery_Date_1__c = DMLHandler.stringToDate(supplier.deliveryDate1);
        variationProduct.Delivery_Date_2__c = DMLHandler.stringToDate(supplier.deliveryDate2);
        variationProduct.Delivery_Date_3__c = DMLHandler.stringToDate(supplier.deliveryDate3);
        if(variationProduct.Delivery_Date_3__c.year() == 9999){
            variationProduct.Delivery_Date_3__c = null;
        }
        variationProduct.IsActive = true;
        variationProduct.Parent__r = new Product2(Webcare_Id__c = articlePrice.article);
        return variationProduct;
    }

    public ProductAttributeSetProduct createProductAttributeSetProduct(WebCareArticlePrice.Article articlePrice, WebCareArticlePrice.Supplier supplier){
        ProductAttributeSetProduct pasp = new ProductAttributeSetProduct();
        pasp.ProductAttributeSetId = wcAttributeSet.Id;
        pasp.Product = new Product2(Webcare_Id__c = articlePrice.article);
        pasp.Webcare_Id__c = articlePrice.article + '-' + supplier.id;
        return pasp;
    }

    public ProductAttribute createProductAttribute(WebCareArticlePrice.Supplier supplier, WebCareArticlePrice.Article articlePrice){
        ProductAttribute pa = new ProductAttribute();
        String uniqueId = articlePrice.article + '-' + supplier.id;
        pa.Product = new Product2(Webcare_Id__c = uniqueId);
        pa.VariantParent = new Product2(Webcare_Id__c = articlePrice.article);
        pa.Supplier__r = new Account(Webcare_Id__c = supplier.id);
        pa.Supplier_Type__c = 'Wholesaler';
        pa.Webcare_Id__c = uniqueId;
        pa.Supplier_List__c = 'MICHELIN NV';
        return pa;
    }

    public PriceBookEntry createStandardPriceBookEntriesForVariations(WebCareArticlePrice.Supplier supplier, WebCareArticlePrice.Article articlePrice){
        PricebookEntry standardVariationPbe = new PricebookEntry();
        String uniqueId = articlePrice.article + '-' + supplier.id;
        standardVariationPbe.Webcare_Id__c = uniqueId + '-' + 'std';
        standardVariationPbe.Product2 = new Product2(Webcare_Id__c = uniqueId);
        standardVariationPbe.Pricebook2Id = standardPricebook.Id;
        standardVariationPbe.UnitPrice = DMLHandler.stringToDecimal(articlePrice.priceRate);
        standardVariationPbe.IsActive = true;
        return standardVariationPbe;
    }

    public PriceBookEntry createSupplierPriceBookEntry(WebCareArticlePrice.Supplier supplier, WebCareArticlePrice.Prices prices, WebCareArticlePrice.Article articlePrice) {
        String uniqueId = articlePrice.article + '-' + supplier.id;
        PricebookEntry wcPbe = new PricebookEntry();
        wcPbe.Webcare_Id__c = uniqueId + '-' + prices.type;
        wcPbe.Product2 = new Product2(Webcare_Id__c = uniqueId);
        wcPbe.Pricebook2Id = wcPricebookMap.get(prices.type);
        wcPbe.UnitPrice = DMLHandler.stringToDecimal(prices.value);
        wcPbe.IsActive = true;
        return wcPbe;

    }
}