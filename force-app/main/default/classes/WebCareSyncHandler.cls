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
 * Created: 13/12/2022
 * Last Updated: 13/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

public with sharing class WebCareSyncHandler {

    @AuraEnabled
    public static String getSuppliers(){
        WebCareSupplierSync.getSuppliers();
        AsyncApexJob jobInfo = [SELECT Id  FROM AsyncApexJob where MethodName='getSuppliers' and Status='Queued' and CreatedDate = TODAY order by CreatedDate desc limit 1];
        return jobInfo.Id;
    }

    @AuraEnabled
    public static String getBrands(){
        WebCareBrandSync.getBrands();
        AsyncApexJob jobInfo = [SELECT Id  FROM AsyncApexJob where MethodName='getBrands' and Status='Queued' and CreatedDate = TODAY order by CreatedDate desc limit 1];
        return jobInfo.Id;
    }

    @AuraEnabled
    public static String getCustomers(){
        Datetime start = Datetime.now();
        WebCareCustomerSync.getCustomers();
        List<Account> aList = [SELECT Id  FROM Account where LastModifiedDate >= :start];
        return aList.size() + ' Accounts were updated';
    }

    @AuraEnabled
    public static String getTransportCosts(){
        Datetime start = Datetime.now();
        WebCareTransportCostSync.getTransportCosts();
        List<Transport_Cost__c> tCosts = [SELECT Id FROM Transport_Cost__c where LastModifiedDate >= :start];
        return tCosts.size() + ' Transport Costs were updated';
    }

    @AuraEnabled
    public static String getProfiles(){
        WebCareProfileSync.getProfiles();
        AsyncApexJob jobInfo = [SELECT Id  FROM AsyncApexJob where MethodName='getProfiles' and Status='Queued' and CreatedDate = TODAY order by CreatedDate desc limit 1];
        return jobInfo.Id;
    }

    @AuraEnabled
    public Static String getArticles(){
        String jobId = Database.executeBatch(new WebCareArticleSyncBatch(1), 400);
        return jobId;
    }

    @AuraEnabled
    public Static String getArticlePrices(){
        String jobId = Database.executeBatch(new WebCareArticlePriceSyncBatch(1), 500);
        return jobId;
    }

    @AuraEnabled
    public static AsyncApexJob getArticleBatchJob(){
        AsyncApexJob job = new AsyncApexJob();
        try {
            job = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'WebCareArticleSyncBatch' AND Status != 'Completed' And Status != 'Failed' And Status != 'Failed' And Status != 'Aborted' AND CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 1];
            return job;
        } catch (Exception e) {
            System.debug(e);
        }
        return null;
    }

    @AuraEnabled
    public static AsyncApexJob getArticlePricesBatchJob(){
        AsyncApexJob job = new AsyncApexJob();
        try {
            job = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'WebCareArticlePriceSyncBatch' AND Status != 'Completed' And Status != 'Failed' And Status != 'Aborted' AND CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 1];
            return job;
        } catch (Exception e) {
            System.debug(e);
        }
        return null;
    }

    @AuraEnabled
    public static AsyncApexJob monitorJob(String jobId){
        AsyncApexJob jobInfo = [SELECT Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, JobType, TotalJobItems FROM AsyncApexJob where Id = :jobId];
        return jobInfo;
    }

}