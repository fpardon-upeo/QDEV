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
 * Created: 16/11/2022
 * Last Updated: 16/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
Description: Class to handle both auth and callouts to webcare

Change Log:

Dependencies: WebCareAuthResponse

*/

public with sharing class WebCareRest {

    //----------------------------------------TOKEN METHODS---------------------------------------------------//


    public static Map<String, String> getToken(){

        /**
         * Logs in again to get a new token if refresh token is expired
         *
        */

        Map<String, String> tokenMap = new Map<String, String>();

        String url = 'callout:WebCare/auth/signin';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setheader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        req.setBody('{"user":"{!$Credential.Username}","key":"{!$Credential.Password}"}');
        system.debug('req: '+req.getBody());
        Http h = new Http();
        HttpResponse resp = h.send(req);
        WebCareAuthResponse obj = WebCareAuthResponse.parse(resp.getBody());
        system.debug('obj: '+obj);
        tokenMap.put('accessToken', obj.accessToken);
        tokenMap.put('refreshToken', obj.refreshToken);
        return tokenMap;
    }

    public static Map<String, String> refreshToken(){

        /**
         * Refreshes the token
         *
        */

        WebCare_Bearer_Token__c token = WebCare_Bearer_Token__c.getOrgDefaults();
        Map<String, String> tokenMap = new Map<String, String>();

        String url = 'callout:WebCare/auth/refreshtoken';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setheader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        req.setBody('{"accessToken":"' + token.Token__c +'","refreshToken":"'+ token.Refresh_Token__c +'"}');
        system.debug('req: '+req.getBody());
        Http h = new Http();
        HttpResponse resp = h.send(req);
        WebCareAuthResponse obj = WebCareAuthResponse.parse(resp.getBody());
        tokenMap.put('accessToken', obj.accessToken);
        tokenMap.put('refreshToken', obj.refreshToken);
        return tokenMap;
    }

    public static void saveToken(string accesstoken, String refreshtoken){

        /**
         * Save the token to the org defaults
        */

        WebCare_Bearer_Token__c token = WebCare_Bearer_Token__c.getOrgDefaults();
        token.Token__c = accesstoken;
        token.Refresh_Token__c = refreshtoken;
        update token;

    }

    //----------------------------------------CALLOUT METHODS---------------------------------------------------//

    public static HttpResponse doCallOut(String path, String method){

        /**
         * Prepares the callouts and hands it of handleCallout
        */

        WebCare_Bearer_Token__c token = WebCare_Bearer_Token__c.getOrgDefaults();

        String url = 'callout:webCareNew'+path;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        system.debug(url);
        system.debug('token: '+token.Token__c);
        req.setheader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'bearer '+token.Token__c);
        req.setMethod(method);
        req.setTimeout(60000);
        Http h = new Http();
        HttpResponse resp = handleCallout(req, h);
        return resp;
    }

    public static HttpResponse doPost(String path, String method, String body){

        /**
         * Prepares the callouts and hands it of handleCallout
        */

        WebCare_Bearer_Token__c token = WebCare_Bearer_Token__c.getOrgDefaults();

        String url = 'callout:webCareNew'+path;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        system.debug(url);
        req.setheader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'bearer '+token.Token__c);
        req.setMethod(method);
        req.setTimeout(30000);
        req.setBody(body);
        Http h = new Http();
        HttpResponse resp = handleCallout(req, h);
        return resp;
    }

    public static HttpResponse handleCallout(HttpRequest req, Http h) {

        /**
         * Handles the callout and refreshes the token if needed
        */

        HttpResponse resp = h.send(req);

        system.debug('resp: '+resp.getStatusCode());
        if (resp.getStatusCode() == 200) {
            System.debug('valid response');
            return resp;
        } else if (resp.getStatusCode() == 403) {
            System.debug('invalid response, refreshing token');
            //First try to refresh the token
            Map<String, String> newTokenMap = refreshToken();
            req.setHeader('Authorization', 'bearer ' + newTokenMap.get('accessToken'));
            resp = h.send(req);
            if (resp.getStatusCode() == 200) {
                System.debug('valid response from refreshToken');
                return resp;
            } else {
                //If that fails, get a new token
                system.debug('invalid response from refreshToken, getting new token');
                Map<String, String> newForceTokenMap = getToken();
                req.setHeader('Authorization', 'bearer ' + newForceTokenMap.get('accessToken'));
                resp = h.send(req);
                //If the new token is valid, save it
                if (resp.getStatusCode() == 200) {
                    System.debug('valid response from getToken');
                    return resp;
                } else {
                    System.debug('invalid response from getToken');
                    return resp;
                }
            }
        } else {
            System.debug('invalid response');
            return resp;
        }
    }
}