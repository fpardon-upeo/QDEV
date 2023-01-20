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
 * Created: 6/12/2022
 * Last Updated: 6/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

@IsTest
public class WebCareTransportCostTest {

    static testMethod void testParse() {
        String json = '{'+
                '    \"suppliers\": ['+
                '        {'+
                '            \"id\": \"6576\",'+
                '            \"cutoffTime\": \"15\",'+
                '            \"deliveryTime\": \"\",'+
                '            \"tourism\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"truck\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"10\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ]'+
                '        },'+
                '        {'+
                '            \"id\": \"8523\",'+
                '            \"cutoffTime\": \"15:00\",'+
                '            \"deliveryTime\": \"3\",'+
                '            \"tourism\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"20\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"25\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"30\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"moto\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"20\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"30\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"35\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ],'+
                '            \"truck\": ['+
                '                {'+
                '                    \"amount\": 1,'+
                '                    \"priceDistri\": \"60\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 2,'+
                '                    \"priceDistri\": \"70\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 3,'+
                '                    \"priceDistri\": \"75\",'+
                '                    \"pricePartner\": \"\"'+
                '                },'+
                '                {'+
                '                    \"amount\": 4,'+
                '                    \"priceDistri\": \"0\",'+
                '                    \"pricePartner\": \"\"'+
                '                }'+
                '            ]'+
                '        }'+
                '    ]'+
                '}';
        WebCareTransportCost obj = WebCareTransportCost.parse(json);
        System.assert(obj != null);
    }
}