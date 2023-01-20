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

@RestResource(urlMapping='/v1/Article')
global with sharing class WebCareArticleRest {

    @HttpPost
    global static String updateArticle() {

        RestRequest request = RestContext.request;
        String body = (String) request.requestBody.toString();
        List<Product2> prodList = New List<Product2>();
        Schema.SObjectField f = Product2.Fields.Webcare_Id__c;

        system.debug('json: ' + body);
        WebCareArticle.Article article = WebCareArticle.parseSingleArticle(body);
        WebCareArticleSync wcas = new WebCareArticleSync();
        wcas.initialize();
        Product2 prod = wcas.tranformProduct(article);
        prodList.add(prod);

        List<DataBase.UpsertResult> upsertResult = Database.upsert(prodList, f, false);

        String result = '';
        Database.UpsertResult ur = upsertResult[0];
        if(ur.isSuccess()) {
            result = 'Success, Id: ' + ur.getId();
            return result;
        } else {
            result = 'Error: ' + ur.getErrors()[0].getMessage();
            Error_Log__c errorLog = DMLhandler.errorLogger(ur.getErrors()[0], prod, 'Webcare Update');
            insert errorLog;
            return result;
        }
    }
}