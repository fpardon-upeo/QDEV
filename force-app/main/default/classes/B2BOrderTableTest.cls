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
 * Created: 29/12/2022
 * Last Updated: 29/12/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
@IsTest
private class B2BOrderTableTest {


    @IsTest
    static void testBehavior() {


        Address_Attributes__c addressAttributes = new Address_Attributes__c(
                Postal_Code__c = '1000'
        );

        insert addressAttributes;

        Account testAccount = new Account(Name = 'Test Account B2BOrderTAbleTest');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'Test Contact B2BOrderTAbleTest', AccountId = testAccount.Id);
        insert testContact;

        WebStore testWebStore = new WebStore(Name='TestWebStore', DefaultLanguage='en_US');
        insert testWebStore;

        BuyerAccount buyerAccount = new BuyerAccount();
        buyerAccount.BuyerId = testAccount.Id;
        buyerAccount.Name = 'Test Account';
        buyerAccount.IsActive = true;
        buyerAccount.BuyerStatus = 'Active';
        insert buyerAccount;
        system.debug('after insert buyer account');

        WebCart cart = new WebCart();
        cart.AccountId = testAccount.Id;
        cart.Name = 'Test Cart';
        cart.Status = 'Active';
        cart.WebStoreId = testWebStore.Id;
        insert cart;
        system.debug('after insert cart');

        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup();
        cartDeliveryGroup.CartId = cart.Id;
        cartDeliveryGroup.Name = 'Test Delivery Group';
        insert cartDeliveryGroup;
        String cartDeliveryGroupId = cartDeliveryGroup.Id;

        // Create a test product
        Product2 testProduct = new Product2(Name = 'Test Product', ProductCode = 'TestProduct', IsActive = true, Delivery_Date_1__c = Date.today(),Available_Quantity_1__c = '100', Delivery_Date_2__c = Date.today()+1, Available_Quantity_2__c = '200', Delivery_Date_3__c = Date.today()+2,  Available_Quantity_3__c = '300');
        insert testProduct;

        ContactPointAddress testContactPointAddress = new ContactPointAddress(
                Name = 'Test Contact Point Address',
                Street = 'Test Street',
                City = 'Test City',
                PostalCode = '1000',
                Country = 'Belgium',
                ParentId = testAccount.Id,
                IsDefault = true
        );
        insert testContactPointAddress;

        // Create a test order
        Order testOrder = new Order(AccountId = testAccount.Id, Status = 'Draft', EffectiveDate = Date.today());
        insert testOrder;

        // Create a test order item
        OrderItem testOrderItem1 = new OrderItem(OrderId = testOrder.Id, Product2Id = testProduct.Id, Quantity = 8, UnitPrice = 100, ListPrice = 100);
        OrderItem testOrderItem2 = new OrderItem(OrderId = testOrder.Id, Product2Id = testProduct.Id, Quantity = 101, UnitPrice = 100, ListPrice = 100);
        OrderItem testOrderItem3 = new OrderItem(OrderId = testOrder.Id, Product2Id = testProduct.Id, Quantity = 201, UnitPrice = 100, ListPrice = 100);

        insert testOrderItem1;
        insert testOrderItem2;
        insert testOrderItem3;

        String AccountId = [SELECT Id FROM Account WHERE Name = 'Test Account B2BOrderTAbleTest' LIMIT 1].Id;

        List<Order> orderList = B2BOrderTable.getOrders(accountId);
        System.assertEquals(1, orderList.size());

        Order baseOrder = [Select Id, OrderNumber from Order WHERE Id = :orderList[0].Id];
        String orderNumber = baseOrder.OrderNumber;
        String orderId = baseOrder.Id;

        List<OrderItem> orderItemList = B2BOrderTable.getOrderLines(orderList[0].Id);
        System.assertEquals(3, orderItemList.size());

        List<OrderItem> orderLinesToExport = B2BOrderTable.getOrderLinesToExport(orderNumber);

        //System.assertEquals(3, orderLinesToExport.size());

        String cartReorderResult = B2BOrderTable.reOrderCart(orderId);
        System.assertEquals('success', cartReorderResult);

        String cartItemReorderResult = B2BOrderTable.reOrderCartItem(orderItemList[0].Id);
        System.assertEquals('success', cartItemReorderResult);


    }
}