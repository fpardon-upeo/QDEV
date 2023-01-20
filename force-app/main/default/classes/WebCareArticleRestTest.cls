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
 * Created: 18/11/2022
 * Last Updated: 18/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class WebCareArticleRestTest {

    @IsTest
    private static void webArticleRestValidTest() {


        Brand__c brand = new Brand__c(Name = 'MI', Abbreviation__c = 'MI');
        insert brand;

        Article_Type__c articleTypeCTS = new Article_Type__c(Name = 'CTS', Abbreviation__c = 'CTS', Code__c = 'CTS');
        insert articleTypeCTS;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String jsonBody = '{'+
                '            \"id\": \"189564\",'+
                '            \"reference\": \"MI466346\",'+
                '            \"ean\": \"3528704663460\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"225/70 R 15 112S AGILIS CROSSCLIMATE m+s 3pmsf TL\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"225/70 R 15 112S AGILIS CROSSCLIMATE m+s 3pmsf TL\"'+
                '                }'+
                '            ],'+
                '            \"brand\": \"MI\",'+
                '            \"type\": \"CTS\",'+
                '            \"vat\": \"21\",'+
                '            \"ecotax\": \"12\",'+
                '            \"dim1\": \"225\",'+
                '            \"dim2\": \"\",'+
                '            \"series\": \"70\",'+
                '            \"category\": \"R\",'+
                '            \"dim3\": \"15\",'+
                '            \"profile\": \"AGILIS CROSSCLIMATE\",'+
                '            \"application\": \"\",'+
                '            \"xlrf\": \"\",'+
                '            \"rof\": false,'+
                '            \"specialDesignation\": \"\",'+
                '            \"loadbalancing\": \"112\",'+
                '            \"speed\": \"S\",'+
                '            \"specification\": \"TL\",'+
                '            \"BEclass\": \"C\",'+
                '            \"grip\": \"A\",'+
                '            \"REvalue\": \"73\",'+
                '            \"REclass\": \"B\",'+
                '            \"ecotaxdescription\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                '                }'+
                '            ],'+
                '            \"commercial\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"AGILIS CROSSCLIMATE m+s 3pmsf\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"AGILIS CROSSCLIMATE m+s 3pmsf\"'+
                '                }'+
                '            ],'+
                '            \"qr\": ['+
                '                {'+
                '                    \"type\": \"eprel\",'+
                '                    \"value\": \"https://eprel.ec.europa.eu/qr/410558\"'+
                '                },'+
                '                {'+
                '                    \"type\": \"supplier\",'+
                '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/466346_fcs_en.pdf\"'+
                '                }'+
                '            ],'+
                '            \"ranking\": 0'+
                '        }';

        req.requestURI = '/services/apexrest/v1/Article';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody =  Blob.valueOf(jsonBody); //Request Body
        RestContext.request = req;
        RestContext.response= res;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;


        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );

        insert storePriceBook;

        String updateResult = WebCareArticleRest.updateArticle();
        System.debug('updateResult: ' + updateResult);

        List<Product2> products = [SELECT Id FROM Product2];
        System.assertEquals(1, products.size());


    }

    @IsTest
    private static void webArticleRestInvalidTest() {


        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String jsonBody = '{'+
                '            \"id\": \"189564\",'+
                '            \"reference\": \"MI466346\",'+
                '            \"ean\": \"3528704663460\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"225/70 R 15 112S AGILIS CROSSCLIMATE m+s 3pmsf TL\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"225/70 R 15 112S AGILIS CROSSCLIMATE m+s 3pmsf TL\"'+
                '                }'+
                '            ],'+
                '            \"ecotaxdescription\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"MILIEUBIJDRAGE CATEGORIE 1B\"'+
                '                }'+
                '            ],'+
                '            \"brand\": \"MI\",'+
                '            \"type\": \"CTS\",'+
                '            \"vat\": \"21\",'+
                '            \"ecotax\": \"12\",'+
                '            \"dim1\": \"225\",'+
                '            \"dim2\": \"\",'+
                '            \"series\": \"70\",'+
                '            \"category\": \"R\",'+
                '            \"dim3\": \"15\",'+
                '            \"profile\": \"AGILIS CROSSCLIMATE\",'+
                '            \"application\": \"\",'+
                '            \"xlrf\": \"\",'+
                '            \"rof\": false,'+
                '            \"specialDesignation\": \"\",'+
                '            \"loadbalancing\": \"112\",'+
                '            \"speed\": \"S\",'+
                '            \"specification\": \"TL\",'+
                '            \"BEclass\": \"C\",'+
                '            \"grip\": \"A\",'+
                '            \"REvalue\": \"73\",'+
                '            \"REclass\": \"B\",'+
                '            \"commercial\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"AGILIS CROSSCLIMATE m+s 3pmsf\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"AGILIS CROSSCLIMATE m+s 3pmsf\"'+
                '                }'+
                '            ],'+
                '            \"qr\": ['+
                '                {'+
                '                    \"type\": \"eprel\",'+
                '                    \"value\": \"https://eprel.ec.europa.eu/qr/410558\"'+
                '                },'+
                '                {'+
                '                    \"type\": \"supplier\",'+
                '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/466346_fcs_en.pdf\"'+
                '                }'+
                '            ],'+
                '            \"ranking\": 0'+
                '        }';

        req.requestURI = '/services/apexrest/v1/Article';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody =  Blob.valueOf(jsonBody); //Request Body
        RestContext.request = req;
        RestContext.response= res;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
                Id = pricebookId,
                IsActive = true
        );
        update standardPricebook;


        PriceBook2 storePriceBook = new PriceBook2(
                Name = 'QTeam B2B Price Book',
                IsActive = true
        );

        insert storePriceBook;

        WebCareArticleRest.updateArticle();

        List<Product2> products = [SELECT Id FROM Product2];
        System.assertEquals(0, products.size());

        List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c];
        System.assertEquals(1, errorLogs.size());



    }



}