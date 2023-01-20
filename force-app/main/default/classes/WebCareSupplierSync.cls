/**
 * Created by fpardon on 21/11/2022.
 */

public with sharing class WebCareSupplierSync {

    @Future(callout=true)
    public static void getSuppliers(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/supplier', 'GET');
        WebCareSupplier suppliers = WebCareSupplier.parse(resp.getBody());
        transformSuppliers(suppliers);

    }

    public static void transformSuppliers(WebCareSupplier suppliers){

        List<Account> supplierList = new List<Account>();
        List<Contact> contactList = new List<Contact>();

        for(WebCareSupplier.Supplier wcSupplier : suppliers.suppliers){
            Account newSupp = new Account();
            newSupp.Name = wcSupplier.name;
            newSupp.Webcare_Id__c = wcSupplier.id;
            newSupp.Phone = wcSupplier.tel;
            newSupp.Email__c = wcSupplier.email;
            newSupp.Type = wcSupplier.type;
            supplierList.add(newSupp);


            for(WebCareSupplier.ContactPerson wcContact : wcSupplier.contactPersons){
                Contact newContact = new Contact();
                newContact.Webcare_Id__c = wcContact.id;
                newContact.FirstName = wcContact.firstName;
                if(wcContact.surName == null){
                    newContact.LastName = 'unknown';
                } else {
                    newContact.LastName = wcContact.surName;
                }
                newContact.Email = wcContact.email;
                newContact.Phone = wcContact.tel;
                newContact.Account = new Account(Webcare_Id__c = wcSupplier.id);
                system.debug('newContact: ' + newContact.LastName);
                contactList.add(newContact);
            }

        }

        Schema.SObjectField fAcc = Account.Fields.Webcare_Id__c;
        Schema.SObjectField fCon = Contact.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(fAcc, supplierList);
        DMLHandler.upsertRecords(fCon, contactList);

    }



}