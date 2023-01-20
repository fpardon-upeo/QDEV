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
public class WebCareBrandTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '    \"brands\": ['+
                '        {'+
                '            \"abbreviation\": \"1H\",'+
                '            \"abbreviationRenta\": \"1H\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"VHIP 50\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"VHIP 50\"'+
                '                }'+
                '            ],'+
                '            \"class\": \"T\",'+
                '            \"ranking\": 0,'+
                '            \"level\": \"\",'+
                '            \"active\": true'+
                '        },'+
                '        {'+
                '            \"abbreviation\": \"3M\",'+
                '            \"abbreviationRenta\": \"3M\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"3M\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"3M\"'+
                '                }'+
                '            ],'+
                '            \"class\": \"T\",'+
                '            \"ranking\": 0,'+
                '            \"level\": \"\",'+
                '            \"active\": true'+
                '        }'+
                '    ]'+
                '}';
        WebCareBrand r = WebCareBrand.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareBrand.Description objDescription = new WebCareBrand.Description(System.JSON.createParser(json));
        System.assert(objDescription != null);
        System.assert(objDescription.lang == null);
        System.assert(objDescription.value == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareBrand.Brand objBrands = new WebCareBrand.Brand(System.JSON.createParser(json));
        System.assert(objBrands != null);
        System.assert(objBrands.abbreviation == null);
        System.assert(objBrands.abbreviationRenta == null);
        System.assert(objBrands.description == null);
        System.assert(objBrands.class_Z == null);
        System.assert(objBrands.ranking == null);
        System.assert(objBrands.level == null);
        System.assert(objBrands.active == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        WebCareBrand objWebCareBrand = new WebCareBrand(System.JSON.createParser(json));
        System.assert(objWebCareBrand != null);
        System.assert(objWebCareBrand.brands == null);
    }
}