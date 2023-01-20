/**
 * Created by fpardon on 22/11/2022.
 *
 * Description: Class to get all images for products from WebCare. Most of the times, we will receive updates
 * from WebCare via a POST call. This class serves as a way to get all images when necessary.
 *
 */

public with sharing class WebCareProfileImageSyncBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts  {

    public Database.QueryLocator start(Database.BatchableContext BC){

        Map<String, String> tokens = WebCareRest.getToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));

        //Get all profiles from the database, we will feed this to the execute method to loop through everything.
        String query = 'SELECT Id, Webcare_Id__c FROM Profile__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){

        system.debug('scope size: ' + scope.size());

        //Create lists and maps we will need to store data in.

        List<ContentVersion> cvList = New List<ContentVersion>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();

        List<String> cvIds = new List<String>();

        // WCIdToProfileId is a map that will store the ContentVersionId as the key and the ProfileId as the value.
        Map<String, String> WCIdToProfileId = new Map<String, String>();
        //profileIdToProfile is a map that will store the ProfileId as the key and the Profile__c as the value.
        Map<String, Profile__c> profileIdToProfile = new Map<String, Profile__c>();

        //Build the map that stores the WebCare Id and the Profile__c Id
        For(Profile__c profile : (List<Profile__c>) scope){
            WCIdToProfileId.put(profile.Webcare_Id__c, profile.Id);
        }

        //Loop through the Product__c records in scope
        //For every WebCare Id, we will make a call to WebCare to get the image.
        //This will return a list of ContentVersions, which we will store in a new list.
        for(sobject s : scope){
            String profileId = (String)s.get('Webcare_Id__c');
            List<ContentVersion> cvFromCallout = WebCareProfileImageSync.getAllProfileImages(profileId);
            for(ContentVersion cv : cvFromCallout){
                cvList.add(cv);
            }
        }

        //Insert the ContentVersions into the database.
        List<Database.SaveResult> upResult = DMLHandler.insertRecordsWithReturn(cvList);

        //Parse the SaveResult, if the insert was successful, we will add the ContentVersionId to the cvIds list.
        for(Database.SaveResult sr : upResult){
            if(sr.isSuccess()){
                cvIds.add(sr.getId());
            }
        }

        //We will use the cvIds list to query the ContenVersions we just created
        //We will then build the ContentDocumentLink records and store them in a list.
        for(ContentVersion cv : [Select Id, ContentDocumentId, Webcare_Id__c, Type__c FROM ContentVersion WHERE Id IN :cvIds]){
            String profileId = WCIdToProfileId.get(cv.Webcare_Id__c.substringBefore('-'));
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.LinkedEntityId = profileId;
            cdl.Visibility = 'AllUsers';
            cdlList.add(cdl);

            //Next, we will store the Ids of the ContentVersions to stamp them on the Profile__c record
            //We do this so we can use these Ids in formulas to get the image on the Product2 .
            //If profileIdToProfile doesn't containt the current profileId yet we will create a new temp
            //Profile__c record and store it in the map.
            if(!profileIdToProfile.containsKey(profileId)){
                Profile__c profile = new Profile__c();
                profile.Id = profileId;
                if(cv.Type__c == 'side'){
                    profile.Image_Id_Side__c = cv.Id;
                }
                if(cv.Type__c == 'corner'){
                    profile.Image_Id_Corner__c = cv.Id;
                }
                if(cv.Type__c == 'profile'){
                    profile.Image_Id_Profile__c = cv.Id;
                }
                profileIdToProfile.put(profileId, profile);
            //If the profileIdToProfile map already contains the profileId, we will update the existing
            //Profile__c record
            } else {
                Profile__c profile = profileIdToProfile.get(profileId);
                if(cv.Type__c == 'side'){
                    profile.Image_Id_Side__c = cv.Id;
                }
                if(cv.Type__c == 'corner'){
                    profile.Image_Id_Corner__c = cv.Id;
                }
                if(cv.Type__c == 'profile'){
                    profile.Image_Id_Profile__c = cv.Id;
                }
                profileIdToProfile.put(profileId, profile);
            }
        }

        Schema.SObjectField fP = Profile__c.fields.Id;

        //Lastly we insert the ContentDocumentLinks and update the Profile__c records.
        DMLHandler.insertRecords(cdlList);
        DMLHandler.upsertRecords(fP, profileIdToProfile.values());

    }

    public void finish(Database.BatchableContext BC){
    }

}