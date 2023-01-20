/**
 * Created by fpardon on 30/11/2022.
 */

trigger ContactPointAddressTrigger on ContactPointAddress (after insert, after update) {

    if(Trigger.isAfter || Trigger.isUpdate){
        for(ContactPointAddress cpa : [Select id, Name, OwnerId, Street, City, PostalCode, CountryCode, CreatedBy.ContactId, CreatedBy.Contact.Email, CreatedBy.Contact.Webcare_Id__c FROM ContactPointAddress Where Id in :Trigger.new]){
            /*if(cpa.CreatedBy.ContactId != null){
                WebCareDeliveryAddressSync.syncAddress(cpa);
            }*/
            WebCareDeliveryAddressSync.syncAddress(cpa);
        }
    }
}