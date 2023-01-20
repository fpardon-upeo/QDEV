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
 * Created: 22/11/2022
 * Last Updated: 22/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
**/

public with sharing class WebCareCustomerSync {

    public static void getCustomers(){

        System.debug('Starting WebCareCustomerSync.getCustomers()');

        HttpResponse resp = WebCareRest.doCallOut('/portal/users', 'GET');
        WebcareCustomer wcCustomers = WebcareCustomer.parseMultipleUsers(resp.getBody());
        System.debug('WebcareCustomer: ' + wcCustomers);
        transformCustomers(wcCustomers);

    }

    public static void transformCustomers(WebcareCustomer wcCustomers){

        //Save refresh token after last callout
        //Map<String, String> tokens = WebCareRest.getToken();
        //WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));

        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<BuyerAccount> buyerAccounts = new List<BuyerAccount>();
        List<User> customerUsers = new List<User>();
        List<BuyerGroupMember> buyerGroupMembers = new List<BuyerGroupMember>();
        List<String> accountWebCareIds = new List<String>();
        List<Supplier_Access__c> supplierAccess = new List<Supplier_Access__c>();
        List<String> supplierAccessActiveIds = new List<String>();

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'QTeam Community Plus User' LIMIT 1 ].Id;

        List<String> accIds = new List<String>();

        //Create a list of all webcare Ids of customers we get
        for(WebCareCustomer.Customer wcCustomer : wcCustomers.customers){
            accIds.add(wcCustomer.client.id);
        }

        List<Supplier_Access__c> supplierAccessRecords = [SELECT Id, Webcare_Id__c FROM Supplier_Access__c WHERE Account__r.Webcare_Id__c IN :accIds];
        System.debug('supplierAccessRecords: ' + supplierAccessRecords);
        delete supplierAccessRecords;

        for(WebCareCustomer.Customer wcCustomer : wcCustomers.customers){

            System.debug('WebCareCustomer.Customer: ' + wcCustomer);

            //First Create Account;
            Account account = createAccount(wcCustomer);
            accounts.add(account);
            accountWebCareIds.add(account.Webcare_Id__c);

            //Then Create Contacts
            Contact contact = createContact(wcCustomer);
            contacts.add(contact);

            //Then Create Buyer Account
            BuyerAccount buyerAccount = createBuyerAccount(wcCustomer);
            buyerAccounts.add(buyerAccount);

            //First we parse the result to get all the Active Suppliers and references
            List<Supplier_Access__c> supplierAccessList = createActiveSupplierAccess(wcCustomer);
            //Then we add the webcare ids to a list so we can compare it to the blocked supplier list in the next action
            for(Supplier_Access__c sa : supplierAccessList){
                supplierAccessActiveIds.add(sa.Webcare_Id__c);
            }
            supplierAccess.addAll(supplierAccessList);


            //Now we parse the blocked suppliers
            List<Supplier_Access__c> supplierAccessListBlocked = createBlockedSupplierAccess(wcCustomer);
            //We compare the blocked suppliers to the active suppliers and update the blocked parameter if it is in the active list
            //If we don't find a match we just add it to the list
            for(Supplier_Access__c sa : supplierAccessListBlocked){
                Integer index = supplierAccessActiveIds.indexOf(sa.Webcare_Id__c);
                System.debug('Index: ' + index);
                if(index == -1){
                    supplierAccess.add(sa);
                } else {
                    supplierAccess[index].Status__c = 'Blocked';
                }
            }

            //Then Create User
            User customerUser = createUser(wcCustomer, profileId);
            customerUsers.add(customerUser);
        }


        Schema.SObjectField fAcc = Account.Fields.Webcare_Id__c;
        Schema.SObjectField fCon = Contact.Fields.Webcare_Id__c;
        Schema.SObjectField fBuy = BuyerAccount.Fields.Webcare_Id__c;
        Schema.SObjectField fUser = User.Fields.Webcare_Id__c;
        Schema.SObjectField fBuyGrpMem = BuyerGroupMember.Fields.Webcare_Id__c;
        Schema.SObjectField fSuppAccess = Supplier_Access__c.Fields.Webcare_Id__c;

        DMLHandler.upsertRecords(fAcc, accounts);
        DMLHandler.upsertRecords(fCon, contacts);
        DMLHandler.upsertRecords(fBuy, buyerAccounts);
        DMLHandler.upsertRecords(fSuppAccess, supplierAccess);

        List<Contact> updatedContacts = [SELECT Id, Webcare_Id__c FROM Contact WHERE Account.Webcare_Id__c IN :accountWebCareIds];
        Map<String, String> contactMap = new Map<String, String>();
        for(Contact con : updatedContacts){
            contactMap.put(con.Webcare_Id__c, con.Id);
        }


        for(User user : customerUsers){
            user.ContactId = contactMap.get(user.Webcare_Id__c);
        }

        buyerGroupMembers = createBuyerGroupMember(accountWebCareIds);
        DMLHandler.upsertRecords(fBuyGrpMem, buyerGroupMembers);

        upsertUser(contactMap, profileId, JSON.serialize(wcCustomers));

    }

    @future
    public static void upsertUser(Map<String, String> contactMap, String profileId, String customersJSON){

        WebcareCustomer wcCustomers = WebcareCustomer.parseMultipleUsers(customersJSON);

        List<User> customerUsers = new List<User>();
        for(WebCareCustomer.Customer wcCustomer : wcCustomers.customers){
            User customerUser = createUser(wcCustomer, profileId);
            customerUser.ContactId = contactMap.get(customerUser.Webcare_Id__c);
            System.debug('User: ' + customerUser);
            System.debug('ContactId: ' + customerUser.ContactId);
            customerUsers.add(customerUser);
        }

        Schema.SObjectField fUser = User.Fields.Webcare_Id__c;
        Database.upsert(customerUsers, fUser, false);


    }

    public static Account createAccount(WebCareCustomer.Customer wcCustomer){

        Account account = new Account();

        account.Name = wcCustomer.client.name;
        account.AccountNumber = wcCustomer.client.Id;
        account.Webcare_Id__c = wcCustomer.client.id;
        account.Type = getAccountType(wcCustomer.partnerType);
        account.Blocked_Customer__c = wcCustomer.blockedCustomer;
        account.Price_Grid__c = wcCustomer.priceGrid;
        account.Partner_Type__c = wcCustomer.partnerType;
        account.BillingStreet = wcCustomer.mainAddress.street + ' ' + wcCustomer.mainAddress.number_z;
        account.BillingCity = wcCustomer.mainAddress.city;
        account.BillingPostalCode = wcCustomer.mainAddress.zip;
        account.BillingCountryCode = wcCustomer.mainAddress.country;
        account.Credit_Limit__c = wcCustomer.creditLimit == '' ? 0 : Decimal.valueOf(wcCustomer.creditLimit);
        account.Amount_Overdue__c = wcCustomer.amountOverdue == '' ? 0 : Decimal.valueOf(wcCustomer.amountOverdue);
        account.Open_Amount__c = wcCustomer.openAmount == '' ? 0 : Decimal.valueOf(wcCustomer.openAmount);
        return account;
    }

    public static Contact createContact(WebCareCustomer.Customer wcCustomer){

        Contact contact = new Contact();

        //Temp fix for nullpointer, should be taken care of in webcare but will do for now
        if(wcCustomer.surname == ''){
            contact.LastName = 'unknown';
        } else {
            contact.LastName = wcCustomer.surname;
        }

        contact.FirstName = wcCustomer.firstName;
        contact.Email = wcCustomer.email;
        contact.Account = new Account(Webcare_Id__c = wcCustomer.client.Id);
        contact.Webcare_Id__c = wcCustomer.id;

        return contact;
    }

    public static BuyerAccount createBuyerAccount(WebCareCustomer.Customer wcCustomer){

        BuyerAccount buyerAccount = new BuyerAccount();
        buyerAccount.Buyer = new Account(Webcare_Id__c = wcCustomer.client.Id);
        buyerAccount.Name = wcCustomer.client.Id;
        buyerAccount.IsActive = true;
        buyerAccount.BuyerStatus = 'Active';
        buyerAccount.Webcare_Id__c = wcCustomer.client.Id;

        return buyerAccount;
    }

    public static User createUser(WebCareCustomer.Customer wcCustomer, String profileId){

        System.debug('Creating user for Profile : ' + profileId);

        User customerUser = new User();

        if(wcCustomer.surname == ''){
            customerUser.LastName = 'unknown';
        } else {
            customerUser.LastName = wcCustomer.surname;
        }
        String userAlias = wcCustomer.email.split('@')[0];


        customerUser.Username = wcCustomer.email+'.webcare';
        customerUser.Email = wcCustomer.email+ '.webcare';
        customerUser.FirstName = wcCustomer.firstName;
        customerUser.Alias = userAlias.left(8);
        customerUser.CommunityNickname = userAlias;
        customerUser.EmailEncodingKey = 'ISO-8859-1';
        customerUser.LanguageLocaleKey = 'en_US';
        customerUser.LocaleSidKey = 'fr_BE';
        customerUser.TimeZoneSidKey = 'Europe/Paris';
        customerUser.ProfileId = profileId;
        customerUser.IsActive = !wcCustomer.blockedCustomer;
        //customerUser.Contact = new Contact(Webcare_Id__c = wcCustomer.id);
        customerUser.Webcare_Id__c = wcCustomer.id;
        customerUser.Tourism__c = wcCustomer.modules.tourism;
        customerUser.Moto__c = wcCustomer.modules.moto;
        customerUser.Truck__c = wcCustomer.modules.truck;
        customerUser.Type_of_User__c = wcCustomer.partnerType + wcCustomer.priceGrid;
        return customerUser;
    }

    public Static List<BuyerGroupMember> createBuyerGroupMember(List<String> accountWebcareIds){

        System.debug('accountWebcareIds: ' + accountWebcareIds);

        List<BuyerGroupMember> buyerGroupMembers = new List<BuyerGroupMember>();
        Map<String, String> buyerGroupMap = new Map<String, String>();

        for(BuyerGroup buyerGroup : [SELECT Id, Name, Type__c FROM BuyerGroup WHERE Type__c != '']){
            buyerGroupMap.put(buyerGroup.Type__c, buyerGroup.Id);
        }

        For(Account account : [SELECT Id, Webcare_Id__c, Partner_Type__c, Price_Grid__c FROM Account WHERE Webcare_Id__c IN :accountWebcareIds]){
            String buyerGroupType = account.Partner_Type__c + account.Price_Grid__c;
            system.debug('buyerGroupType: ' + buyerGroupType);
            system.debug('buyerGroupMap.get(buyerGroupType): ' + buyerGroupMap.get(buyerGroupType));
            BuyerGroupMember buyerGroupMember = new BuyerGroupMember();
            buyerGroupMember.BuyerGroupId = buyerGroupMap.get(buyerGroupType);
            buyerGroupMember.BuyerId = account.Id;
            buyerGroupMember.Webcare_Id__c = account.Webcare_Id__c +'-' + buyerGroupType;
            buyerGroupMembers.add(buyerGroupMember);
        }

        return buyerGroupMembers;
    }

    public static List<Supplier_Access__c> createActiveSupplierAccess(WebCareCustomer.Customer wcCustomer){

        List<Supplier_Access__c> supplierAccessList = new List<Supplier_Access__c>();

        for(WebCareCustomer.SupplierCodes supplierCode : wcCustomer.supplierCodes){
            Supplier_Access__c supplierAccess = new Supplier_Access__c();
            supplierAccess.Name = supplierCode.supplier;
            supplierAccess.Account__r = new Account(Webcare_Id__c = wcCustomer.client.Id);
            supplierAccess.Contact__r = new Contact(Webcare_Id__c = wcCustomer.id);
            supplierAccess.Supplier__r = new Account(Webcare_Id__c = supplierCode.supplier);
            supplierAccess.Status__c = 'Active';
            supplierAccess.Ship_To__c = supplierCode.shipTo;
            supplierAccess.Order_To__c = supplierCode.orderTo;
            supplierAccess.Webcare_Id__c = wcCustomer.id + '-' + supplierCode.supplier;
            supplierAccessList.add(supplierAccess);
        }

        return supplierAccessList;
    }

    public static List<Supplier_Access__c> createBlockedSupplierAccess(WebCareCustomer.Customer wcCustomer){

        List<Supplier_Access__c> supplierAccessList = new List<Supplier_Access__c>();

        for(String supplierCode : wcCustomer.nonActiveSuppliers){
            Supplier_Access__c supplierAccess = new Supplier_Access__c();
            supplierAccess.Name = supplierCode;
            supplierAccess.Account__r = new Account(Webcare_Id__c = wcCustomer.client.Id);
            supplierAccess.Contact__r = new Contact(Webcare_Id__c = wcCustomer.id);
            supplierAccess.Supplier__r = new Account(Webcare_Id__c = supplierCode);
            supplierAccess.Status__c = 'Blocked';
            supplierAccess.Webcare_Id__c = wcCustomer.id + '-' + supplierCode;
            supplierAccessList.add(supplierAccess);
        }

        return supplierAccessList;
    }


    public Static String getAccountType(String partnerType){

        String accountType;

        if(partnerType == 'p') {
            accountType = 'Portal User';
        } else if(partnerType == 'd') {
            accountType = 'Wholesaler';
        } else {
            accountType = '';
        }

        return accountType;

    }

}