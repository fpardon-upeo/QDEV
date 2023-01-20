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
 * Created: 19/12/2022
 * Last Updated: 19/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareTransportSyncTest {
    @IsTest
    static void transportCostTest() {


        String jsonBody = '{'+
                '    \"suppliers\": ['+
                '        {'+
                '            \"id\": \"6576\",'+
                '            \"cutoffTime\": \"15\",'+
                '            \"deliveryTime\": \"\",'+
                '            \"tourism\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"truck\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ]'+
                '        },'+
                '        {'+
                '            \"id\": \"8523\",'+
                '            \"cutoffTime\": \"15:00\",'+
                '            \"deliveryTime\": \"3\",'+
                '            \"tourism\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"20\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"25\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"30\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"moto\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"20\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"30\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"35\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"truck\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"60\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"70\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"75\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ]'+
                '}';

        SingleRequestMock transpCost = new SingleRequestMock(
                200,
                'complete',
                jsonBody,
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

        Account acc = new Account(Name = 'Test Account');
        acc.Webcare_Id__c = '8523';
        insert acc;

        Account acc2 = new Account(Name = 'Test Account 2');
        acc2.Webcare_Id__c = '6576';
        insert acc2;

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/transportcost', transpCost);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        Test.startTest();
        WebCareTransportCostSync.getTransportCosts();
        Test.stopTest();

        List<Error_Log__c> errors = [SELECT Id, Error_Message__c FROM Error_Log__c];
        System.assertEquals(0, errors.size(), 'There should be no errors');
        List<Transport_Cost__c> transpCosts = [SELECT Id FROM Transport_Cost__c];
        System.assertEquals(20, transpCosts.size(), 'There should be 20 transport cost records');

    }
}