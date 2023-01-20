/**
 * Created by fpardon on 23/11/2022.
 */

@IsTest
public with sharing class WebCareProfileImageSyncTest {

    @TestSetup
    static void setup() {
        // Create a test Profile__c record
        Profile__c profile = new Profile__c(Name = 'Test Product');
        profile.Webcare_Id__c = '10';
        profile.External_Id__c = 'P7~P7_CINT~P7ast_CINT';
        insert profile;

        WebCareProfileImageSyncTestHelper helper = new WebCareProfileImageSyncTestHelper();

        SingleRequestMock mockRespone = new SingleRequestMock(
                200,
                'OK',
                helper.mockResponse,
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
        endpoint2TestResp.put('callout:webCareNew/portal/profileimage/10', mockRespone);
        endpoint2TestResp.put('callout:WebCare/auth/refreshtoken', refreshToken);
        endpoint2TestResp.put('callout:WebCare/auth/signin', refreshToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

    }

    @IsTest
    static void testImageSyncSingle(){

        setup();

        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;

        Test.startTest();

        WebCareProfileImageSync.getSingleProfileImages('10');
        //WebCareProfileImageSync.getAllProfileImages('10');

        Test.stopTest();

        List<ContentVersion> contentVersions = [SELECT Id, Title, Type__c, ContentSize, ContentUrl, ContentDocumentId FROM ContentVersion];
        Profile__c profile = [SELECT Id, Name, Webcare_Id__c, External_Id__c, Image_Id_Corner__c, Image_Id_Profile__c, Image_Id_Side__c FROM Profile__c where Webcare_Id__c = '10' LIMIT 1];
        System.assertEquals(3, contentVersions.size());

        for(ContentVersion cv : contentVersions){
            if(cv.Type__c == 'corner'){
                System.assertEquals(profile.Image_Id_Corner__c, cv.Id);
            }
            if(cv.Type__c == 'profile'){
                System.assertEquals(profile.Image_Id_Profile__c, cv.Id);
            }
            if(cv.Type__c == 'side'){
                System.assertEquals(profile.Image_Id_Side__c, cv.Id);
            }
        }
    }

    @IsTest
    static void testImageSyncAll(){

        setup();

        WebCare_Bearer_Token__c newToken = new WebCare_Bearer_Token__c(
                SetupOwnerId = UserInfo.getOrganizationId(),
                Token__c = '123',
                Refresh_Token__c = '456'
        );

        insert newToken;

        List<ContentVersion> contentVersions = new List<ContentVersion>();

        Test.startTest();
        contentVersions = WebCareProfileImageSync.getAllProfileImages('10');
        Test.stopTest();

        Profile__c profile = [SELECT Id, Name, Webcare_Id__c, External_Id__c, Image_Id_Corner__c, Image_Id_Profile__c, Image_Id_Side__c FROM Profile__c where Webcare_Id__c = '10' LIMIT 1];
        System.assertEquals(3, contentVersions.size());

        for(ContentVersion cv : contentVersions){
            if(cv.Type__c == 'corner'){
                System.assertEquals(profile.Image_Id_Corner__c, cv.Id);
            }
            if(cv.Type__c == 'profile'){
                System.assertEquals(profile.Image_Id_Profile__c, cv.Id);
            }
            if(cv.Type__c == 'side'){
                System.assertEquals(profile.Image_Id_Side__c, cv.Id);
            }
        }


    }

}