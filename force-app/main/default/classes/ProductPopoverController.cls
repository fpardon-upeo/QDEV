/**
 * Created by Frederik on 6/12/2022.
 */

public with sharing class ProductPopoverController {

    @AuraEnabled
    public static Product2 getProduct(String recordId){

        Product2 p = [SELECT Id, Name from Product2 WHERE Id = :recordId];

        return p;

    }

    @AuraEnabled
    public static List<String> getFieldSetMembers(String objectTypeName, String fieldSetName) {
        List<String> fields = new List<String>();
        DescribeSObjectResult[] describes = Schema.describeSObjects(new String[] {
                    objectTypeName
                });
        if (describes != null && describes.size() > 0) {
            Schema.FieldSet fs = describes[0].fieldSets.getMap().get(fieldSetName);
            for(Schema.FieldSetMember field : fs.fields) {
                fields.add(field.getFieldPath());
            }
            return fields;
        } else {
            return null;
        }
    }

}