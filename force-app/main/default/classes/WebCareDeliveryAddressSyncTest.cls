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
 * Created: 6/12/2022
 * Last Updated: 6/12/2022
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

@IsTest
public with sharing class WebCareDeliveryAddressSyncTest {

    @TestSetup
    public static void createTestData(){

        Address_Attributes__c addressAttributes = new Address_Attributes__c(
                Postal_Code__c = '1000'
        );

        insert addressAttributes;

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'QTeam Community Plus User' LIMIT 1 ].Id;

        Account a = new Account(Name = 'Test', Webcare_Id__c = '1234567888889');
        insert a;

        Contact c = new Contact(LastName = 'Test Contact', AccountId = a.Id, Webcare_Id__c = '987654321');
        insert c;

        User customerUser = new User();
        customerUser.Username = 'wcCustomer.email@test.com';
        customerUser.Email = customerUser.Username+ '.webcare';
        customerUser.FirstName = 'Test';
        customerUser.LastName = 'Customer';
        customerUser.Alias = 'test';
        customerUser.contactId = c.Id;
        customerUser.CommunityNickname = 'test';
        customerUser.EmailEncodingKey = 'ISO-8859-1';
        customerUser.LanguageLocaleKey = 'en_US';
        customerUser.LocaleSidKey = 'fr_BE';
        customerUser.TimeZoneSidKey = 'Europe/Paris';
        customerUser.ProfileId = profileId;
        customerUser.IsActive = true;
        //customerUser.Contact = new Contact(Webcare_Id__c = wcCustomer.id);

        insert customerUser;

        system.runAs(customerUser) {

            ContactPointAddress cpa = new ContactPointAddress(
                    Name = 'Test Address',
                    ParentId = a.Id,
                    Street = 'Test Street',
                    City = 'Test City',
                    PostalCode = '1000',
                    CountryCode = 'BE'
            );

            insert cpa;
        }
    }

    @isTest
    public static void testWebCareDeliveryAddressSync(){

        SingleRequestMock validReturn = new SingleRequestMock(
                200,
                'complete',
                'success',
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
        endpoint2TestResp.put('callout:webCareNew/portal/deliveryAddress', validReturn);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();

        ContactPointAddress cpa = [SELECT Id, Name, Street, City, PostalCode, CreatedById, CountryCode, CreatedBy.Contact.Webcare_Id__c, CreatedBy.Contact.Email FROM ContactPointAddress LIMIT 1];
        WebCareDeliveryAddressSync.syncAddress(cpa);

        Test.stopTest();

    }

}