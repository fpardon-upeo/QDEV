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
 * Created: 18/11/2022
 * Last Updated: 18/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareArticleTypeSyncTest {
    @TestSetup
    static void mockResponses() {


        SingleRequestMock mock = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"types\": ['+
                        '        {'+
                        '            \"abbreviation\": \"9900200\",'+
                        '            \"tav\": \"21\",'+
                        '            \"code\": \"9900200\",'+
                        '            \"group\": \"WT\",'+
                        '            \"intrastat\": {'+
                        '                \"code\": \"00000000\",'+
                        '                \"weight\": \"\"'+
                        '            },'+
                        '            \"class\": \"W\",'+
                        '            \"rdc\": \"\",'+
                        '            \"selection\": \"\",'+
                        '            \"split1\": \"990\",'+
                        '            \"split2\": \"02\",'+
                        '            \"split3\": \"00\",'+
                        '            \"noStockvalue\": false,'+
                        '            "description": ['+
                        '                {'+
                        '                    "lang": "nl",'+
                        '                    "value": "Hw sneeuwkettingen"'+
                        '                },'+
                        '                {'+
                        '                    "lang": "fr",'+
                        '                    "value": ""'+
                        '                }'+
                        '            ]'+
                        '        },'+
                        '        {'+
                        '            \"abbreviation\": \"9900300\",'+
                        '            \"tav\": \"21\",'+
                        '            \"code\": \"9900300\",'+
                        '            \"group\": \"WT\",'+
                        '            \"intrastat\": {'+
                        '                \"code\": \"00000000\",'+
                        '                \"weight\": 123.453'+
                        '            },'+
                        '            \"class\": \"W\",'+
                        '            \"rdc\": \"\",'+
                        '            \"selection\": \"\",'+
                        '            \"split1\": \"990\",'+
                        '            \"split2\": \"03\",'+
                        '            \"split3\": \"00\",'+
                        '            \"noStockvalue\": false,'+
                        '            "description": ['+
                        '                {'+
                        '                    "lang": "nl",'+
                        '                    "value": "Hw sneeuwkettingen"'+
                        '                },'+
                        '                {'+
                        '                    "lang": "fr",'+
                        '                    "value": ""'+
                        '                }'+
                        '            ]'+
                        '        }'+
                        '    ]'+
                        '}',
                null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/articletype', mock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
    }

    @IsTest
    private static void testWebCareArticleTypeSync() {

        mockResponses();

        Test.startTest();
        WebCareArticleTypeSync.getArticleTypes();
        Test.stopTest();

        List<Article_Type__c> articleTypes = [SELECT Id FROM Article_Type__c];
        System.assertEquals(2, articleTypes.size());

    }

}