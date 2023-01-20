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
//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class WebCareCustomerTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '    \"customers\": ['+
                '        {'+
                '            \"id\": \"8418DA516F3548DA9DA7FC875C56731E\",'+
                '            \"email\": \"jan.vanlemmens@skynet.be\",'+
                '            \"client\": {'+
                '                \"id\": \"303353\",'+
                '                \"name\": \"PANALYTICS COMM. V.\",'+
                '                \"vatnumberCountry\": \"BE\",'+
                '                \"vatnumber\": \"0679447683\"'+
                '            },'+
                '            \"partnerType\": \"p\",'+
                '            \"priceGrid\": \"2\",'+
                '            \"modules\": {'+
                '                \"tourism\": true,'+
                '                \"moto\": true,'+
                '                \"truck\": false'+
                '            },'+
                '            \"nonActiveSuppliers\": ['+
                '                \"5701\",'+
                '                \"8523\",'+
                '                \"12226\"'+
                '            ],'+
                '            \"blockedCustomer\": true,'+
                '            \"amountOverdue\": 10,'+
                '            \"openAmount\": 20,'+
                '            \"creditLimit\": 3000,'+
                '            \"mainAddress\": {'+
                '                \"street\": \"BURGGRAVESTRAAT.\",'+
                '                \"numberz\": \"92\",'+
                '                \"zip\": \"9140\",'+
                '                \"city\": \"ELVERSELE\",'+
                '                \"country\": \"BE\"'+
                '            },'+
                '            \"firstname\": \"\",'+
                '            \"surname\": \"\",'+
                '            \"supplierCodes\": ['+
                '                {'+
                '                    \"supplier\": 8523,'+
                '                    \"shipTo\": \"ladr\",'+
                '                    \"orderTo\": \"badr\"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ]'+
                '}';


        String jsonSingleUser = '{'+
                '            \"id\": \"8418DA516F3548DA9DA7FC875C56731E\",'+
                '            \"email\": \"jan.vanlemmens@skynet.be\",'+
                '            \"client\": {'+
                '                \"id\": \"303353\",'+
                '                \"name\": \"PANALYTICS COMM. V.\",'+
                '                \"vatnumberCountry\": \"BE\",'+
                '                \"vatnumber\": \"0679447683\"'+
                '            },'+
                '            \"partnerType\": \"p\",'+
                '            \"priceGrid\": \"2\",'+
                '            \"modules\": {'+
                '                \"tourism\": true,'+
                '                \"moto\": true,'+
                '                \"truck\": false'+
                '            },'+
                '            \"nonActiveSuppliers\": [],'+
                '            \"blockedCustomer\": true,'+
                '            \"amountOverdue\": 10,'+
                '            \"openAmount\": 20,'+
                '            \"creditLimit\": 3000,'+
                '            \"mainAddress\": {'+
                '                \"street\": \"BURGGRAVESTRAAT.\",'+
                '                \"number\": \"92\",'+
                '                \"zip\": \"9140\",'+
                '                \"city\": \"ELVERSELE\",'+
                '                \"country\": \"BE\"'+
                '            },'+
                '            \"firstname\": \"\",'+
                '            \"surname\": \"\",'+
                '            \"supplierCodes\": ['+
                '                {'+
                '                    \"supplier\": \"8523\",'+
                '                    \"shipTo\": \"ladr\",'+
                '                    \"orderTo\": \"badr\"'+
                '                },'+
                '                {'+
                '                    \"supplier\": \"12226\",'+
                '                    \"shipTo\": \"ladr1\",'+
                '                    \"orderTo\": \"badr1\"'+
                '                }'+
                '            ]'+
                '        }';



        WebCareCustomer obj = WebCareCustomer.parseMultipleUsers(json);
        System.assert(obj != null);

        WebCareCustomer.Customer objSingle = WebCareCustomer.parseSingleUser(json);
        System.assert(objSingle != null);
    }
}