public with sharing class WebCareCartBtoB {

    public class Orders {
        public String supplierCode;
        public String supplierLogo;
        public String supplierName;
        public String supplierType;
        public Boolean supplierShowAllAdresses;
        public String deliveryAddress;
        public String transport;
        public Decimal totalQuantity;
        public Decimal totalProductCost;
        public Decimal totalTransportCost;
        public Boolean showTransportCost;
        public Decimal totalLabelCost;
        public Decimal totalCostExVat;
        public Decimal taxes;
        public Decimal totalCostIncVat;
        public List<Articles> articles;
    }

    public String customer;
    public Decimal creditLimit;
    public Decimal availableCredit;
    public String basket;
    public Decimal globalProductCost;
    public Decimal globalTransportCost;
    public Decimal globalLabelCost;
    public Decimal globalCostExVat;
    public Decimal globalTaxes;
    public Decimal globalCostIncVat;
    public List<Orders> orders;

    public class Articles {
        public Boolean hasErrors;
        public String cartItemId;
        public String articleId;
        public String articleName;
        public String articleDescription;
        public String comment;
        public Decimal price;
        public Decimal totalLinePrice;
        public Decimal quantity;
        public Decimal maxQuantity;
        public String deliveryTime;
        public String profileText;
        public String profileBrand;
        public Decimal recytyre;
        public Decimal totalRecytyre;
        public String recytyreCategory;
        public Boolean showRecytyre;
        public Boolean changed;
        public Boolean priceChanged;
        public Boolean quantityChanged;
        public Boolean deliveryDateChanged;
    }


    public static WebCareCartBtoB parse(String json) {
        return (WebCareCartBtoB) System.JSON.deserialize(json, WebCareCartBtoB.class);
    }
}