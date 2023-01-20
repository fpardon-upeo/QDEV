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
 * Created: 17/11/2022
 * Last Updated: 17/11/2022
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

global class WebCareArticleSyncBatch implements Database.Batchable<Product2>,  Database.AllowsCallouts, Database.Stateful {

    public Integer pageNumber;
    public Boolean isLastBatch;

    public WebCareArticleSyncBatch(Integer pageNumber) {
        this.pageNumber = pageNumber;
    }

    global Iterable<Product2> start(Database.BatchableContext BC){
        system.debug('start, pageNumber: ' + pageNumber);
        WebCareArticleSync wcas = new WebCareArticleSync();
        List<Product2> products = wcas.startSync(pageNumber);
        if(products != null && products.size() >= 2998){
            isLastBatch = false;
            System.debug('isLastBatch: ' + isLastBatch + ' and should not be the last batch');
            pageNumber++;
        } else {
            system.debug('isLastBatch: ' + isLastBatch + ' and should not be the last batch');
            isLastBatch = true;
        }
        return products;
    }

    global void execute(Database.BatchableContext BC, List<Product2> scope){

        System.debug('Executing batch');

        Schema.SObjectField f = Product2.Fields.Webcare_Id__c;
        List<Database.UpsertResult> resultList = DMLHandler.upsertRecordsWithReturn(f, scope);
        ProductCategory pc = [SELECT Id, Name FROM ProductCategory WHERE Name = 'Products' LIMIT 1];

        List<Product2> retryList = new List<Product2>();

        for(Integer i = 0; i < resultList.size(); i++){
            if(!resultList[i].isSuccess()){
                Product2 p = scope[i];
                p.Profile_Lookup__r = null;
                retryList.add(p);
            }
        }
        List<Database.UpsertResult> retryResults = Database.upsert(retryList, f, false);
        for(Database.UpsertResult ur : retryResults){
            if(!ur.isSuccess()){
                system.debug('Error: ' + ur.getErrors()[0].getMessage());
            }
        }

        WebCareArticleSync wcas = new WebCareArticleSync();
        wcas.initialize();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntriesStore = new List<PricebookEntry>();

        List<ProductCategoryProduct> productCategories = new List<ProductCategoryProduct>();

        for(Product2 p : scope){
            PricebookEntry pbe = wcas.transformPricebookEntry(p);
            PricebookEntry pbeStore = wcas.transformStorePricebookEntry(p);
            ProductCategoryProduct pcp = new ProductCategoryProduct();
            pricebookEntries.add(pbe);
            pricebookEntriesStore.add(pbeStore);
            pcp.Product = new Product2 (Webcare_Id__c = p.Webcare_Id__c);
            pcp.ProductCategoryId = pc.Id;
            pcp.WebCare_Id__c = p.Webcare_Id__c;
            productCategories.add(pcp);

        }

        Schema.SObjectField fPBE = PricebookEntry.Fields.Webcare_Id__c;
        Schema.SObjectField fPCP = ProductCategoryProduct.Fields.Webcare_Id__c;
        List<Database.UpsertResult> resultListPBE = DMLHandler.upsertRecordsWithReturn(fPBE, pricebookEntries);
        List<Database.UpsertResult> resultListPBEStore = DMLHandler.upsertRecordsWithReturn(fPBE, pricebookEntriesStore);
        List<Database.UpsertResult> resultListPCP = DMLHandler.upsertRecordsWithReturn(fPCP, productCategories);
    }

    global void finish(Database.BatchableContext BC){

        system.debug('Finished batch ' +isLastBatch + ' and page number: ' + pageNumber);
        if(isLastBatch == false){
            system.debug('Starting next batch');
            //WebCareArticleSyncBatch wcasb = new WebCareArticleSyncBatch(pageNumber);
            Id batchJobId = Database.executeBatch(new WebCareArticleSyncBatch(pageNumber), 500);
        }
    }
}