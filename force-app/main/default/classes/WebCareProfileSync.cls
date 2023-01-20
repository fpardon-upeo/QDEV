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

public with sharing class WebCareProfileSync {

    @Future(callout=true)
    public static void getProfiles(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/profile', 'GET');
        WebCareProfile wcProfiles = WebCareProfile.parse(resp.getBody());
        transformProfiles(wcProfiles);

    }

    public static void transformProfiles(WebCareProfile wcProfiles){
        List<Profile__c> profiles = new List<Profile__c>();
        List<Profile_Bullet__c> bullets = new List<Profile_Bullet__c>();
        List<Profile_Link__c> links = new List<Profile_Link__c>();
        List<Linked_Profile__c> linkedProfiles = new List<Linked_Profile__c>();
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<String> profileLinkIds = new List<String>();

        Map<String, String> tokens = WebCareRest.getToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));


        for(WebCareProfile.Profile wcProfile : wcProfiles.profiles){
            Profile__c profile = createProfile(wcProfile);
            profiles.add(profile);

            for(String bulletsNl : wcProfile.bulletNl){
                Profile_Bullet__c bullet = createBullet(bulletsNl, profile, 'NL');
                bullets.add(bullet);
            }

            for(String bulletsFr : wcProfile.bulletFr){
                Profile_Bullet__c bullet = createBullet(bulletsFr, profile, 'FR');
                bullets.add(bullet);
            }

            for(String linksNL : wcProfile.linkNl){
                Profile_Link__c link = createLink(linksNL, profile, 'NL');
                links.add(link);
            }

            for(String linksFR : wcProfile.linkFr){
                Profile_Link__c link = createLink(linksFR, profile, 'FR');
                links.add(link);
            }

            if(wcProfile.list_z != null){
                for(String linkedProfileValue : wcProfile.list_z){
                    if(linkedProfileValue == 'AGILIS+'){
                        system.debug('AGILIS+');
                    }
                    Linked_Profile__c linkedProfile = createLinkedProfile(linkedProfileValue.trim(), profile);
                    if(linkedProfileValue == 'AGILIS+'){
                        system.debug('AGILIS+ ' + linkedProfile);
                    }

                    system.debug('index ' +profileLinkIds.indexOf(linkedProfile.Webcare_Id__c));
                    if(profileLinkIds.indexOf(linkedProfile.Webcare_Id__c) == -1){
                        profileLinkIds.add(linkedProfile.Webcare_Id__c);
                        system.debug('linkedProfile+ ' + linkedProfile.Webcare_Id__c);
                        linkedProfiles.add(linkedProfile);
                    }
                }
            }

        }

        Schema.SObjectField fProf = Profile__c.fields.Webcare_Id__c;
        Schema.SObjectField fBul = Profile_Bullet__c.fields.Webcare_Id__c;
        Schema.SObjectField fLink = Profile_Link__c.fields.Webcare_Id__c;
        Schema.SObjectField fPrLinked = Linked_Profile__c.fields.Webcare_Id__c;

        DMLHandler.upsertRecords(fProf, profiles);
        DMLHandler.upsertRecords(fBul, bullets);
        DMLHandler.upsertRecords(fLink, links);
        DMLHandler.upsertRecords(fPrLinked, linkedProfiles);


    }

    public static Profile__c createProfile(WebCareProfile.Profile wcProfile){
        Profile__c profile = new Profile__c();
        profile.Name = wcProfile.description;
        profile.Webcare_Id__c = wcProfile.id;
        profile.Description__c = wcProfile.description;
        profile.External_Id__c = wcProfile.description;
        profile.Brand__r = new Brand__c(Abbreviation__c = wcProfile.brand);
        for(WebCareProfile.Commercial wcCommercial : wcProfile.commercial){
            //system.debug('wcCommercial: ' + wcCommercial);
            String unescape = wcCommercial.value.replaceAll('\\\\n', ' ');
            unescape = unescape.replaceAll('\\\\', ' ');
            if(wcCommercial.lang == 'nl'){
                profile.Commercial_Text_NL__c = unescape;
            }
            if(wcCommercial.lang == 'fr'){
                profile.Commercial_Text_FR__c = unescape;
            }
        }
        for(WebCareProfile.Commercial wcResult : wcProfile.result){
            String unescape = wcResult.value.replaceAll('\\\\n', ' ');
            unescape = unescape.replaceAll('\\\\', ' ');
            if(wcResult.lang == 'nl'){
                profile.Result_Text_NL__c = unescape;
            }
            if(wcResult.lang == 'fr'){
                profile.Result_Text_FR__c = unescape;
            }
        }
        for(WebCareProfile.Commercial wcReview : wcProfile.review){
            String unescape = wcReview.value.replaceAll('\\\\n', ' ');
            unescape = unescape.replaceAll('\\\\', ' ');
            if(wcReview.lang == 'nl'){
                profile.Review_Text_NL__c = unescape;
            }
            if(wcReview.lang == 'fr'){
                profile.Review_Text_FR__c = unescape;
            }
        }
        return profile;
    }

    public static Profile_Bullet__c createBullet(String bulletValue, Profile__c profile, String language){
        Profile_Bullet__c bullet = new Profile_Bullet__c();
        String uniqueId = profile.Webcare_Id__c + bulletValue.left(40) + language;
        bullet.Profile__r = New Profile__c(Webcare_Id__c = profile.Webcare_Id__c);
        bullet.Text__c = bulletValue;
        bullet.Language__c = language;
        bullet.Webcare_Id__c = uniqueId;
        return bullet;
    }


    public static Profile_Link__c createLink(String linkValue, Profile__c profile, String language){
        Profile_Link__c link = new Profile_Link__c();
        String uniqueId = profile.Webcare_Id__c + linkValue.left(40) + language;
        link.Profile__r = New Profile__c(Webcare_Id__c = profile.Webcare_Id__c);
        link.URL__c = linkValue.left(255);
        link.Language__c = Language;
        link.Webcare_Id__c = uniqueId;
        return link;
    }

    public static Linked_Profile__c createLinkedProfile(String listValue, Profile__c profile){
        Linked_Profile__c lProfile = new Linked_Profile__c();
        lProfile.Profile__r = New Profile__c(Webcare_Id__c = profile.Webcare_Id__c);
        lProfile.Profile_Webcare_Id__c = profile.Webcare_Id__c;
        lProfile.Webcare_Id__c = listValue;
        return lProfile;
    }


}