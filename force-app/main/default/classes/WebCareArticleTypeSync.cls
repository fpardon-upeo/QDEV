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
 * Created: 17/11/2022
 * Last Updated: 17/11/2022
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

public with sharing class WebCareArticleTypeSync {

    @Future(callout=true)
    public static void getArticleTypes(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/articletype', 'GET');
        WebCareArticleType articleTypes = WebCareArticleType.parse(resp.getBody());
        transformTypes(articleTypes);

    }

    public static void transformTypes(WebCareArticleType articleTypes){

        List<Article_Type__c> articleTypeList = new List<Article_Type__c>();

        for(WebCareArticleType.Type artType : articleTypes.types){
            Article_Type__c newArticleType = new Article_Type__c();
            newArticleType.Name = artType.abbreviation;
            newArticleType.abbreviation__c = artType.abbreviation;
            newArticleType.tav__c = artType.tav;
            newArticleType.Code__c = artType.code;
            newArticleType.group__c = artType.group_Z;
            newArticleType.Intrastat_Code__c = artType.intrastat.code;
            newArticleType.Intrastat_Weight__c = artType.intrastat.weight;
            newArticleType.class__c = artType.class_Z;
            newArticleType.rdc__c = artType.rdc;
            newArticleType.selection__c = artType.selection;
            newArticleType.split1__c = artType.split1;
            newArticleType.split2__c = artType.split2;
            newArticleType.split3__c = artType.split3;
            newArticleType.noStockvalue__c = artType.noStockvalue;
            for(WebCareArticleType.Description d : artType.description){
                if(d.lang == 'NL'){
                    newArticleType.Description_NL__c = d.value;
                }
                if(d.lang == 'FR'){
                    newArticleType.Description_FR__c = d.value;
                }
            }



            articleTypeList.add(newArticleType);
        }

        Schema.SObjectField f = Article_Type__c.Fields.Code__c;
        DMLHandler.upsertRecords(f, articleTypeList);

    }

}