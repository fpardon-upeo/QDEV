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
@RestResource(urlMapping='/v1/Customer')
global class WebCareCustomerRest {


    @HttpPost
    global static List<String> updateCustomer(){

    //----------------------------------------INITIALIZE-------------------------------------------------------------//


        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<BuyerAccount> buyerAccounts = new List<BuyerAccount>();
        List<BuyerGroupMember> buyerGroupMembers = new List<BuyerGroupMember>();
        List<Supplier_Access__c> supplierAccess = new List<Supplier_Access__c>();
        List<String> supplierAccessActiveIds = new List<String>();

        List<String> accountWebCareIds = new List<String>();
        List<String> resultList = new List<String>();

        RestRequest request = RestContext.request;
        String body = (String) request.requestBody.toString();

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'QTeam Community Plus User' LIMIT 1 ].Id;

    //----------------------------------------PARSE-----------------------------------------------------------------//

        WebCareCustomer.Customer wcCustomer = WebCareCustomer.parseSingleUser(body);

    //----------------------------------------TRANSFORM-------------------------------------------------------------//

        Account account = WebCareCustomerSync.createAccount(wcCustomer);
        Contact contact = WebCareCustomerSync.createContact(wcCustomer);
        BuyerAccount buyerAccount = WebCareCustomerSync.createBuyerAccount(wcCustomer);
        List<Supplier_Access__c> supplierAccessList = WebCareCustomerSync.createActiveSupplierAccess(wcCustomer);

        for(Supplier_Access__c sa : supplierAccessList){
            supplierAccessActiveIds.add(sa.Webcare_Id__c);
        }
        supplierAccess.addAll(supplierAccessList);

        List<Supplier_Access__c> supplierAccessListBlocked = WebCareCustomerSync.createBlockedSupplierAccess(wcCustomer);
        for(Supplier_Access__c sa : supplierAccessListBlocked){
            Integer index = supplierAccessActiveIds.indexOf(sa.Webcare_Id__c);
            System.debug('Index: ' + index);
            if(index == -1){
                supplierAccess.add(sa);
            } else {
                supplierAccess[index].Status__c = 'Blocked';
            }
        }

        //Remove all supplier access that are not in the list
        for(String sa : supplierAccessActiveIds){

        }



    //----------------------------------------DML-------------------------------------------------------------------//

        accounts.add(account);
        contacts.add(contact);
        buyerAccounts.add(buyerAccount);


        resultList.add(handleDML(accounts, 'Account Upsert WebCare', 'fAcc'));
        resultList.add(handleDML(contacts, 'Contact Upsert WebCare', 'fCon'));
        resultList.add(handleDML(buyerAccounts, 'BuyerAccount Upsert WebCare', 'fBuy'));
        resultList.add(handleDML(supplierAccess, 'Supplier Access Upsert WebCare', 'fSuppAccess'));

        //Check whether the Account upsert was successful before trying to create the BuyerGroupMember
        if(resultList[0].startsWith('Success')){
            accountWebCareIds.add(wcCustomer.client.id);
            buyerGroupMembers = WebCareCustomerSync.createBuyerGroupMember(accountWebCareIds);
            system.debug('buyerGroupMembers: ' + buyerGroupMembers);
            resultList.add(handleDML(buyerGroupMembers, 'BuyerGroupMember Upsert WebCare', 'fBuyerGroupMember'));

        }

        //Handle the User upsert asynchroniously to avoid Mixed DML errors
        handleUserUpsert(body, profileId);


    //----------------------------------------RETURN---------------------------------------------------------------//

        return resultList;

    }

    @Future
    public static void handleUserUpsert(String JSONResponse, Id profileId){

        List<User> customerUsers = new List<User>();
        WebCareCustomer.Customer wcCustomer = WebCareCustomer.parseSingleUser(JSONResponse);
        User customerUser = WebCareCustomerSync.createUser(wcCustomer, profileId);
        customerUsers.add(customerUser);
        List<Database.SaveResult> userSaveResults = Database.insert(customerUsers, false);
        List<String> userIds = new List<String>();
        for(Database.SaveResult sr : userSaveResults){
            if(sr.isSuccess()){
                userIds.add(sr.getId());
            }
        }

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Named_Credential' LIMIT 1];
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        for(String u : userIds){
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = u);
            psaList.add(psa);
        }

        List<Database.SaveResult> sr = Database.insert(psaList, false);
        for(Database.SaveResult s : sr){
            if(s.isSuccess()){
                system.debug('PermissionSetAssignment created');
            } else {
                system.debug('PermissionSetAssignment not created');
            }
        }

    }

    global static String handleDML(List<SObject> records, String operation, String field){

        Schema.SObjectField fAcc = Account.Fields.Webcare_Id__c;
        Schema.SObjectField fCon = Contact.Fields.Webcare_Id__c;
        Schema.SObjectField fBuy = BuyerAccount.Fields.Webcare_Id__c;
        Schema.SObjectField fBuyGM = BuyerGroupMember.Fields.Webcare_Id__c;
        Schema.SObjectField fUser = User.Fields.Webcare_Id__c;
        Schema.SObjectField fSuppAccess = Supplier_Access__c.Fields.Webcare_Id__c;

        Schema.SObjectField f;

        if(field == 'fAcc'){
            f = fAcc;
        } else if(field == 'fCon'){
            f = fCon;
        } else if(field == 'fBuy'){
            f = fBuy;
        } else if(field == 'fBuyerGroupMember'){
            f = fBuyGM;
        } else if(field == 'fUser'){
            f = fUser;
        } else if(field == 'fSuppAccess'){
            f = fSuppAccess;
        }

        String result = '';
        List<DataBase.UpsertResult> upsertResult = Database.upsert(records, f, false);
        if(upsertResult.size() > 0) {
            Database.UpsertResult ur = upsertResult[0];
            System.debug('ur: ' + ur);
            if (ur.isSuccess()) {
                result = 'Success, ' + operation + ' Id:' + ur.getId();
                return result;
            } else {
                result = 'Error: ' + ur.getErrors()[0].getMessage();
                Error_Log__c errorLog = DMLhandler.errorLogger(ur.getErrors()[0], records[0], operation);
                insert errorLog;
                return result;
            }
        }
        return result;
    }
}