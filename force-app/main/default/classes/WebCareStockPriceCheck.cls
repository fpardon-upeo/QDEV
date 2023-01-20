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

public with sharing class WebCareStockPriceCheck {

    public static Map<String, CartItem> getOldCartItems(String cartId, String suppliercode){

        List<CartItem> cartItems = new List<CartItem>();
        if(String.isBlank(suppliercode)){
            cartItems = [SELECT
            CartId,
            Id,
            Cart.AccountId,
            Product2.Webcare_Id__c,
            Product2.ProductCode,
            Product2.Supplier__r.Webcare_Id__c,
            Quantity, Delivery_Cost__c,
            Delivery_Date__c,
            Address__c,
            SalesPrice
            FROM CartItem
            WHERE CartId = :cartId
            ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];
        } else {
            cartItems = [SELECT
                    CartId,
                    Id,
                    Cart.AccountId,
                    Product2.Webcare_Id__c,
                    Product2.ProductCode,
                    Product2.Supplier__r.Webcare_Id__c,
                    Quantity, Delivery_Cost__c,
                    Delivery_Date__c,
                    Address__c,
                    SalesPrice
            FROM CartItem
            WHERE CartId = :cartId AND Product2.Supplier__r.Webcare_Id__c = :supplierCode
            ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];
        }

        Map<String, CartItem> cartItemsMap = new Map<String, CartItem>();
        for(CartItem cartItem : cartItems){
            cartItemsMap.put(cartItem.Id, cartItem);
        }
        return cartItemsMap;
    }


    @AuraEnabled
    public static List<CartItem> getSingleSupplierCartItems(String cartId, String supplierCode){

        system.debug('cartId: ' + cartId);
        system.debug('supplierCode: ' + supplierCode);

        List<CartItem> cartItems = [SELECT
                CartId,
                Cart.AccountId,
                Product2.Webcare_Id__c,
                Product2.ProductCode,
                Product2.Supplier__r.Webcare_Id__c,
                Quantity, Delivery_Cost__c,
                Delivery_Date__c,
                Address__c,
                SalesPrice,
                Updated_by_Price_Check__c,
                Price_Changed__c,
                Quantity_Changed__c,
                Delivery_Date_Changed__c
        FROM CartItem
        WHERE CartId = :cartId AND Product2.Supplier__r.Webcare_Id__c = :supplierCode
        ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];

        System.debug('cartItems: ' + cartItems);

        String payloadBody = transformEntireCartForPriceCheck(cartItems);
        System.debug('payloadBody: ' + payloadBody);
        WebCareStockPrice wcStockPrice = WebCareStockPrice.parse(payloadBody);
        for(WebCareStockPrice.Orders order : wcStockPrice.orders) {
            for(WebCareStockPrice.Articles article : order.articles) {
                Decimal totalPrice = Decimal.valueOf(article.price);
                Integer totalQty = Integer.valueOf(article.quantity);
                article.price = String.valueOf(totalPrice/totalQty);
            }
        }
        HttpResponse response = getWebCarePrices(payloadBody, cartId);
        System.debug('response: ' + response.getBody());
        List<CartItem> updatedCartItems = updateCartItems(response, cartId);
        return updatedCartItems;
    }

    @AuraEnabled
    public static List<CartItem> getAllCartItems(String cartId){

        system.debug('cartId: ' + cartId);

        List<CartItem> cartItems = [SELECT
                CartId,
                Cart.AccountId,
                Product2.Webcare_Id__c,
                Product2.ProductCode,
                Product2.Supplier__r.Webcare_Id__c,
                Quantity, Delivery_Cost__c,
                Delivery_Date__c,
                Address__c,
                SalesPrice,
                Updated_by_Price_Check__c,
                Price_Changed__c,
                Quantity_Changed__c,
                Delivery_Date_Changed__c
        FROM CartItem
        WHERE CartId = :cartId
        ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];

        System.debug('cartItems: ' + cartItems);

        String payloadBody = transformEntireCartForPriceCheck(cartItems);
        System.debug('payloadBody: ' + payloadBody);
        WebCareStockPrice wcStockPrice = WebCareStockPrice.parse(payloadBody);
        for(WebCareStockPrice.Orders order : wcStockPrice.orders) {
            for(WebCareStockPrice.Articles article : order.articles) {
                Decimal totalPrice = Decimal.valueOf(article.price);
                Integer totalQty = Integer.valueOf(article.quantity);
                article.price = String.valueOf(totalPrice/totalQty);
            }
        }
        HttpResponse response = getWebCarePrices(payloadBody, cartId);
        System.debug('response: ' + response.getBody());
        List<CartItem> updatedCartItems = updateCartItems(response, cartId);
        return updatedCartItems;
    }


    public static HttpResponse getWebCarePrices (String body, String cartId) {
        HttpResponse resp = WebCareRest.doPost('/portal/stockprice', 'POST', body);
        Webcare_Request__c webcareRequest = new Webcare_Request__c();
        webcareRequest.Cart__c = cartId;
        webcareRequest.Request__c = body;
        webcareRequest.Response__c = resp.getBody();
        webcareRequest.Status_Code__c = resp.getStatus();
        insert webcareRequest;
        return resp;
    }

    public static String transformEntireCartForPriceCheck(List<CartItem> cartItems) {

        system.debug('in transformEntireCartForPriceCheck');

    //----------------------------------------INIT---------------------------------------------------------------//

        String jsonBody = '';

        WebCart cart = new WebCart();

        //Not sure why this was added and by who, because we should already have the cartId from the cart items
        if(cartItems[0].CartId != null) {
            cart = [Select Id, AccountId from WebCart where Id = :cartItems[0].CartId];
        }
        //Get the customer webcare guid
        User user = [SELECT Id, Type_of_User__c, Webcare_Id__c FROM User WHERE Id = :UserInfo.getUserId()];
        //Get the userType so we can use it to determine which transport costs to use
        String userType = user.Type_of_User__c.startsWith('p') ? 'Partner' : 'Distributor';
        String customerId = user.Webcare_Id__c;

        //Add the supplier codes to a list so we can use this to loop through it later
        List<String> supplierCodes = new List<String>();
        for(CartItem cartItem : cartItems) {
            if(!supplierCodes.contains(cartItem.Product2.Supplier__r.Webcare_Id__c)) {
                supplierCodes.add(cartItem.Product2.Supplier__r.Webcare_Id__c);
            }
        }
        //Get supplier Transport Costs
        List<Transport_Cost__c> supplierTransportCosts = [SELECT Id, Account__r.Webcare_Id__c, Amount__c, Price__c, Price_Distri__c, Price_Partner__c FROM Transport_Cost__c WHERE Account__r.Webcare_Id__c IN :supplierCodes AND Type__c='Car'];
        //Create maps for distributor and partner transport costs
        Map<String, String> supplierTransportCostsMapDistri = new Map<String, String>();
        Map<String, String> supplierTransportCostsMapPartner = new Map<String, String>();
        for(Transport_Cost__c transportCost : supplierTransportCosts) {
            supplierTransportCostsMapDistri.put(transportCost.Account__r.Webcare_Id__c+'-'+transportCost.Amount__c, transportCost.Price_Distri__c);
            supplierTransportCostsMapPartner.put(transportCost.Account__r.Webcare_Id__c+'-'+transportCost.Amount__c, transportCost.Price_Partner__c);
        }

        //------------------------------------PREP JSON---------------------------------------------------------------//

        WebCareStockPrice wcStockPrice = new WebCareStockPrice();
        wcStockPrice.customer = customerId;
        wcStockPrice.basket = cart.Id;
        List<WebCareStockPrice.Orders> orders = new List<WebCareStockPrice.Orders>();
        //Loop through the supplier codes
        for(String supplierCode : supplierCodes) {
            WebCareStockPrice.Orders wcOrder = new WebCareStockPrice.Orders();
            wcOrder.supplier = supplierCode;
            Decimal totalQty = 0;
            //Loop through the cart items
            List<WebCareStockPrice.Articles> articles = new List<WebCareStockPrice.Articles>();
            for(CartItem cartItem : cartItems) {
                //If the supplier code matches the supplier code of the cart item
                if(supplierCode == cartItem.Product2.Supplier__r.Webcare_Id__c) {
                    //Add the cart item to the json body
                    wcOrder.deliveryAddressId = cartItem.Address__c;
                    WebCareStockPrice.Articles wcArticle = new WebCareStockPrice.Articles();
                    wcArticle.id = cartItem.Product2.ProductCode;
                    wcArticle.quantity = String.valueOf(cartItem.Quantity);
                    totalQty = totalQty + cartItem.Quantity;
                    wcArticle.price = String.valueOf(cartItem.SalesPrice);
                    wcArticle.deliveryTime = String.valueOf(cartItem.Delivery_Date__c);
                    wcArticle.changed = cartItem.Updated_by_Price_Check__c;
                    articles.add(wcArticle);
                }
            }
            //Add the transport costs to the json body
            String transport;

            if(userType == 'Distributor') {
                if(totalQty < 4) {
                    System.debug('totalQty < 4 Dist');
                    transport = supplierTransportCostsMapDistri.get(supplierCode+'-'+totalQty);
                } else {
                    System.debug('totalQty > 4 Dist');
                    transport = supplierTransportCostsMapDistri.get(supplierCode+'-4');
                }
            } else {
                if(totalQty < 4) {
                    System.debug('totalQty < 4 Part');
                    transport = supplierTransportCostsMapPartner.get(supplierCode+'-'+totalQty);
                } else {
                    System.debug('totalQty > 4 Part');
                    transport = supplierTransportCostsMapPartner.get(supplierCode+'-4');
                }
            }

            if(transport == null) {
                transport = '0';
                wcOrder.transport = transport;
            } else {
                wcOrder.transport = transport;
            }

            wcOrder.articles = articles;
            orders.add(wcOrder);
        }
        wcStockPrice.orders = orders;

        jsonBody = JSON.serialize(wcStockPrice, true);
        system.debug('jsonBody: ' + jsonBody);
        return jsonBody;
    }

    public static List<CartItem> updateCartItems(HttpResponse response, String cartId){

        Map<String, CartItem> oldMap = getOldCartItems(cartId, null);

        WebCareStockPrice wcStockPrice = WebCareStockPrice.parse(response.getBody());
        List<CartItem> cartItems = [SELECT
                                    CartId,
                                    Cart.AccountId,
                                    Product2.Webcare_Id__c,
                                    Product2.Supplier__r.Webcare_Id__c,
                                    Quantity, Delivery_Cost__c,
                                    Delivery_Date__c,
                                    Address__c,
                                    SalesPrice,
                                    Updated_by_Price_Check__c,
                                    Price_Changed__c,
                                    Quantity_Changed__c,
                                    Delivery_Date_Changed__c,
                                    Comment__c
                                    FROM CartItem
                                    WHERE CartId = :cartId
                                    ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];

        List<CartItem> updatedCartItems = new List<CartItem>();
        List<CartItem> cartItemsToDelete = new List<CartItem>();
        List<Order> ordersToCreate = new List<Order>();
        List<OrderItem> orderItemsToCreate = new List<OrderItem>();
        Map<String, Decimal> productQuantities = new map<String, Decimal>();
        String accountId = cartItems[0].Cart.AccountId;


        for(WebCareStockPrice.Orders wcSP : wcStockPrice.orders) {

            //Check whether we get back the orderSupplier & orderWebcare parameters from the response.
            //If we receive these, the cart has been validated and the order in webcare has been placed

            Boolean orderValidated = false;

            if(wcSP.orderWebcare != null) {
                System.debug('order placed in webcare');
                //Update the cart with the orderSupplier & orderWebcare parameters
                //To be implemented
                Order orderSF = new Order();
                orderSF.Webcare_Id__c = wcSP.orderWebcare;
                orderSf.Supplier_Order_Nbr__c = wcSP.delnoteWebcare;
                orderSF.Cart__c = cartId;
                orderSF.AccountId = accountId;
                orderSF.Status = 'Draft';
                orderSf.EffectiveDate = Date.today();
                orderSF.Supplier__r = new Account(Webcare_Id__c = wcSP.supplier);
                ordersToCreate.add(orderSF);

                //Add orderlines to the order
                for(WebCareStockPrice.Articles wcArticle : wcSP.articles) {
                    for(CartItem cartItem : cartItems) {
                        OrderItem orderItem = new OrderItem();
                        if(wcArticle.id +'-' +  wcSP.supplier == cartItem.Product2.Webcare_Id__c && wcSP.supplier == cartItem.Product2.Supplier__r.Webcare_Id__c) {
                            String webCareId = cartItem.Id + '-' + cartItem.Product2.Webcare_Id__c + '-' + wcSP.supplier;
                            cartItem.Status__c = 'Ordered';
                            cartItem.Has_Problems__c = false;
                            //cartItem.Order_Product__r = new OrderItem(Webcare_Id__c = webCareId);
                            updatedCartItems.add(cartItem);
                            cartItemsToDelete.add(cartItem);
                            orderItem.Product2Id = cartItem.Product2Id;
                            orderItem.Quantity = cartItem.Quantity;
                            orderItem.Order = new Order(Webcare_Id__c = wcSP.orderWebcare);
                            orderItem.UnitPrice = cartItem.SalesPrice;
                            orderItem.ListPrice = cartItem.SalesPrice;
                            orderItem.TotalLineAmount = cartItem.SalesPrice*cartItem.Quantity;
                            orderItem.Cart_Item__c = cartItem.Id;
                            orderItem.Webcare_Id__c = webCareId;
                            orderItem.ServiceDate = Date.valueOf(wcArticle.deliveryTime);
                            orderItem.Description = cartItem.Comment__c;
                            orderItemsToCreate.add(orderItem);
                        }
                    }
                }
            }

            //If we don't receive the orderSupplier & orderWebcare parameters, we need to update the cart items with the new prices
            //The results from the response are a bit dirty if I'm being honest, so we need to do some cleaning up and parsing
            else {
                System.debug('order validated in webcare');
                for(WebCareStockPrice.Articles wcArticle : wcSP.articles) {
                    for(CartItem cartItem : cartItems) {
                        Integer qty = Decimal.valueOf(wcArticle.quantity).intValue();
                        if(wcArticle.id +'-' +  wcSP.supplier == cartItem.Product2.Webcare_Id__c && wcSP.supplier == cartItem.Product2.Supplier__r.Webcare_Id__c) {
                            Decimal salesPrice = wcArticle.price == '' ? 0 : Decimal.valueOf(wcArticle.price);
                            cartItem.SalesPrice = salesPrice;
                            cartItem.NetUnitPrice = salesPrice;
                            cartItem.Status__c = 'Validated';
                            //We sometimes get delivery dates back with year 9999, which is not allowed in Salesforce
                            //So we need to check for this and set the delivery date to today + 5 years if it's the case
                            Date delDate = Date.valueOf(wcArticle.deliveryTime).year() > Date.today().year()+2 ? Date.today().addYears(5) : Date.valueOf(wcArticle.deliveryTime);
                            cartItem.Delivery_Date__c = delDate;
                            //Sometimes we get 0 as a quantity back, which is not an allowed value on CartItem
                            //We need to check for this and do something if that is the case
                            //For now, we just set the quantity to 1
                            if(qty != 0){
                                cartItem.Has_Problems__c = false;
                                cartItem.Quantity = qty;
                            } else {
                                cartItem.Has_Problems__c = true;
                                cartItem.Quantity = 1;
                            }
                            //Check whether the current quantity matches the quantity from the oldMap and set the quantity changed flag accordingly
                            if(oldMap.get(cartItem.Id).Quantity != cartItem.Quantity) {
                                cartItem.Quantity_Changed__c = true;
                            } else {
                                cartItem.Quantity_Changed__c = false;
                            }
                            system.debug('old Delivery Date=' + oldMap.get(cartItem.Id).Delivery_Date__c);
                            system.debug('new Delivery Date=' + cartItem.Delivery_Date__c);
                            //Check whether the current delivery date matches the delivery date from the oldMap and set the delivery date changed flag accordingly
                            if(oldMap.get(cartItem.Id).Delivery_Date__c != cartItem.Delivery_Date__c) {
                                cartItem.Delivery_Date_Changed__c = true;
                            } else {
                                cartItem.Delivery_Date_Changed__c = false;
                            }
                            //Check whether the current sales price matches the sales price from the oldMap and set the sales price changed flag accordingly
                            if(oldMap.get(cartItem.Id).SalesPrice != cartItem.SalesPrice) {
                                cartItem.Price_Changed__c = true;
                            } else {
                                cartItem.Price_Changed__c = false;
                            }
                            System.debug('cartItem: ' + cartItem);
                            cartItem.Updated_by_Price_Check__c = true;
                            if(!updatedCartItems.contains(cartItem)) {
                                updatedCartItems.add(cartItem);
                            }

                        }
                    }
                }
            }
        }



        insert ordersToCreate;
        insert orderItemsToCreate;
        update updatedCartItems;
        delete cartItemsToDelete;
        system.debug('updatedCartItems: ' + updatedCartItems);

        for(CartItem cartItem : updatedCartItems) {
            if(cartItem.Has_Problems__c == true && cartItem.Quantity == 1) {
                cartItem.Quantity = 0;
            }
            CartItem oldCartItem = oldMap.get(cartItem.Id);
            if(cartItem.Quantity != oldCartItem.Quantity || cartItem.SalesPrice != oldCartItem.SalesPrice) {
                cartItem.Updated_by_Price_Check__c = true;
                System.debug('cartItem changed by price check');
            }
        }

        for(Order order : ordersToCreate){
            order.Order_Final__c = true;
        }

        update ordersToCreate;

        return updatedCartItems;
    }

}