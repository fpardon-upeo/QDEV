/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description: Does not assert anything since
 *
 *
 * Created: 18/11/2022
 * Last Updated: 18/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareArticleSyncTest {
    @TestSetup
    static void mockResponses() {


        SingleRequestMock firstPage = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"id\": \"100782\",'+
                        '            \"reference\": \"\",'+
                        '            \"ean\": \"\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"125 R 15 X OLDTIMER 68S TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"125 R 15 68S X OLDTIMER TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"TO\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"125\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"X\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"OLDTIMER\",'+
                        '            \"loadbalancing\": \"68\",'+
                        '            \"speed\": \"S\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"\",'+
                        '            \"grip\": \"\",'+
                        '            \"REvalue\": \"\",'+
                        '            \"REclass\": \"\",'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        },'+
                        '        {'+
                        '            \"id\": \"101174\",'+
                        '            \"reference\": \"MI136016\",'+
                        '            \"ean\": \"3528701360164\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"CTMS\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"215\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"65\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"\",'+
                        '            \"loadbalancing\": \"104\",'+
                        '            \"speed\": \"T\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"D\",'+
                        '            \"grip\": \"A\",'+
                        '            \"REvalue\": \"71\",'+
                        '            \"REclass\": \"B\",'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        }'+
                        '    ],'+
                        '\"count\": 3998'+
                        '}',
                null
        );

        SingleRequestMock secondPage = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"id\": \"100785\",'+
                        '            \"reference\": \"VR2988141\",'+
                        '            \"ean\": \"8714692988141\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"TO\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"125\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"X\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"OLDTIMER\",'+
                        '            \"loadbalancing\": \"68\",'+
                        '            \"speed\": \"S\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"\",'+
                        '            \"grip\": \"\",'+
                        '            \"REvalue\": \"\",'+
                        '            \"REclass\": \"\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        },'+
                        '        {'+
                        '            \"id\": \"101177\",'+
                        '            \"reference\": \"MI136016\",'+
                        '            \"ean\": \"3528701360164\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"CTMS\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"215\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"65\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"\",'+
                        '            \"loadbalancing\": \"104\",'+
                        '            \"speed\": \"T\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"D\",'+
                        '            \"grip\": \"A\",'+
                        '            \"REvalue\": \"71\",'+
                        '            \"REclass\": \"B\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        }'+
                        '    ],'+
                        '\"count\": 1'+
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
        endpoint2TestResp.put('callout:webCareNew/portal/article/1', firstPage);
        endpoint2TestResp.put('callout:webCareNew/portal/article/2', secondPage);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
    }

    @IsTest
    private static void testInvalid() {

        SingleRequestMock invalidReturn = new SingleRequestMock(
                403,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"id\": \"100785\",'+
                        '            \"reference\": \"VR2988141\",'+
                        '            \"ean\": \"8714692988141\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"TO\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"125\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"X\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"OLDTIMER\",'+
                        '            \"loadbalancing\": \"68\",'+
                        '            \"speed\": \"S\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"\",'+
                        '            \"grip\": \"\",'+
                        '            \"REvalue\": \"\",'+
                        '            \"REclass\": \"\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        },'+
                        '        {'+
                        '            \"id\": \"101177\",'+
                        '            \"reference\": \"MI136016\",'+
                        '            \"ean\": \"3528701360164\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"CTMS\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"215\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"65\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"\",'+
                        '            \"loadbalancing\": \"104\",'+
                        '            \"speed\": \"T\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"D\",'+
                        '            \"grip\": \"A\",'+
                        '            \"REvalue\": \"71\",'+
                        '            \"REclass\": \"B\",'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        }'+
                        '    ],'+
                        '\"count\": 1'+
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
        endpoint2TestResp.put('callout:webCareNew/portal/article/1', invalidReturn);
        endpoint2TestResp.put('callout:webCareNew/portal/article/2', invalidReturn);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );

        insert storePriceBook;


        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;

        Test.startTest();
        WebCareArticleSync webCareArticleSync = new WebCareArticleSync();
        webCareArticleSync.startSync(1);
        Test.stopTest();

    }

    @IsTest
    static void testGetArticles() {

        mockResponses();

        Brand__c brand = new Brand__c(Name = 'MI', Abbreviation__c = 'MI');
        insert brand;

        Article_Type__c articleTypeTO = new Article_Type__c(Name = 'TO', Abbreviation__c = 'TO', Code__c = 'TO', split1__c = 'CT');
        insert articleTypeTO;

        Article_Type__c articleTypeCTMS = new Article_Type__c(Name = 'CTMS', Abbreviation__c = 'CTMS', Code__c = 'CTMS', split1__c = 'CT');
        insert articleTypeCTMS;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );

        insert storePriceBook;


        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;
        system.debug('token: ' + newToken);

        Test.startTest();
        WebCareArticleSync webCareArticleSync = new WebCareArticleSync();
        List<Product2> productList = webCareArticleSync.startSync(1);
        Test.stopTest();

        system.debug('productList: ' + productList);

        Schema.SObjectField f = Product2.Fields.Webcare_Id__c;
        DMLHandler.upsertRecords(f, productList);

        List<Product2> insertedProducts = [SELECT Id, Webcare_Id__c FROM Product2 WHERE Webcare_Id__c != null];
        system.debug('insertedProducts: ' + insertedProducts.size());
        List<Error_Log__c> errorLogs = [SELECT Id, Error_Message__c, Fields__c FROM Error_Log__c];
        System.debug('errorLogs: ' + errorLogs.size());
        List<Article_Type__c> articleTypes = [SELECT Id, Name, Code__c FROM Article_Type__c];
        System.debug('articleTypes: ' + articleTypes);

        system.assertEquals(2, insertedProducts.size());
        system.assertEquals(0, errorLogs.size());

    }

    @IsTest
    static void testGetArticlesBatch() {

        SingleRequestMock firstPage = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"id\": \"100782\",'+
                        '            \"reference\": \"\",'+
                        '            \"ean\": \"\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"125 R 15 X OLDTIMER 68S TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"125 R 15 68S X OLDTIMER TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"TO\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"125\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"X\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"OLDTIMER\",'+
                        '            \"loadbalancing\": \"68\",'+
                        '            \"speed\": \"S\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"\",'+
                        '            \"grip\": \"\",'+
                        '            \"REvalue\": \"\",'+
                        '            \"REclass\": \"\",'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        },'+
                        '        {'+
                        '            \"id\": \"101174\",'+
                        '            \"reference\": \"MI136016\",'+
                        '            \"ean\": \"3528701360164\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"CTMS\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"215\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"65\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"\",'+
                        '            \"loadbalancing\": \"104\",'+
                        '            \"speed\": \"T\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"D\",'+
                        '            \"grip\": \"A\",'+
                        '            \"REvalue\": \"71\",'+
                        '            \"REclass\": \"B\",'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        }'+
                        '    ],'+
                        '\"count\": 2998'+
                        '}',
                null
        );

        SingleRequestMock secondPage = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"articles\": ['+
                        '        {'+
                        '            \"id\": \"100785\",'+
                        '            \"reference\": \"VR2988141\",'+
                        '            \"ean\": \"8714692988141\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"165/65 R 14 79T QUATRAC5 m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"TO\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"125\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"X\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"OLDTIMER\",'+
                        '            \"loadbalancing\": \"68\",'+
                        '            \"speed\": \"S\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"\",'+
                        '            \"grip\": \"\",'+
                        '            \"REvalue\": \"\",'+
                        '            \"REclass\": \"\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        },'+
                        '        {'+
                        '            \"id\": \"101177\",'+
                        '            \"reference\": \"MI136016\",'+
                        '            \"ean\": \"3528701360164\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                        '                }'+
                        '            ],'+
                        '            \"brand\": \"MI\",'+
                        '            \"type\": \"CTMS\",'+
                        '            \"vat\": \"21\",'+
                        '            \"ecotax\": \"12\",'+
                        '            \"dim1\": \"215\",'+
                        '            \"dim2\": \"\",'+
                        '            \"series\": \"65\",'+
                        '            \"category\": \"R\",'+
                        '            \"dim3\": \"15\",'+
                        '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                        '            \"application\": \"\",'+
                        '            \"xlrf\": \"\",'+
                        '            \"rof\": false,'+
                        '            \"specialDesignation\": \"\",'+
                        '            \"loadbalancing\": \"104\",'+
                        '            \"speed\": \"T\",'+
                        '            \"specification\": \"TL\",'+
                        '            \"BEclass\": \"D\",'+
                        '            \"grip\": \"A\",'+
                        '            \"REvalue\": \"71\",'+
                        '            \"REclass\": \"B\",'+
                        '            \"ecotaxdescription\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                        '                }'+
                        '            ],'+
                        '            \"commercial\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                        '                }'+
                        '            ],'+
                        '            \"qr\": ['+
                        '                {'+
                        '                    \"type\": \"eprel\",'+
                        '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                        '                },'+
                        '                {'+
                        '                    \"type\": \"supplier\",'+
                        '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                        '                }'+
                        '            ],'+
                        '            \"ranking\": 0'+
                        '        }'+
                        '    ],'+
                        '\"count\": 1'+
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
        endpoint2TestResp.put('callout:webCareNew/portal/article/1', firstPage);
        endpoint2TestResp.put('callout:webCareNew/portal/article/2', secondPage);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Brand__c brand = new Brand__c(Name = 'MI', Abbreviation__c = 'MI');
        insert brand;

        Article_Type__c articleTypeTO = new Article_Type__c(Name = 'TO', Abbreviation__c = 'TO', Code__c = 'TO');
        insert articleTypeTO;

        Article_Type__c articleTypeCTMS = new Article_Type__c(Name = 'CTMS', Abbreviation__c = 'CTMS', Code__c = 'CTMS');
        insert articleTypeCTMS;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );

        insert storePriceBook;

        ProductCatalog productCatalog = new ProductCatalog(
                Name = 'QTeam B2B Product Catalog'
        );
        insert productCatalog;

        ProductCategory productCategory = new ProductCategory(
                Name = 'Products',
                CatalogId = productCatalog.Id
        );
        insert productCategory;


        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;
        system.debug('token: ' + newToken);

        Test.startTest();
        String jobId = Database.executeBatch(new WebCareArticleSyncBatch(1), 400);
        Test.stopTest();


        List<Product2> insertedProducts = [SELECT Id, Webcare_Id__c FROM Product2 WHERE Webcare_Id__c != null];
        system.debug('insertedProducts: ' + insertedProducts.size());
        List<Error_Log__c> errorLogs = [SELECT Id, Error_Message__c, Fields__c FROM Error_Log__c];
        System.debug('errorLogs: ' + errorLogs.size());
        List<Article_Type__c> articleTypes = [SELECT Id, Name, Code__c FROM Article_Type__c];
        System.debug('articleTypes: ' + articleTypes);

        system.assertEquals(2, insertedProducts.size());
        system.assertEquals(0, errorLogs.size());

    }

}