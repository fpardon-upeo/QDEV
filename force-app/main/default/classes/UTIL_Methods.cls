/* created by :
    Abdelhafid Khribech
    on 02/12/2022
*/
public with sharing class UTIL_Methods {
    public UTIL_Methods() {

    }
    public sObject populateMandatoryField(String aObjName, sObject aObj, integer index){
        if(Constants.OBJ_API_USER.equalsIgnoreCase(aObjName)){
            System.debug('USER');
            aObj.put('Username', 'abdelhafidQteam' + index + '@upeoconsulting.com');
            aObj.put('LastName', 'khribech' + index);
            aObj.put('Email', 'a.khribech@upeoconsulting.com');
            aObj.put('Alias', 'akbch');
            aObj.put('Type_of_User__c', 'd2');
            aObj.put('CommunityNickname', 'TDS' + index);
            aObj.put('TimeZoneSidKey', 'Europe/Paris');
            aObj.put('LocaleSidKey', 'fr_FR_EURO');
            aObj.put('EmailEncodingKey', 'ISO-8859-1');
            aObj.put('ProfileId', userinfo.getProfileId());
            aObj.put('LanguageLocaleKey', 'fr');
        }
        else if(Constants.OBJ_API_PRICEBOOK.equalsIgnoreCase(aObjName)){
            System.debug('PRICEBOOK');
                aObj.put('Name', 'testbook');
                aObj.put('IsActive', true);
                aObj.put('Type__c', 'd2');
        }
        return aObj;
    }    
}