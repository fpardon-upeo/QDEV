/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description: needs to be reworked once I have time
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
@IsTest
private class WebCareArticlePriceSyncTest {

    @IsTest
    static void testGetArticlePrices(){

        SingleRequestMock mockArticlePricePage1 = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"article\": \"130595\",'+
                        '            \"ean\": \"4019238318036\",'+
                        '            \"priceRate\": \"235.50\",'+
                        '            \"promoType\": \"none\",'+
                        '            \"supplier\": ['+
                        '                {'+
                        '                    \"id\": \"6576\",'+
                        '                    \"quantity1\": \"> 50\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                },'+
                        '                {'+
                        '                    \"id\": \"12226\",'+
                        '                    \"quantity1\": \"10\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                }'+
                        '            ]'+
                        '        }'+
                        '    ],'+
                        '    \"count\": 500'+
                        '}',
                null
        );

        SingleRequestMock mockArticlePricePage2 = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"article\": \"130595\",'+
                        '            \"ean\": \"4019238318036\",'+
                        '            \"priceRate\": \"235.50\",'+
                        '            \"promoType\": \"none\",'+
                        '            \"supplier\": ['+
                        '                {'+
                        '                    \"id\": \"6576\",'+
                        '                    \"quantity1\": \"> 50\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                },'+
                        '                {'+
                        '                    \"id\": \"12226\",'+
                        '                    \"quantity1\": \"10\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                }'+
                        '            ]'+
                        '        }'+
                        '    ],'+
                        '    \"count\": 1'+
                        '}',
                null
        );


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
        endpoint2TestResp.put('callout:webCareNew/portal/articleprice/1', mockArticlePricePage1);
        endpoint2TestResp.put('callout:webCareNew/portal/articleprice/2', mockArticlePricePage2);
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

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        CommerceEntitlementPolicy policy = new CommerceEntitlementPolicy(
            Name = 'Test Policy'
        );
        insert policy;


        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );
        insert storePriceBook;
        system.debug('storePriceBook: ' + storePriceBook);

        Account account = new Account(
                Name = 'Test Account 6576',
                Webcare_Id__c = '6576'
        );
        Account account2 = new Account(
                Name = 'Test Account 12226',
                Webcare_Id__c = '12226'
        );

        Product2 product = new Product2(
                Name = '130595',
                ProductCode = 'Test Product Code',
                IsActive = true,
                Type = 'Base',
                Webcare_Id__c = '130595'
        );

        insert product;
        system.debug('product id = ' + product.id);
        insert account;
        system.debug('acc id = ' +account.id);
        insert account2;
        system.debug('acc id = ' +account.id);

        system.debug('testGetArticlePrices');

        Pricebook2 pb1 = new Pricebook2(Name = 'Test Pricebook 1', Type__c = 'd1');
        Pricebook2 pb2 = new Pricebook2(Name = 'Test Pricebook 2', Type__c = 'd2');
        Pricebook2 pb3 = new Pricebook2(Name = 'Test Pricebook 3', Type__c = 'd3');
        Pricebook2 pb4 = new Pricebook2(Name = 'Test Pricebook 4', Type__c = 'p1');
        Pricebook2 pb5 = new Pricebook2(Name = 'Test Pricebook 5', Type__c = 'p2');
        Pricebook2 pb6 = new Pricebook2(Name = 'Test Pricebook 6', Type__c = 'p3');

        List<PriceBook2> pricebooks = new List<PriceBook2>();
        pricebooks.add(pb1);
        pricebooks.add(pb2);
        pricebooks.add(pb3);
        pricebooks.add(pb4);
        pricebooks.add(pb5);
        pricebooks.add(pb6);

        system.debug('pricebooks = ' + pricebooks.size());

        insert pricebooks;

        Test.startTest();

        WebCareArticlePriceSync webCareArticlePriceSync = new WebCareArticlePriceSync();
        WebCareArticlePrice result = webCareArticlePriceSync.startsync(1);
        webCareArticlePriceSync.transformArticlePrices(result.articles);

        Test.stopTest();

        List<Error_Log__c> errorLogs = [SELECT Id, Error_Message__c, DML_Operation__c, Payload__c FROM Error_Log__c];

        for(Error_Log__c errorLog : errorLogs) {
            system.debug('errorLog = ' + errorLog.Error_Message__c);
            system.debug('DML Operation: ' + errorLog.DML_Operation__c);
            system.debug('Payload: ' + errorLog.Payload__c);
        }

        List<Product2> mainProducts = [SELECT Id FROM Product2 WHERE Webcare_Id__c = '130595'];
        List<Product2> variationProducts = [SELECT Id FROM Product2 WHERE ProductClass = 'Variation'];
        List<ProductAttribute> productAttributes = [SELECT Id FROM ProductAttribute];
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry];

        System.debug('mainProducts: ' + mainProducts.size());
        System.debug('variationProducts: ' + variationProducts.size());
        System.debug('productAttributes: ' + productAttributes.size());
        System.debug('pricebookEntries: ' + pricebookEntries.size());


    }
    @isTest
    static void testGetArticlePricesBatch(){

        SingleRequestMock mockArticlePricePage1 = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"article\": \"130595\",'+
                        '            \"ean\": \"4019238318036\",'+
                        '            \"priceRate\": \"235.50\",'+
                        '            \"promoType\": \"none\",'+
                        '            \"supplier\": ['+
                        '                {'+
                        '                    \"id\": \"6576\",'+
                        '                    \"quantity1\": \"> 50\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                },'+
                        '                {'+
                        '                    \"id\": \"12226\",'+
                        '                    \"quantity1\": \"10\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                }'+
                        '            ]'+
                        '        }'+
                        '    ],'+
                        '    \"count\": 500'+
                        '}',
                null
        );

        SingleRequestMock mockArticlePricePage2 = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"article\": \"130595\",'+
                        '            \"ean\": \"4019238318036\",'+
                        '            \"priceRate\": \"235.50\",'+
                        '            \"promoType\": \"none\",'+
                        '            \"supplier\": ['+
                        '                {'+
                        '                    \"id\": \"6576\",'+
                        '                    \"quantity1\": \"> 50\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                },'+
                        '                {'+
                        '                    \"id\": \"12226\",'+
                        '                    \"quantity1\": \"10\",'+
                        '                    \"deliveryDate1\": \"2022-11-17\",'+
                        '                    \"quantity2\": \"\",'+
                        '                    \"deliveryDate2\": \"\",'+
                        '                    \"quantity3\": \"\",'+
                        '                    \"deliveryDate3\": \"\",'+
                        '                    \"prices\": ['+
                        '                        {'+
                        '                            \"type\": \"d1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"d3\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p1\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p2\",'+
                        '                            \"value\": \"\"'+
                        '                        },'+
                        '                        {'+
                        '                            \"type\": \"p3\",'+
                        '                            \"value\": \"\"'+
                        '                        }'+
                        '                    ]'+
                        '                }'+
                        '            ]'+
                        '        }'+
                        '    ],'+
                        '    \"count\": 1'+
                        '}',
                null
        );


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
        endpoint2TestResp.put('callout:webCareNew/portal/articleprice/1', mockArticlePricePage1);
        endpoint2TestResp.put('callout:webCareNew/portal/articleprice/2', mockArticlePricePage2);
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

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        CommerceEntitlementPolicy policy = new CommerceEntitlementPolicy(
                Name = 'Test Policy'
        );
        insert policy;


        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );
        insert storePriceBook;
        system.debug('storePriceBook: ' + storePriceBook);

        Account account = new Account(
                Name = 'Test Account 6576',
                Webcare_Id__c = '6576'
        );
        Account account2 = new Account(
                Name = 'Test Account 12226',
                Webcare_Id__c = '12226'
        );

        Product2 product = new Product2(
                Name = '130595',
                ProductCode = 'Test Product Code',
                IsActive = true,
                Type = 'Base',
                Webcare_Id__c = '130595'
        );

        insert product;
        system.debug('product id = ' + product.id);
        insert account;
        system.debug('acc id = ' +account.id);
        insert account2;
        system.debug('acc id = ' +account.id);

        system.debug('testGetArticlePrices');

        Pricebook2 pb1 = new Pricebook2(Name = 'Test Pricebook 1', Type__c = 'd1');
        Pricebook2 pb2 = new Pricebook2(Name = 'Test Pricebook 2', Type__c = 'd2');
        Pricebook2 pb3 = new Pricebook2(Name = 'Test Pricebook 3', Type__c = 'd3');
        Pricebook2 pb4 = new Pricebook2(Name = 'Test Pricebook 4', Type__c = 'p1');
        Pricebook2 pb5 = new Pricebook2(Name = 'Test Pricebook 5', Type__c = 'p2');
        Pricebook2 pb6 = new Pricebook2(Name = 'Test Pricebook 6', Type__c = 'p3');

        List<PriceBook2> pricebooks = new List<PriceBook2>();
        pricebooks.add(pb1);
        pricebooks.add(pb2);
        pricebooks.add(pb3);
        pricebooks.add(pb4);
        pricebooks.add(pb5);
        pricebooks.add(pb6);

        system.debug('pricebooks = ' + pricebooks.size());

        insert pricebooks;

        Test.startTest();

        String jobId = Database.executeBatch(new WebCareArticlePriceSyncBatch(1), 500);

        Test.stopTest();

        List<Error_Log__c> errorLogs = [SELECT Id, Error_Message__c, DML_Operation__c, Payload__c FROM Error_Log__c];

        for(Error_Log__c errorLog : errorLogs) {
            system.debug('errorLog = ' + errorLog.Error_Message__c);
            system.debug('DML Operation: ' + errorLog.DML_Operation__c);
            system.debug('Payload: ' + errorLog.Payload__c);
        }

        List<Product2> mainProducts = [SELECT Id FROM Product2 WHERE Webcare_Id__c = '130595'];
        List<Product2> variationProducts = [SELECT Id FROM Product2 WHERE ProductClass = 'Variation'];
        List<ProductAttribute> productAttributes = [SELECT Id FROM ProductAttribute];
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry];

        System.debug('mainProducts: ' + mainProducts.size());
        System.debug('variationProducts: ' + variationProducts.size());
        System.debug('productAttributes: ' + productAttributes.size());
        System.debug('pricebookEntries: ' + pricebookEntries.size());


    }


}