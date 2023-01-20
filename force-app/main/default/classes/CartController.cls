/**
 * Created by fpardon on 01/12/2022.
 */

public with sharing class CartController {

    @AuraEnabled
    public static CartItem addItemToCart(
            String productId,
            String quantity,
            string accountId,
            Double price,
            string deliveryDate,
            String networkId
    ) {

        system.debug('deliveryDate: ' + deliveryDate);
        system.debug('price: ' + price);
        system.debug('accountId: ' + accountId);
        system.debug('quantity: ' + quantity);
        system.debug('productId: ' + productId);

        String productName = [SELECT Webcare_Id__c FROM Product2 WHERE Id = :productId].Webcare_Id__c;
        String contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId ;

        ContactPointAddress contactPointAddress = [SELECT Id FROM ContactPointAddress WHERE ParentId = :accountId AND IsDefault = TRUE LIMIT 1];



        String cartId = getActiveCart(accountId);
        if(cartId == null){
            createCartSummary(networkId, accountId);
            cartId = getActiveCart(accountId);
            System.debug('cartId: ' + cartId);
        }


        String cartDeliveryGroupId = getCartDeliveryGroup(cartId);

        if(cartDeliveryGroupId == null){
            CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup();
            cartDeliveryGroup.CartId = cartId;
            cartDeliveryGroup.Name ='Delivery Group';
            insert cartDeliveryGroup;
            cartDeliveryGroupId = cartDeliveryGroup.Id;
        }

        //Check whether we find any existing cart item that matches the current Product2Id. If we find a match, we need to update the existing CartItem instead of creating a new one.
        CartItem cartItem;

        try{
            cartItem = [SELECT Id, Quantity, TotalLineAmount, TotalListPrice FROM CartItem WHERE Product2Id = :productId and CartId = :cartId];
        }catch(Exception e){
            system.debug('Exception: ' + e);
        }

        if(cartItem != null) {
            cartItem.Quantity = cartItem.Quantity + Integer.valueOf(quantity);
            cartItem.TotalLineAmount = cartItem.TotalLineAmount + (price * Integer.valueOf(quantity));
            cartItem.TotalListPrice = cartItem.TotalListPrice + (price * Integer.valueOf(quantity));
            update cartItem;
        } else {
            cartItem = new CartItem();
            cartItem.CartDeliveryGroupId = cartDeliveryGroupId;
            cartItem.Product2Id = productId;
            cartItem.Quantity = Integer.valueOf(quantity);
            cartItem.SalesPrice = price;
            cartItem.Name = productId;
            cartItem.CartId = cartId;
            cartItem.Delivery_Date__c = Date.valueOf(deliveryDate);
            cartItem.TotalLineAmount = price * Integer.valueOf(quantity);
            cartItem.TotalListPrice = price * Integer.valueOf(quantity);
            cartItem.GrossUnitPrice = price;
            cartItem.Type = 'Product';
            cartItem.Sku = productName;
            cartItem.Address__c = contactPointAddress.Id;
            insert cartItem;
        }
        return cartItem;
    }

    public static String resolveCommunityIdToWebstoreId(String communityId) {

        String webStoreId = [
                SELECT WebStoreId
                FROM WebStoreNetwork
                WHERE NetworkId = :communityId
                WITH SECURITY_ENFORCED
                LIMIT 1
        ]
                .WebStoreId;
        return webStoreId;
    }

    @AuraEnabled
    public static String getEffectiveAccount(){
        String accountId = [SELECT AccountId FROM Contact WHERE Id in (Select ContactId FROM User WHERE Id = :UserInfo.getUserId()) LIMIT 1].AccountId;
        return accountId;
    }

    public static String getActiveCart(String accountId) {
        try {
            String cartId = [SELECT Id, AccountId FROM WebCart WHERE AccountId =:accountId  AND Status = 'Active' AND IsSecondary = FALSE AND CreatedById = :UserInfo.getUserId() LIMIT 1].Id;
            return cartId;
        } catch (Exception e) {
            return null;
        }
    }

    public static String getCartDeliveryGroup(String cartId) {
        try {
            String cartDeliveryGroupId = [SELECT Id FROM CartDeliveryGroup WHERE CartId =:cartId LIMIT 1].Id;
            return cartDeliveryGroupId;
        } catch (Exception e) {
            return null;
        }
    }

    public static String createCart(String accountId, String communityId) {



        WebCart webCart = new WebCart();
        webCart.Name = 'Cart';
        webCart.AccountId = accountId;
        webCart.Status = 'Active';
        webCart.IsSecondary = false;
        webCart.WebStoreId = resolveCommunityIdToWebstoreId(communityId);
        insert webCart;

        return webCart.Id;
    }

    public static ConnectApi.CartSummary createCartSummary(
            String communityId,
            String effectiveAccountId
    ) {

        // Lookup the webstore ID associated with the community
        String webstoreId = resolveCommunityIdToWebstoreId(communityId);
        ConnectApi.CartInput cartInput = new ConnectApi.CartInput();
        cartInput.effectiveAccountId = effectiveAccountId;
        return ConnectApi.CommerceCart.createCart(webstoreId, cartInput);
    }

}