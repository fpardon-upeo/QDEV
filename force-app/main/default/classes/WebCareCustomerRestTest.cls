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
public class WebCareCustomerRestTest {

    @TestSetup
    public static void recordCreation() {
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus Login'];
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name = 'System Administrator'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'testclass@classtest.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.PortalRole = 'Manager';
        insert user;

    }



    @IsTest
    public static void webCustomerRestValidTest() {


        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String jsonBody = '{'+
                '            "id": "8418DA516F3548DA9DA7FC875C56731E",'+
                '            "email": "test.test@test.be",'+
                '            "client": {'+
                '                "id": "303358",'+
                '                "name": "TEST COMM. V.",'+
                '                "vatnumberCountry": "BE",'+
                '                "vatnumber": "0679447683"'+
                '            },'+
                '            "partnerType": "p",'+
                '            "priceGrid": "2",'+
                '            "modules": {'+
                '                "tourism": true,'+
                '                "moto": true,'+
                '                "truck": false'+
                '            },'+
                '            "nonActiveSuppliers": ['+
                '                "5701",'+
                '                "8523",'+
                '                "12226"'+
                '            ],'+
                '            "blockedCustomer": true,'+
                '            "amountOverdue": 10,'+
                '            "openAmount": 20,'+
                '            "creditLimit": 3000,'+
                '            "mainAddress": {'+
                '                "street": "BURGGRAVESTRAAT.",'+
                '                "number": "92",'+
                '                "zip": "9140",'+
                '                "city": "ELVERSELE",'+
                '                "country": "BE"'+
                '            },'+
                '            "firstname": "",'+
                '            "surname": "",'+
                '            "supplierCodes": ['+
                '                {'+
                '                    "supplier": 8523,'+
                '                    "shipTo": "ladr",'+
                '                    "orderTo": "badr"'+
                '                }'+
                '            ]'+
                '        }';

        req.requestURI = '/services/apexrest/v1/Customer';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody =  Blob.valueOf(jsonBody); //Request Body
        RestContext.request = req;
        RestContext.response= res;

        BuyerGroup buyerGroup = new BuyerGroup();
        buyerGroup.Name = 'Test Buyer Group';
        buyerGroup.Type__c = 'p2';

        insert buyerGroup;

        List<Account> accounts = new List<Account>();
        Account acc = new Account(Name = 'Supplier 5701', Webcare_Id__c = '5701', Type = 'Supplier');
        accounts.add(acc);
        Account acc1 = new Account(Name = 'Supplier 8523', Webcare_Id__c = '8523', Type = 'Supplier');
        accounts.add(acc1);
        Account acc2 = new Account(Name = 'Supplier 12226', Webcare_Id__c = '12226', Type = 'Supplier');
        accounts.add(acc2);

        insert accounts;

        User user = [Select Id From User Where Username = 'testclass@classtest.com'];



        system.runAs(user) {

            Test.startTest();

            WebCareCustomerRest.updateCustomer();

            Test.stopTest();

            List<Account> accountsCheck = [SELECT Id FROM Account WHERE Type != 'Supplier'];
            System.assertEquals(1, accountsCheck.size());
        }
    }
}