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

public without sharing class WebCareCartService {

    @AuraEnabled
    public static String getWebCareCartItems(String recordId) {

        system.debug('recordId: ' + recordId);
        String webCareCart = transformCart(recordId);
        return webCareCart;
    }

    public static String transformCart(String cartId) {

        String jsonBody = '';

        WebCart cart = [Select id, AccountId from WebCart where id =:cartId LIMIT 1];

        List<CartItem> cartItems= [SELECT
                CartId,
                Cart.AccountId,
                Product2.Webcare_Id__c,
                Product2.ProductCode,
                Product2.Parent__r.Brand_Profile_Text__c,
                Product2.Parent__r.Dimension_Indexed__c,
                Product2.Parent__r.EAN_Code__c,
                Product2.Parent__r.Description_NL__c,
                Product2.Name,
                Product2.Supplier__r.Webcare_Id__c,
                Product2.Supplier__r.Name,
                Quantity, Delivery_Cost__c,
                Label_Cost__c,
                Delivery_Date__c,
                TotalListPrice,
                ListPrice,
                GrossUnitPrice,
                TotalLineGrossAmount,
                TotalLineNetAmount,
                TotalLineTaxAmount
        FROM CartItem
        WHERE CartId = :cart.Id
        ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];

        List<String> supplierCodes = new List<String>();

        Account buyerAccount = [SELECT Id, Webcare_Id__c FROM Account WHERE Id = :cart.AccountId];

        //Add the supplier codes to a list so we can use this to loop through it later
        for(CartItem cartItem : cartItems) {
            if(!supplierCodes.contains(cartItem.Product2.Supplier__r.Webcare_Id__c)) {
                supplierCodes.add(cartItem.Product2.Supplier__r.Webcare_Id__c);
            }
        }

        WebCareCart wcCart = new WebCareCart();
        wcCart.customer = buyerAccount.Webcare_Id__c;
        wcCart.basket = cart.Id;
        List<WebCareCart.Orders> orders = new List<WebCareCart.Orders>();
        //Loop through the supplier codes
        for(String supplierCode : supplierCodes) {
            WebCareCart.Orders wcOrder = new WebCareCart.Orders();
            Decimal totalProductCost = 0;
            Decimal totalTransportCost = 0;
            Decimal totalLabelCost = 0;
            Decimal totalCostIncVat = 0;
            Decimal totalCostExVat = 0;
            Decimal taxes = 0;
            //Loop through the cart items
            List<WebCareCart.Articles> articles = new List<WebCareCart.Articles>();
            for(CartItem cartItem : cartItems) {
                //If the supplier code matches the supplier code of the cart item
                if(supplierCode == cartItem.Product2.Supplier__r.Webcare_Id__c) {
                    //Add the cart item to the json body
                    wcOrder.supplierCode = supplierCode;
                    wcOrder.supplierName = cartItem.Product2.Supplier__r.Name;
                    wcOrder.totalProductCost = totalProductCost += cartItem.TotalListPrice;
                    wcOrder.totalTransportCost = totalTransportCost += cartItem.Delivery_Cost__c;
                    wcOrder.totalLabelCost = totalLabelCost += cartItem.Label_Cost__c;
                    wcOrder.totalCostIncVat = totalCostIncVat += cartItem.TotalLineGrossAmount;
                    wcOrder.totalCostExVat = totalCostExVat += cartItem.TotalLineNetAmount;
                    wcOrder.taxes = taxes += cartItem.TotalLineTaxAmount;
                    WebCareCart.Articles wcArticle = new WebCareCart.Articles();
                    wcArticle.articleId = cartItem.Product2.ProductCode;
                    wcArticle.profileText = cartItem.Product2.Parent__r.Brand_Profile_Text__c;
                    wcArticle.articleDescription = cartItem.Product2.Parent__r.Description_NL__c;
                    wcArticle.quantity = cartItem.Quantity;
                    wcArticle.price = cartItem.ListPrice;
                    wcArticle.totalLinePrice = cartItem.TotalListPrice;
                    wcArticle.deliveryTime = String.valueOf(cartItem.Delivery_Date__c);
                    articles.add(wcArticle);
                }
            }
            wcOrder.articles = articles;
            orders.add(wcOrder);
        }
        wcCart.orders = orders;

        jsonBody = JSON.serialize(wcCart);
        system.debug('jsonBody: ' + jsonBody);

        return jsonBody;


    }

}