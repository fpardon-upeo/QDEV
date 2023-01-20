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
private class WebCareBrandSyncTest {



    static void mockResponses() {
        SingleRequestMock mock = new SingleRequestMock(
                200,
                'complete',
                '{'+
                        '    \"brands\": ['+
                        '        {'+
                        '            \"abbreviation\": \"1H\",'+
                        '            \"abbreviationRenta\": \"1H\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"VHIP 50\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"VHIP 50\"'+
                        '                }'+
                        '            ],'+
                        '            \"class\": \"T\",'+
                        '            \"ranking\": 0,'+
                        '            \"level\": \"\",'+
                        '            \"active\": true'+
                        '        },'+
                        '        {'+
                        '            \"abbreviation\": \"3M\",'+
                        '            \"abbreviationRenta\": \"3M\",'+
                        '            \"description\": ['+
                        '                {'+
                        '                    \"lang\": \"nl\",'+
                        '                    \"value\": \"3M\"'+
                        '                },'+
                        '                {'+
                        '                    \"lang\": \"fr\",'+
                        '                    \"value\": \"3M\"'+
                        '                }'+
                        '            ],'+
                        '            \"class\": \"T\",'+
                        '            \"ranking\": 0,'+
                        '            \"level\": \"\",'+
                        '            \"active\": true'+
                        '        }'+
                        '    ]'+
                        '}',
                null
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/brand', mock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
    }

    @IsTest
    private static void testWebCareBrandSync() {

        mockResponses();

        Test.startTest();
        WebCareBrandSync.getBrands();
        Test.stopTest();

        List<Brand__c> articleTypes = [SELECT Id FROM Brand__c];
        System.assertEquals(2, articleTypes.size());

    }
}