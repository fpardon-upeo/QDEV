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
 * Created: 22/11/2022
 * Last Updated: 22/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
Description:

Change Log:

Dependencies:

*/

public with sharing class WebCareProfileImageSync {

    public static List<ContentVersion> getAllProfileImages(String profileId){

        HttpResponse resp = WebCareRest.doCallOut('/portal/profileimage/'+profileId, 'GET');
        WebCareProfileImage wcImages = WebCareProfileImage.parse(resp.getBody());
        List<ContentVersion> cvList = transformImages(wcImages, profileId);
        return cvList;

    }

    public static void getSingleProfileImages(String profileId){

        HttpResponse resp = WebCareRest.doCallOut('/portal/profileimage/'+profileId, 'GET');
        //Save refresh token after last callout

        WebCareProfileImage wcImages = WebCareProfileImage.parse(resp.getBody());
        List<ContentVersion> cvList = transformImages(wcImages, profileId);

        Map<String, String> tokens = WebCareRest.getToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));

        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<String> cvIds = new List<String>();

        Profile__c profile = [SELECT Id FROM Profile__c WHERE Webcare_Id__c = :profileId LIMIT 1];

        Schema.SObjectField fCV = ContentVersion.fields.Webcare_Id__c;
        List<Database.SaveResult> upResult = DMLHandler.insertRecordsWithReturn(cvList);

        for(Database.SaveResult sr : upResult){
            if(sr.isSuccess()){
                cvIds.add(sr.getId());
            }
        }

        //Loop through the created content versions and create a link to the profile
        for(ContentVersion cv : [Select Id, ContentDocumentId, Type__c FROM ContentVersion WHERE Id IN :cvIds]){
            System.debug('ContentVersion: ' +cv.Id);
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.LinkedEntityId = profile.id;
            cdl.Visibility = 'AllUsers';
            cdlList.add(cdl);
            //Stamp the content version Ids on the Profile__c record
            if(cv.Type__c == 'side'){
                profile.Image_Id_Side__c = cv.Id;
            }
            if(cv.Type__c == 'corner'){
                profile.Image_Id_Corner__c = cv.Id;
            }
            if(cv.Type__c == 'profile'){
                profile.Image_Id_Profile__c = cv.Id;
            }
        }

        insert cdlList;
        update profile;

    }

    public static List<ContentVersion> transformImages(WebCareProfileImage images,String profileId){

        //Save refresh token after last callout

        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<String> cvExtIds = new List<String>();
        Map<String, String> cvExtIdToId = new Map<String, String>();

        for(WebCareProfileImage.Image img : images.images){
            ContentVersion cv = createImage(img, profileId);
            contentVersions.add(cv);
            cvExtIds.add(cv.Webcare_Id__c);
        }

        for(ContentVersion cv : [Select Id, Webcare_Id__c, ContentDocumentId from ContentVersion where Webcare_Id__c in :cvExtIds AND Webcare_Id__c != null]){
            cvExtIdToId.put(cv.Webcare_Id__c, cv.ContentDocumentId);
        }

        for(ContentVersion cv : contentVersions){
            if(cvExtIdToId.containsKey(cv.Webcare_Id__c)){
                cv.ContentDocumentId = cvExtIdToId.get(cv.Webcare_Id__c);
            }
        }

        return contentVersions;
    }

    //--------------------------------------TRANSFORM----------------------------------------------------------------//

    public static ContentVersion createImage(WebCareProfileImage.Image image, String profileId){

        //Create a placeholder ContentVersion record so we can update it later with the actual file data
        ContentVersion cv = new ContentVersion();
        system.debug('base64 size = ' +image.file.length());
        Blob fileAsBlob = Blob.valueOf(image.file);
        system.debug('blob size = ' +fileAsBlob);
        cv.Webcare_Id__c = profileId +'-'+ image.filename;
        cv.VersionData = EncodingUtil.base64Decode(image.file);
        cv.Title = image.filename;
        cv.PathOnClient = image.filename;
        cv.Description = image.filename;
        cv.Type__c = image.type;
        return cv;
    }

}