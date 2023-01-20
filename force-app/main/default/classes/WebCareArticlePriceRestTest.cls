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
 * Created: 24/11/2022
 * Last Updated: 24/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareArticlePriceRestTest {
    @IsTest
    static void webCareArticlePriceRestValidTest() {

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;

        CommerceEntitlementPolicy policy = new CommerceEntitlementPolicy(
                Name = 'Test Policy'
        );
        insert policy;


        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );
        insert storePriceBook;

        Account account = new Account(
            Name = 'Test Account',
            Webcare_Id__c = '6576'
        );

        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = 'Test Product Code',
            IsActive = true,
            Type = 'Base',
            Webcare_Id__c = '130595'
        );

        insert product;
        insert account;

        Pricebook2 pb1 = new Pricebook2(Name = 'Test Pricebook 1' , Type__c = 'd1');
        Pricebook2 pb2 = new Pricebook2(Name = 'Test Pricebook 2', Type__c = 'd2');
        Pricebook2 pb3 = new Pricebook2(Name = 'Test Pricebook 3', Type__c = 'd3');
        Pricebook2 pb4 = new Pricebook2(Name = 'Test Pricebook 4', Type__c = 'p1');
        Pricebook2 pb5 = new Pricebook2(Name = 'Test Pricebook 5', Type__c = 'p2');
        Pricebook2 pb6 = new Pricebook2(Name = 'Test Pricebook 6', Type__c = 'p3');

        List<PriceBook2> pricebooks = new List<PriceBook2>();
        pricebooks.add(pb1);
        pricebooks.add(pb2);
        pricebooks.add(pb3);
        pricebooks.add(pb4);
        pricebooks.add(pb5);
        pricebooks.add(pb6);

        insert pricebooks;



        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String jsonBody = '{'+
                '            "article": "130595",'+
                '            "ean": "4019238318036",'+
                '            "priceRate": "235.50",'+
                '            "promoType": "none",'+
                '            "supplier": ['+
                '                {'+
                '                    "id": "6576",'+
                '                    "quantity1": "> 50",'+
                '                    "deliveryDate1": "2022-11-17",'+
                '                    "quantity2": "",'+
                '                    "deliveryDate2": "",'+
                '                    "quantity3": "",'+
                '                    "deliveryDate3": "",'+
                '                    "prices": ['+
                '                        {'+
                '                            "type": "d1",'+
                '                            "value": ""'+
                '                        },'+
                '                        {'+
                '                            "type": "d2",'+
                '                            "value": ""'+
                '                        },'+
                '                        {'+
                '                            "type": "d3",'+
                '                            "value": ""'+
                '                        },'+
                '                        {'+
                '                            "type": "p1",'+
                '                            "value": ""'+
                '                        },'+
                '                        {'+
                '                            "type": "p2",'+
                '                            "value": ""'+
                '                        },'+
                '                        {'+
                '                            "type": "p3",'+
                '                            "value": ""'+
                '                        }'+
                '                    ]'+
                '                }'+
                '            ]'+
                '}';

        req.requestURI = '/services/apexrest/v1/Customer';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody =  Blob.valueOf(jsonBody); //Request Body
        RestContext.request = req;
        RestContext.response= res;
        WebCareArticlePriceRest.updateArticlePrice();

        List<Product2> mainProducts = [SELECT Id FROM Product2 WHERE Webcare_Id__c = '130595'];
        List<Product2> variationProducts = [SELECT Id FROM Product2 WHERE ProductClass = 'Variation'];
        List<ProductAttribute> productAttributes = [SELECT Id FROM ProductAttribute WHERE VariantParentId = :mainProducts[0].Id];
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry WHERE Product2Id = :variationProducts[0].Id];

        System.assertEquals(1, mainProducts.size());
        System.assertEquals(1, variationProducts.size());
        System.assertEquals(1, productAttributes.size());
        System.assertEquals(7, pricebookEntries.size());

    }
}