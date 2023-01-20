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
 * Created: 29/12/2022
 * Last Updated: 29/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
public class WebCareCartTest{

    @IsTest
    static void testParse() {
        String json=		'{'+
                '  "orders": ['+
                '    {'+
                '      "transport": "0",'+
                '      "supplier": "3606",'+
                '      "deliveryAddressId": "8lW5E0000009WSWUA2",'+
                '      "articles": ['+
                '        {'+
                '          "quantity": "2",'+
                '          "price": "62.15",'+
                '          "id": "176714",'+
                '          "deliveryTime": "2022-12-30"'+
                '        }'+
                '      ]'+
                '    }'+
                '  ],'+
                '  "customer": "8418DA516F3548DA9DA7FC875C56731E",'+
                '  "basket": "0a65E00000002MsQAI"'+
                '}';
        WebCareCart obj = WebCareCart.parse(json);
        System.assert(obj != null);
        WebCareCartBtoB b2b = WebCareCartBtoB.parse(json);
        System.assert(b2b != null);
    }

}