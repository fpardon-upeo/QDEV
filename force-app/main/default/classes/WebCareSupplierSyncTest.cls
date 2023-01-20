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
 * Created: 15/12/2022
 * Last Updated: 15/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/


@isTest
private class  WebCareSupplierSyncTest {

    @IsTest
    static void getSuppliersTest() {

        String jsonBody = '{'+
                '    \"suppliers\": ['+
                '        {'+
                '            \"id\": \"1\",'+
                '            \"name\": \"testsupplier\",'+
                '            \"tel\": \"12345\",'+
                '            \"email\": \"t@t.com\",'+
                '            \"contactPersons\": ['+
                '                {'+
                '                    \"firstname\": \"test\",'+
                '                    \"surname\": \"testlast\",'+
                '                    \"function\": \"buyer\",'+
                '                    \"email\": \"t@t.com\",'+
                '                    \"tel\": \"1231321321\",'+
                '                    \"id\": \"1545465456445\"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ]'+
                '}';

        SingleRequestMock profileReq = new SingleRequestMock(
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

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('callout:webCareNew/portal/supplier', profileReq);
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

        WebCareSupplierSync.getSuppliers();

        Test.stopTest();

        List<Error_Log__c> errors = [SELECT Id, Error_Message__c FROM Error_Log__c];
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contact> contacts = [SELECT Id FROM Contact];

        for(Error_Log__c error : errors){
            System.debug(error.Error_Message__c);
        }

        system.debug('accounts: ' + accounts);
        system.debug('contacts: ' + contacts);







   }



}