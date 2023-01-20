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
 * Created: 20/12/2022
 * Last Updated: 20/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareStockPriceCheckTest {

    @TestSetup
    static void createTestDate() {

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
        String currentUser = UserInfo.getUserId();
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        system.runAs(usr){
            User curUser = [SELECT Id FROM User WHERE Id = :currentUser];
            curUser.Webcare_Id__c = '785262BC9E5449D9843578880ACF228A';
            update curUser;
        }

    }

    @IsTest
    static void getSingleSupplierCartItemsTest_Validate() {

        String jsonValidate = '{'+
                '    "orders": ['+
                '        {'+
                '            "transport": "50",'+
                '            "supplier": "5701",'+
                '            "deliveryAddressId": "8lW5E0000009WhMUAU",'+
                '            "articles": ['+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177114",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177115",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177116",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ],'+
                '    "customer": "785262BC9E5449D9843578880ACF228A",'+
                '    "basket": "0a65E00000002MsQAI"'+
                '}';

        String jsonOrdered = '{'+
                '    "orders": ['+
                '        {'+
                '            "transport": "50",'+
                '            "supplier": "5701",'+
                '            "orderWebcare": "123456",'+
                '            "orderSupplier": "654321",'+
                '            "deliveryAddressId": "8lW5E0000009WhMUAU",'+
                '            "articles": ['+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177114",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177115",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177116",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ],'+
                '    "customer": "785262BC9E5449D9843578880ACF228A",'+
                '    "basket": "0a65E00000002MsQAI"'+
                '}';

        SingleRequestMock validateOrder = new SingleRequestMock(
                200,
                'complete',
                jsonValidate,
                null);

        SingleRequestMock placeOrder = new SingleRequestMock(
                200,
                'complete',
                jsonOrdered,
                null);

        SingleRequestMock refreshToken = new SingleRequestMock(
                200,
                'Complete',
                '{'+
                        '  \"accessToken\": \"RTgzQFM3NjItQzS2NC00OU20LTg5NkYtRDlBOTgyMUNGN0Qx\",'+
                        '  \"refreshToken\": \"Rfk5MTF4RTktMUMFNi04RTI1LTk4MkMtZkE8OUM0N0VDQjcy\"'+
                        '}',
                null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/stockprice', validateOrder);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];
        System.debug('cart: ' + cart);
        List<CartItem> cartItems = [SELECT Id FROM CartItem WHERE CartId = :cart.Id];
        System.debug('cartItems: ' + cartItems);

        Test.startTest();
        List<CartItem> validatedItems = WebCareStockPriceCheck.getSingleSupplierCartItems(cart.Id, '5701');
        Test.stopTest();
        System.debug('validatedItems: ' + validatedItems);


    }

    @IsTest
    static void getSingleSupplierCartItemsTest_Order() {

        String jsonValidate = '{'+
                '    "orders": ['+
                '        {'+
                '            "transport": "50",'+
                '            "supplier": "5701",'+
                '            "deliveryAddressId": "8lW5E0000009WhMUAU",'+
                '            "articles": ['+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177114",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177115",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177116",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ],'+
                '    "customer": "785262BC9E5449D9843578880ACF228A",'+
                '    "basket": "0a65E00000002MsQAI"'+
                '}';

        String jsonOrdered = '{'+
                '    "orders": ['+
                '        {'+
                '            "transport": "50",'+
                '            "supplier": "5701",'+
                '            "orderWebcare": "123456",'+
                '            "delnoteWebcare": "654321",'+
                '            "deliveryAddressId": "8lW5E0000009WhMUAU",'+
                '            "articles": ['+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177114",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177115",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                },'+
                '                {'+
                '                    "quantity": "2",'+
                '                    "price": "36.29",'+
                '                    "id": "177116",'+
                '                    "deliveryTime": "' + Date.today() +'"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ],'+
                '    "customer": "785262BC9E5449D9843578880ACF228A",'+
                '    "basket": "0a65E00000002MsQAI"'+
                '}';

        SingleRequestMock validateOrder = new SingleRequestMock(
                200,
                'complete',
                jsonValidate,
                null);

        SingleRequestMock placeOrder = new SingleRequestMock(
                200,
                'complete',
                jsonOrdered,
                null);

        SingleRequestMock refreshToken = new SingleRequestMock(
                200,
                'Complete',
                '{'+
                        '  \"accessToken\": \"RTgzQFM3NjItQzS2NC00OU20LTg5NkYtRDlBOTgyMUNGN0Qx\",'+
                        '  \"refreshToken\": \"Rfk5MTF4RTktMUMFNi04RTI1LTk4MkMtZkE8OUM0N0VDQjcy\"'+
                        '}',
                null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/stockprice', placeOrder);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;

        WebCart cart = [SELECT Id FROM WebCart WHERE Name = 'Test Cart' LIMIT 1];
        System.debug('cart: ' + cart);
        List<CartItem> cartItems = [SELECT Id FROM CartItem WHERE CartId = :cart.Id];
        System.debug('cartItems: ' + cartItems);

        Test.startTest();
        List<CartItem> validatedItems = WebCareStockPriceCheck.getSingleSupplierCartItems(cart.Id, '5701');
        Test.stopTest();
        System.debug('validatedItems: ' + validatedItems);


    }


}