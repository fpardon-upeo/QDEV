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

public with sharing class WebCareTransportCostSync {

    public static void getTransportCosts(){

        HttpResponse resp = WebCareRest.doCallOut('/portal/transportcost', 'GET');
        WebCareTransportCost transportCost = WebCareTransportCost.parse(resp.getBody());
        transformTransportCosts(transportCost);
    }

    public static void transformTransportCosts(WebCareTransportCost transportCost){

        List<Transport_Cost__c> transportCosts = new List<Transport_Cost__c>();

        for(WebCareTransportCost.Supplier tc : transportCost.suppliers){
            for(WebCareTransportCost.Tourism tourism : tc.tourism){
                Transport_Cost__c transportCostRecord = new Transport_Cost__c();
                transportCostRecord.Name = 'Tourism ' + String.valueOf(tourism.amount);
                transportCostRecord.Price_Distri__c = tourism.priceDistri;
                transportCostRecord.Price_Partner__c = tourism.pricePartner;
                transportCostRecord.Amount__c = tourism.amount;
                transportCostRecord.Account__r = new Account(Webcare_Id__c = String.valueOf(tc.id));
                transportCostRecord.Webcare_Id__c = tc.id +'-'+'Tourism-' + String.valueOf(tourism.amount);
                transportCostRecord.Cutoff_Time__c = tc.cutoffTime;
                transportCostRecord.Delivery_Time__c = tc.deliveryTime;
                transportCostRecord.Type__c = 'Car';
                transportCosts.add(transportCostRecord);
            }
            if(tc.moto != null){
                for(WebCareTransportCost.Tourism moto : tc.moto){
                    Transport_Cost__c transportCostRecord = new Transport_Cost__c();
                    transportCostRecord.Name = 'Moto ' + String.valueOf(moto.amount);
                    transportCostRecord.Price_Distri__c = moto.priceDistri;
                    transportCostRecord.Price_Partner__c = moto.pricePartner;
                    transportCostRecord.Amount__c = moto.amount;
                    transportCostRecord.Account__r = new Account(Webcare_Id__c = String.valueOf(tc.id));
                    transportCostRecord.Webcare_Id__c = tc.id +'-'+'Moto-' + String.valueOf(moto.amount);
                    transportCostRecord.Cutoff_Time__c = tc.cutoffTime;
                    transportCostRecord.Delivery_Time__c = tc.deliveryTime;
                    transportCostRecord.Type__c = 'Moto';
                    transportCosts.add(transportCostRecord);
                }
            }
            if(tc.truck != null){
                for(WebCareTransportCost.Tourism truck : tc.truck){
                    Transport_Cost__c transportCostRecord = new Transport_Cost__c();
                    transportCostRecord.Name = 'Truck ' + String.valueOf(truck.amount);
                    transportCostRecord.Price_Distri__c = truck.priceDistri;
                    transportCostRecord.Price_Partner__c = truck.pricePartner;
                    transportCostRecord.Amount__c = truck.amount;
                    transportCostRecord.Account__r = new Account(Webcare_Id__c = String.valueOf(tc.id));
                    transportCostRecord.Webcare_Id__c = tc.id +'-'+'Truck-' + String.valueOf(truck.amount);
                    transportCostRecord.Cutoff_Time__c = tc.cutoffTime;
                    transportCostRecord.Delivery_Time__c = tc.deliveryTime;
                    transportCostRecord.Type__c = 'Truck';
                    transportCosts.add(transportCostRecord);
                }
            }
        }

        upsert transportCosts;
    }

}