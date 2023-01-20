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

@IsTest
public class WebCareArticleTypeTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '    \"types\": ['+
                '        {'+
                '            \"abbreviation\": \"9900200\",'+
                '            \"tav\": \"21\",'+
                '            \"code\": \"9900200\",'+
                '            \"group\": \"WT\",'+
                '            \"intrastat\": {'+
                '                \"code\": \"00000000\",'+
                '                \"weight\": \"\"'+
                '            },'+
                '            \"class\": \"W\",'+
                '            \"rdc\": \"\",'+
                '            \"selection\": \"\",'+
                '            \"split1\": \"990\",'+
                '            \"split2\": \"02\",'+
                '            \"split3\": \"00\",'+
                '            \"noStockvalue\": false'+
                '        },'+
                '        {'+
                '            \"abbreviation\": \"9900300\",'+
                '            \"tav\": \"21\",'+
                '            \"code\": \"9900300\",'+
                '            \"group\": \"WT\",'+
                '            \"intrastat\": {'+
                '                \"code\": \"00000000\",'+
                '                \"weight\": 123.453'+
                '            },'+
                '            \"class\": \"W\",'+
                '            \"rdc\": \"\",'+
                '            \"selection\": \"\",'+
                '            \"split1\": \"990\",'+
                '            \"split2\": \"03\",'+
                '            \"split3\": \"00\",'+
                '            \"noStockvalue\": false'+
                '        }'+
                '    ]'+
                '}';
        WebCareArticleType r = WebCareArticleType.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareArticleType.Type objTypes = new WebCareArticleType.Type(System.JSON.createParser(json));
        System.assert(objTypes != null);
        System.assert(objTypes.abbreviation == null);
        System.assert(objTypes.tav == null);
        System.assert(objTypes.code == null);
        System.assert(objTypes.group_Z == null);
        System.assert(objTypes.intrastat == null);
        System.assert(objTypes.class_Z == null);
        System.assert(objTypes.rdc == null);
        System.assert(objTypes.selection == null);
        System.assert(objTypes.split1 == null);
        System.assert(objTypes.split2 == null);
        System.assert(objTypes.split3 == null);
        System.assert(objTypes.noStockvalue == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareArticleType.Intrastat_Z objIntrastat_Z = new WebCareArticleType.Intrastat_Z(System.JSON.createParser(json));
        System.assert(objIntrastat_Z != null);
        System.assert(objIntrastat_Z.code == null);
        System.assert(objIntrastat_Z.weight == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareArticleType objWebCareArticleType = new WebCareArticleType(System.JSON.createParser(json));
        System.assert(objWebCareArticleType != null);
        System.assert(objWebCareArticleType.types == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareArticleType.Intrastat objIntrastat = new WebCareArticleType.Intrastat(System.JSON.createParser(json));
        System.assert(objIntrastat != null);
        System.assert(objIntrastat.code == null);
        System.assert(objIntrastat.weight == null);
    }
}