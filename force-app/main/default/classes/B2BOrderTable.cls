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
 * Created: 14/12/2022
 * Last Updated: 14/12/2022
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

public with sharing class B2BOrderTable {


    @AuraEnabled
    public static void setToken(){
        Map<String, String> tokens = WebCareRest.getToken();
        WebCareRest.saveToken(tokens.get('accessToken'), tokens.get('refreshToken'));
    }

    @AuraEnabled
    public static List<OrderItem> getOrderItems(String effectiveAccountId){
        System.debug('getOrderItems');
        List<OrderItem> orderItems = [SELECT  Id,
                                        Order.Id,
                                        Order.Account.Name,
                                        Order.OrderNumber,
                                        Order.Supplier__r.Name,
                                        Order.TotalAmount,
                                        Order.EffectiveDate,
                                        Order.Status,
                                        Order.Invoice__c,
                                        Order.Webcare_Id__c,
                                        Order.Supplier_Order_Nbr__c,
                                        Order.CreatedDate,
                                        Quantity,
                                        Product2.Parent__r.Brand__r.Description_FR__c,
                                        Product2.Parent__r.Description_FR__c,
                                        UnitPrice,
                                        ServiceDate,
                                        TotalPrice,
                                        Description,
                                        Product_Description__c,
                                        Brand_Ext__c,
                                        Supplier_Ext__c
                                        FROM OrderItem
                                        WHERE Order.AccountId = :effectiveAccountId
                                        AND CreatedDate >= LAST_N_DAYS:90
                                        ORDER BY CreatedDate  DESC, Order.OrderNumber DESC
                                        LIMIT 50];

        Map<String, String> invoiceMap = new Map<String, String>();
        Map<String, String> orderMap = new Map<String, String>();

        Map<String, String> ordersToCheck = new Map<String, String>();
        for(OrderItem oi : orderItems){
            if(oi.Order.Supplier_Order_Nbr__c != null){
                ordersToCheck.put(oi.Order.Id, oi.Order.Supplier_Order_Nbr__c);
            }
        }

        System.debug('ordersToCheck: ' + ordersToCheck.size());

        for(String orderNbr : ordersToCheck.keySet()){
            invoiceMap.put(orderNbr, getInvoiceUrl(ordersToCheck.get(orderNbr)));
            orderMap.put(orderNbr, getOrderUrl(ordersToCheck.get(orderNbr)));
        }

        for(OrderItem oi : orderItems){
            if(invoiceMap.containsKey(oi.Order.OrderNumber)){
                oi.Order.Invoice__c = invoiceMap.get(oi.Order.Id);
            }
            if(orderMap.containsKey(oi.Order.OrderNumber)){
                oi.Order.Webcare_Id__c = orderMap.get(oi.Order.Id);
            }
        }

        return orderItems;

    }


    @AuraEnabled
    public static List<Order> getOrders(String effectiveAccountId){

        system.debug('getOrders: ' + effectiveAccountId);

        List<Order> orders = [SELECT Id,
                                    OrderNumber,
                                    Account.Name,
                                    Supplier__r.Name,
                                    TotalAmount,
                                    EffectiveDate,
                                    Status,
                                    Invoice__c,
                                    Webcare_Id__c,
                                    Supplier_Order_Nbr__c
                                    FROM Order
                                    WHERE AccountId = :effectiveAccountId
                                    ORDER By CreatedDate DESC];
        System.debug('orders: ' + orders);

        for(Order order : orders){
            if(order.Supplier_Order_Nbr__c != null){
                order.Invoice__c = getInvoiceUrl(order.Supplier_Order_Nbr__c);
                order.Order_PDF__c = getOrderUrl(order.Supplier_Order_Nbr__c);
            }
        }

        return orders;
    }


    @AuraEnabled
    public static List<OrderItem> getOrderLines(String orderId){

        system.debug('getOrders: ' + orderId);

        List<OrderItem> ordersItems = [SELECT Id, Product2.Name, Product2.Parent__r.EAN_Code__c, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :OrderId];
        System.debug('orders: ' + ordersItems);
        return ordersItems;

    }

    @AuraEnabled
    public static List<OrderItem> getOrderLinesToExport(String ordernumbers){

        Set<String> splitOrdernumbers = New Set<String>();
        splitOrdernumbers.addAll(ordernumbers.split(';'));

        List<OrderItem> ordersItems = [SELECT Order.EffectiveDate, 
                                        Order.Supplier_Order_Nbr__c,
                                        Quantity, 
                                        Product2.Parent__r.Brand__r.Description_FR__c, 
                                        Product2.Parent__r.Description_FR__c, 
                                        UnitPrice,
                                        TotalPrice, 
                                        Description, 
                                        Order.Supplier__r.Name 
                                        FROM OrderItem 
                                        WHERE Id IN :splitOrdernumbers];
        return ordersItems;

    }

    @AuraEnabled
    public static String reOrderCart(String orderId) {
        system.debug('reOrderCart: ' + orderId);

        List<OrderItem> orderItems = [
                SELECT Id,
                        Order.AccountId,
                        Product2Id,
                        Product2.Delivery_Date_1__c,
                        Product2.Delivery_Date_2__c,
                        Product2.Delivery_Date_3__c,
                        Product2.Available_Quantity_1__c,
                        Product2.Available_Quantity_2__c,
                        Product2.Available_Quantity_3__c,
                        Quantity,
                        UnitPrice
                FROM OrderItem
                WHERE OrderId = :orderId
        ];

        String addCartItemsResult = createCartItems(orderItems);
        return addCartItemsResult;
    }

    @AuraEnabled
    public static String reOrderCartItem(String orderItemId) {
        system.debug('reOrderCart: ' + orderItemId);

        List<OrderItem> orderItems = [
                SELECT Id,
                        Order.AccountId,
                        Product2Id,
                        Product2.Delivery_Date_1__c,
                        Product2.Delivery_Date_2__c,
                        Product2.Delivery_Date_3__c,
                        Product2.Available_Quantity_1__c,
                        Product2.Available_Quantity_2__c,
                        Product2.Available_Quantity_3__c,
                        Quantity,
                        UnitPrice
                FROM OrderItem
                WHERE Id = :orderItemId
        ];

        String addCartItemsResult = createCartItems(orderItems);
        return addCartItemsResult;
    }


    public static String createCartItems(List<OrderItem> orderItems) {
        List<CartItem> cartItems = new List<CartItem>();
        for(OrderItem orderItem : orderItems){
            String productId = orderItem.Product2Id;
            Decimal quantity = orderItem.Quantity;
            String accountId = orderItem.Order.AccountId;
            Double price = orderItem.UnitPrice;
            string deliveryDate;
            //Check the product available quantities
            if(Decimal.valueOf(orderItem.Product2.Available_Quantity_1__c) >= quantity){
                deliveryDate = String.valueOf(orderItem.Product2.Delivery_Date_1__c);
            } else if(Decimal.valueOf(orderItem.Product2.Available_Quantity_2__c) >= quantity){
                deliveryDate = String.valueOf(orderItem.Product2.Delivery_Date_2__c);
            } else if(Decimal.valueOf(orderItem.Product2.Available_Quantity_3__c) >= quantity){
                deliveryDate = String.valueOf(orderItem.Product2.Delivery_Date_3__c);
            } else {
                system.debug('Product not available');
            }
            CartItem ci = CartController.addItemToCart(productId, String.valueOf(quantity), accountId, price, deliveryDate, null);
            cartItems.add(ci);
        }

        if(cartItems.size() == orderItems.size()){
            return 'success';
        } else {
            return 'error';
        }

    }

    public static String getInvoiceUrl(String orderId){

        HttpResponse resp = WebCareRest.doCallOut('/portal/invoicepdf/'+orderId, 'GET');

        Map<String, Object> m =   (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        String invoiceUrl = (String) m.get('pdf');
        system.debug('invoiceUrl: ' + invoiceUrl);
        return invoiceUrl;


    }

    public static String getOrderUrl(String orderId){

        HttpResponse resp = WebCareRest.doCallOut('/portal/orderpdf/'+orderId, 'GET');

        Map<String, Object> m =   (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        String invoiceUrl = (String) m.get('pdf');
        system.debug('orderUrl: ' + invoiceUrl);
        return invoiceUrl;
    }


}