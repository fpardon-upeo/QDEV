@IsTest
public with sharing class WebCareCartServiceBtoBTest {

    @TestSetup
    static void createTestDate() {

        Address_Attributes__c addressAttributes = new Address_Attributes__c(
            Postal_Code__c = '1000'
        );

        insert addressAttributes;

        Account testAccount = new Account(Name = 'Test Account');
        Account testSupplier = new Account(Name = 'Test Supplier', Webcare_Id__c = '5701');
        insert testAccount;
        insert testSupplier;
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        WebStore testWebStore = new WebStore(Name='TestWebStore', DefaultLanguage='en_US');
        insert testWebStore;

        BuyerGroup buyerGroup = new BuyerGroup();
        buyerGroup.Name = 'Test Buyer Group';
        buyerGroup.Type__c = 'p2';
        insert buyerGroup;
        system.debug('after insert buyer group');

        BuyerAccount buyerAccount = new BuyerAccount();
        buyerAccount.BuyerId = testAccount.Id;
        buyerAccount.Name = 'Test Account';
        buyerAccount.IsActive = true;
        buyerAccount.BuyerStatus = 'Active';
        insert buyerAccount;
        system.debug('after insert buyer account');

        BuyerGroupMember buyerGroupMember = new BuyerGroupMember();
        buyerGroupMember.BuyerId = testAccount.Id;
        buyerGroupMember.BuyerGroupId = buyerGroup.Id;
        insert buyerGroupMember;
        system.debug('after insert buyer group member');

        List<Product2> products = new List<Product2>();
        Product2 testProduct1 = new Product2(Name = '177114', Webcare_Id__c = '177114-5701', Supplier__c = testSupplier.Id);
        Product2 testProduct2 = new Product2(Name = '177115', ProductCode = '177115-5701', Supplier__c = testSupplier.Id);
        Product2 testProduct3 = new Product2(Name = '177116', ProductCode = '177116-5701', Supplier__c = testSupplier.Id);
        products.add(testProduct1);
        products.add(testProduct2);
        products.add(testProduct3);
        insert products;
        system.debug('after insert products');

        WebCart cart = new WebCart();
        cart.AccountId = testAccount.Id;
        cart.Name = 'Test Cart';
        cart.Status = 'Active';
        cart.WebStoreId = testWebStore.Id;
        insert cart;
        system.debug('after insert cart');

        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup();
        cartDeliveryGroup.CartId = cart.Id;
        cartDeliveryGroup.Name = 'Test Delivery Group';
        insert cartDeliveryGroup;
        String cartDeliveryGroupId = cartDeliveryGroup.Id;

        List<CartItem> cartItems = new List<CartItem>();
        for(Product2 product : products) {
            CartItem cartItem = new CartItem();
            cartItem.Name = product.Name;
            cartItem.Product2Id = product.Id;
            cartItem.Quantity = 2;
            cartItem.SalesPrice = 10;
            cartItem.GrossUnitPrice = 10;
            cartItem.CartId = cart.Id;
            cartItem.Delivery_Date__c = Date.today();
            cartItem.CartDeliveryGroupId = cartDeliveryGroupId;
            cartItems.add(cartItem);
        }
        insert cartItems;

        ContactPointAddress address = new ContactPointAddress();	
        address.Name = 'Test address';
        address.ParentId = testAccount.Id;
        address.AddressType = 'Shipping';
        address.PostalCode = '1000';
        //address.Address = '{"city": "Anderlecht","country": "Belgium","countryCode": "BE","geocodeAccuracy": null,"latitude": null,"longitude": null,"postalCode": "1070","state": null,"stateCode": null,"street": "Quai Fernand Demets 23"}';
        insert address;

        String currentUser = UserInfo.getUserId();
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        system.runAs(usr){
            User curUser = [SELECT Id FROM User WHERE Id = :currentUser];
            curUser.Webcare_Id__c = '785262BC9E5449D9843578880ACF228A';
            update curUser;
        }

    }


    @IsTest
    static void updateCartItemDeliveryAddressesTest() {

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];
        ContactPointAddress address = [SELECT Id FROM ContactPointAddress LIMIT 1];

        Test.startTest();
        WebCareCartServiceBtoB.updateCartItemDeliveryAddresses('5701', cart.Id, address.Id);
        Test.stopTest();
    }

    @IsTest
    static void updateCartItemTest() {

        CartItem cartItem = [SELECT Id FROM CartItem LIMIT 1];
        cartItem.Name = 'CartItem';

        Test.startTest();
        WebCareCartServiceBtoB.updateCartItem(cartItem);
        Test.stopTest();
    }

    @IsTest
    static void deleteCartItemTest() {

        CartItem cartItem = [SELECT Id FROM CartItem LIMIT 1];

        Test.startTest();
        String cartItemId = WebCareCartServiceBtoB.deleteCartItem(CartItem.Id);
        Test.stopTest();

        System.assert(cartItemId != null);
    }

    @IsTest
    static void getWebCareTotalItemsTest() {

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];

        Test.startTest();
        Decimal totalProductCount = WebCareCartServiceBtoB.getWebCareTotalItems(cart.Id);
        Test.stopTest();

        System.assert(totalProductCount != null);
    }

    @IsTest
    static void getWebCareCartItemsTest() {

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];

        Test.startTest();
        String webCareCart = WebCareCartServiceBtoB.getWebCareCartItems(cart.Id);
        Test.stopTest();

        System.assert(webCareCart != null);
    }

    @IsTest
    static void getContactPointAddressesTest() {

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];

        Test.startTest();
        WebCareCartServiceBtoB.getContactPointAddresses(cart.Id);
        Test.stopTest();
    }
}