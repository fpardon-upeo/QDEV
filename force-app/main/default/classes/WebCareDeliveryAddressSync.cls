/**
 * Created by fpardon on 30/11/2022.
 */

public with sharing class WebCareDeliveryAddressSync {


    public static void syncAddress(ContactPointAddress address){

        WebCareDeliveryAddress webCareDeliveryAddress = parseContactPointAddress(address);
        System.debug('webCareDeliveryAddress: ' + webCareDeliveryAddress);
        postDeliveryAddress(webCareDeliveryAddress);
        System.debug('webCareDeliveryAddress: ' + JSON.serialize(webCareDeliveryAddress));
    }

    public static WebCareDeliveryAddress parseContactPointAddress(ContactPointAddress address){

        WebCareDeliveryAddress webCareDeliveryAddress = new WebCareDeliveryAddress();

        webCareDeliveryAddress.id = address.Id;
        webCareDeliveryAddress.alias = address.Name;
        webCareDeliveryAddress.street = address.Street;
        webCareDeliveryAddress.houseNumber = '';
        webCareDeliveryAddress.zip = address.PostalCode;
        webCareDeliveryAddress.city = address.City;
        webCareDeliveryAddress.country = address.CountryCode;
        webCareDeliveryAddress.userId = address.CreatedBy.Contact.Webcare_Id__c;
        webCareDeliveryAddress.email = address.CreatedBy.Contact.Email;

        return webCareDeliveryAddress;
    }

    public static void postDeliveryAddress(WebCareDeliveryAddress webCareDeliveryAddress){

        String payload = JSON.serialize(webCareDeliveryAddress);
        HttpResponse resp = WebCareRest.doPost('/portal/deliveryAddress', 'POST', payload);
        System.debug('resp body: ' + resp.getBody());
        System.debug('resp status: ' + resp.getStatusCode());
    }

}