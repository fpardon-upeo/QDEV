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
 * Created: 29/11/2022
 * Last Updated: 29/11/2022
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

public with sharing class WebCareCart {

    public class Orders {
        public String supplierCode;
        public String supplierName;
        public String deliveryAddress;
        public String transport;
        public Decimal totalProductCost;
        public Decimal totalTransportCost;
        public Decimal totalLabelCost;
        public Decimal totalCostExVat;
        public Decimal totalCostIncVat;
        public Decimal taxes;
        public List<Articles> articles;
    }

    public String customer;
    public String basket;
    public List<Orders> orders;

    public class Articles {
        public String articleId;
        public String articleName;
        public String articleDescription;
        public Decimal price;
        public Decimal totalLinePrice;
        public Decimal quantity;
        public String deliveryTime;
        public String profileText;
    }


    public static WebCareCart parse(String json) {
        return (WebCareCart) System.JSON.deserialize(json, WebCareCart.class);
    }
}