/**
 * Created by fpardon on 30/11/2022.
 */

@IsTest
public with sharing class WebCareDeliveryAddressTest {

    @IsTest
    static void testParse() {
        String json=		'{'+
                '  "id": "",'+
                '  "alias": "",'+
                '  "street": "",'+
                '  "number": "",'+
                '  "zip": "",'+
                '  "city": "",'+
                '  "country": "",'+
                '  "userId": "",'+
                '  "email": ""'+
                '}';
        WebCareDeliveryAddress obj = WebCareDeliveryAddress.parse(json);
        System.assert(obj != null);
    }

}