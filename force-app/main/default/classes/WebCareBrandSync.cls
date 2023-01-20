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

public with sharing class WebCareBrandSync {

    @Future(callout=true)
    public static void getBrands(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/brand', 'GET');
        WebCareBrand brands = WebCareBrand.parse(resp.getBody());
        transformBrands(brands);

    }

    public static void transformBrands(WebCareBrand brands){

        List<Brand__c> brandList = new List<Brand__c>();

        for(WebCareBrand.Brand brand : brands.brands){
            Brand__c newBrand = new Brand__c();
            newBrand.Name = brand.abbreviation;
            newBrand.Abbreviation__c = brand.abbreviation;
            newBrand.abbreviationRenta__c = brand.abbreviationRenta;
            newBrand.class__c = brand.class_Z;
            newBrand.level__c = brand.level;
            newBrand.Active__c = brand.active;
            for(WebCareBrand.Description descr : brand.description){
                if(descr.lang == 'nl'){
                    newBrand.Description_NL__c = descr.value;
                }
                if(descr.lang == 'fr'){
                    newBrand.Description_FR__c = descr.value;
                }
            }
            newBrand.Ranking__c = brand.ranking;
            brandList.add(newBrand);
        }

        Schema.SObjectField f = Brand__c.Fields.Abbreviation__c;
        DMLHandler.upsertRecords(f, brandList);

    }

}