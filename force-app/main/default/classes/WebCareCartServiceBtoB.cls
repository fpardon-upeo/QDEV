public without sharing class WebCareCartServiceBtoB {

    @AuraEnabled
    public static void updateCartItemDeliveryAddresses(String supplierCode, String cartId, String deliveryAddressId) {

        List<CartItem> cartItems = [SELECT Id FROM CartItem WHERE CartId = :cartId and Product2.Supplier__r.Webcare_Id__c = :supplierCode];
        for (CartItem cartItem : cartItems) {
            cartItem.Address__c = deliveryAddressId;
        }
        update cartItems;
    }

    @AuraEnabled
    public static CartItem updateCartItem(CartItem cartItem) {
        update cartItem;
        return cartItem;
    }

    @AuraEnabled
    public static String deleteCartItem(String cartItemId) {
        CartItem cartItem = [SELECT Id FROM CartItem WHERE Id = :cartItemId];
        delete cartItem;
        return cartItemId;
    }

    @AuraEnabled
    public static Decimal getWebCareTotalItems(String recordId) {
        WebCart cart = [SELECT TotalProductCount FROM WebCart WHERE id =:recordId LIMIT 1];
        return cart.TotalProductCount;
    }

    @AuraEnabled
    public static String getWebCareCartItems(String recordId) {
        String webCareCart = transformCart(recordId);
        return webCareCart;
    }

    public static String transformCart(String cartId) {

        String jsonBody = '';

        WebCart cart = [SELECT id, AccountId FROM WebCart WHERE id =:cartId LIMIT 1];

        List<CartItem> cartItems= [SELECT
                CartId,
                Cart.AccountId,
                Product2.Webcare_Id__c,
                Product2.RecordType.Name,
                Product2.ProductCode,
                Product2.Parent__r.Brand_Profile_Text__c,
                Product2.Parent__r.Brand_Ext__c,
                Product2.Parent__r.Dimension_Indexed__c,
                Product2.Parent__r.EAN_Code__c,
                Product2.Parent__r.Description_NL__c,
                Product2.Parent__r.Ecotax__c,
                Product2.Parent__r.Recytyre_Category__c,
                Product2.Parent__r.VAT__c,
                Product2.Name,
                Product2.Supplier__r.Webcare_Id__c,
                Product2.Supplier__r.Logo_Ext__c,
                Product2.Supplier__r.Name,
                Product2.Supplier__r.Type,
                Product2.Available_Quantity_1__c, 
                Product2.Available_Quantity_2__c, 
                Product2.Available_Quantity_3__c, 
                Product2.Delivery_Date_1__c, 
                Product2.Delivery_Date_2__c, 
                Product2.Delivery_Date_3__c,
                Quantity, Delivery_Cost__c,
                Comment__c,
                Label_Cost__c,
                Delivery_Date__c,
                TotalListPrice,
                ListPrice,
                SalesPrice,
                GrossUnitPrice,
                TotalLineGrossAmount,
                TotalLineNetAmount,
                TotalLineTaxAmount,
                Address__c,
                Address__r.Street,
                Address__r.City,
                Address__r.PostalCode,
                Address__r.Country,
                Has_Problems__c,
                Updated_by_Price_Check__c,
                Price_Changed__c,
                Quantity_Changed__c,
                Delivery_Date_Changed__c
        FROM CartItem
        WHERE CartId = :cart.Id AND Status__c != 'Ordered'
        ORDER BY Product2.Supplier__r.Webcare_Id__c ASC];

        Account buyerAccount = [SELECT Id, Webcare_Id__c, Available_Credit__c, Credit_Limit__c FROM Account WHERE Id = :cart.AccountId];
        User curUser = [SELECT Id, Type_of_User__c FROM User WHERE Id = :UserInfo.getUserId()];
        String userType = curUser.Type_of_User__c;
        String typeOfUser;
        if(userType.startsWith('p')){
            typeOfUser = 'Partner';
        } else {
            typeOfUser = 'Distri';
        }

        
        List<String> supplierCodes = new List<String>();
        Set<Id> supplierIds = new Set<Id>();
        //Add the supplier codes to a list so we can use this to loop through it later
        for(CartItem cartItem : cartItems) {
            if(!supplierCodes.contains(cartItem.Product2.Supplier__r.Webcare_Id__c)) {
                supplierCodes.add(cartItem.Product2.Supplier__r.Webcare_Id__c);
                supplierIds.add(cartItem.Product2.Supplier__c);
            }
        }

        Map<String, List<Transport_Cost__c>> mapTransportCosts = new Map<String, List<Transport_Cost__c>>();

        if(typeOfUser == 'Partner'){
            for(Transport_Cost__c transportCost : [SELECT Account__c, Type__c, Amount__c, Price__c, Price_Partner__c FROM Transport_Cost__c WHERE Account__c IN: supplierIds]){
                transportCost.Price__c = transportCost.Price_Partner__c;
                if(mapTransportCosts.containsKey(transportCost.Account__c)) {
                    mapTransportCosts.get(transportCost.Account__c).add(transportCost);
                } else {
                    mapTransportCosts.put(transportCost.Account__c, new List<Transport_Cost__c> { transportCost });
                }
            }
        } else {
            for(Transport_Cost__c transportCost : [SELECT Account__c, Type__c, Amount__c, Price__c, Price_Distri__c FROM Transport_Cost__c WHERE Account__c IN: supplierIds]){
                transportCost.Price__c = transportCost.Price_Distri__c;
                if(mapTransportCosts.containsKey(transportCost.Account__c)) {
                    mapTransportCosts.get(transportCost.Account__c).add(transportCost);
                } else {
                    mapTransportCosts.put(transportCost.Account__c, new List<Transport_Cost__c> { transportCost });
                }
            }
        }

        Webcare_Delivery_VAT__mdt deliveryVAT = [SELECT VAT__c FROM Webcare_Delivery_VAT__mdt LIMIT 1];

        Decimal globalProductCost = 0;
        Decimal globalTransportCost = 0;
        Decimal globalLabelCost = 0;
        Decimal globalCostExVat = 0;
        Decimal globalTaxes = 0;
        Decimal globalCostIncVat = 0;

        WebCareCartBtoB wcCart = new WebCareCartBtoB();
        wcCart.customer = buyerAccount.Webcare_Id__c;
        wcCart.creditLimit = buyerAccount.Credit_Limit__c;  
        wcCart.availableCredit = buyerAccount.Available_Credit__c;      
        wcCart.basket = cart.Id;
        List<WebCareCartBtoB.Orders> orders = new List<WebCareCartBtoB.Orders>();
        //Loop through the supplier codes
        for(String supplierCode : supplierCodes) {
            WebCareCartBtoB.Orders wcOrder = new WebCareCartBtoB.Orders();
            Decimal totalQuantity = 0;
            Decimal totalProductCost = 0;
            Decimal totalProductCost_Vat = 0;
            Decimal totalTransportCost = 0;
            Decimal totalTransportCost_Vat = 0;
            Decimal totalLabelCost = 0;
            Decimal totalLabelCost_Vat = 0;
            Decimal totalCostExVat = 0;
            Decimal taxes = 0;
            Decimal totalCostIncVat = 0;
            //Loop through the cart items
            List<WebCareCartBtoB.Articles> articles = new List<WebCareCartBtoB.Articles>();
            for(CartItem cartItem : cartItems) {
                //If the supplier code matches the supplier code of the cart item
                if(supplierCode == cartItem.Product2.Supplier__r.Webcare_Id__c) {
                    //Add the cart item to the json body
                    wcOrder.supplierCode = supplierCode;
                    wcOrder.supplierLogo = cartItem.Product2.Supplier__r.Logo_Ext__c;
                    wcOrder.supplierName = cartItem.Product2.Supplier__r.Name;
                    wcOrder.supplierType = cartItem.Product2.Supplier__r.Type;
                    wcOrder.deliveryAddress = cartItem.Address__r.Street + ' ' + cartItem.Address__r.City + ', ' + cartItem.Address__r.PostalCode + ' ' + cartItem.Address__r.Country;
                    Boolean supplierShowAllAdresses = false;
                    if(cartItem.Product2.Supplier__r.Type == 'Alternative'){
                        supplierShowAllAdresses = true;
                    }
                    wcOrder.supplierShowAllAdresses = supplierShowAllAdresses;
                    wcOrder.totalProductCost = totalProductCost += cartItem.Quantity * cartItem.SalesPrice;
                    if(cartItem.Product2.Parent__r.VAT__c != null){
                        totalProductCost_Vat += (cartItem.Product2.Parent__r.VAT__c / 100) * cartItem.Quantity * cartItem.SalesPrice;
                    }
                    totalQuantity += cartItem.Quantity;
                    if(mapTransportCosts.get(cartItem.Product2.Supplier__c) != null){
                        for(Transport_Cost__c transpCost : mapTransportCosts.get(cartItem.Product2.Supplier__c)){
                            if((transpCost.Type__c == cartItem.Product2.RecordType.Name) && (totalQuantity >= transpCost.Amount__c)){
                                system.debug('if statement is true on 165');
                                totalTransportCost = transpCost.Price__c != null ? Decimal.valueOf(transpCost.Price__c) : 0;
                                system.debug('totalTransportCost = ' + totalTransportCost);
                            }
                        }
                    }
                    wcOrder.totalLabelCost = totalLabelCost += cartItem.Product2.Parent__r.Ecotax__c != null ? cartItem.Quantity * cartItem.Product2.Parent__r.Ecotax__c : 0;
                    if(cartItem.Product2.Parent__r.VAT__c != null){
                        totalLabelCost_Vat += cartItem.Product2.Parent__r.Ecotax__c != null ? (cartItem.Product2.Parent__r.VAT__c / 100) * cartItem.Quantity * cartItem.Product2.Parent__r.Ecotax__c : 0;
                    }
                    WebCareCartBtoB.Articles wcArticle = new WebCareCartBtoB.Articles();
                    wcArticle.cartItemId = cartItem.Id;
                    wcArticle.articleId = cartItem.Product2.ProductCode;
                    wcArticle.profileText = cartItem.Product2.Parent__r.Brand_Profile_Text__c;
                    wcArticle.profileBrand = cartItem.Product2.Parent__r.Brand_Ext__c;
                    wcArticle.articleDescription = cartItem.Product2.Parent__r.Description_NL__c;
                    wcArticle.comment = cartItem.Comment__c;
                    system.debug('cartItem.Quantity = ' + cartItem.Quantity);
                    if(cartItem.Quantity == 1 && cartItem.Has_Problems__c == true){
                        wcArticle.quantity = 0;
                        wcArticle.hasErrors = true;
                    } else {
                        wcArticle.quantity = cartItem.Quantity;
                    }

                    wcArticle.maxQuantity = 0;
                    String invalidNumbers = '[^0-9]'; 
                    if(cartItem.Product2.Supplier__r.Type == 'Alternative'){
                        if(cartItem.Product2.Delivery_Date_1__c != null && cartItem.Product2.Available_Quantity_1__c != null && cartItem.Product2.Delivery_Date_1__c >= cartItem.Delivery_Date__c){
                            wcArticle.maxQuantity = Decimal.valueOf((cartItem.Product2.Available_Quantity_1__c).replaceAll(invalidNumbers, ''));
                        }
                        if(cartItem.Product2.Delivery_Date_2__c != null && cartItem.Product2.Available_Quantity_2__c != null && cartItem.Product2.Delivery_Date_2__c >= cartItem.Delivery_Date__c){
                            wcArticle.maxQuantity = Decimal.valueOf((cartItem.Product2.Available_Quantity_2__c).replaceAll(invalidNumbers, ''));
                        }
                        if(cartItem.Product2.Delivery_Date_3__c != null && cartItem.Product2.Available_Quantity_3__c != null && cartItem.Product2.Delivery_Date_3__c >= cartItem.Delivery_Date__c){
                            wcArticle.maxQuantity = Decimal.valueOf((cartItem.Product2.Available_Quantity_3__c).replaceAll(invalidNumbers, ''));
                        }
                    } else{
                        if(cartItem.Product2.Available_Quantity_1__c != null){
                            wcArticle.maxQuantity = Decimal.valueOf((cartItem.Product2.Available_Quantity_1__c).replaceAll(invalidNumbers, ''));
                        }
                    }

                    wcArticle.price = cartItem.SalesPrice;
                    wcArticle.totalLinePrice = cartItem.Quantity * cartItem.SalesPrice;
                    wcArticle.deliveryTime = String.valueOf(cartItem.Delivery_Date__c);
                    wcArticle.recytyre = 0;
                    wcArticle.hasErrors = cartItem.Has_Problems__c;
                    wcArticle.totalRecytyre = 0;
                    wcArticle.showRecytyre = false;
                    wcArticle.changed = cartItem.Updated_by_Price_Check__c;
                    wcArticle.priceChanged = cartItem.Price_Changed__c;
                    wcARticle.quantityChanged = cartItem.Quantity_Changed__c;
                    wcArticle.deliveryDateChanged = cartItem.Delivery_Date_Changed__c;
                    if(cartItem.Product2.Parent__r.Ecotax__c != null){
                        wcArticle.showRecytyre = true;
                        wcArticle.recytyre = cartItem.Product2.Parent__r.Ecotax__c;
                        wcArticle.totalRecytyre = cartItem.Quantity * cartItem.Product2.Parent__r.Ecotax__c;
                    }
                    wcArticle.recytyreCategory = cartItem.Product2.Parent__r.Recytyre_Category__c;
                    articles.add(wcArticle);
                }
            }
            system.debug('transportCosts: ' + totalTransportCost);
            wcOrder.totalQuantity = totalQuantity;
            wcOrder.totalTransportCost = totalTransportCost;
            wcOrder.showTransportCost = false;
            if(totalTransportCost > 0){
                wcOrder.showTransportCost = true; 
            }
            totalTransportCost_Vat = (deliveryVAT.VAT__c/100) * totalTransportCost;

            wcOrder.totalCostExVat = totalCostExVat += totalProductCost + totalTransportCost + totalLabelCost;
            wcOrder.taxes = taxes += totalProductCost_Vat + totalTransportCost_Vat + totalLabelCost_Vat;
            wcOrder.totalCostIncVat = totalCostIncVat += totalCostExVat + taxes;

            wcCart.globalProductCost = globalProductCost += totalProductCost;
            wcCart.globalTransportCost = globalTransportCost += totalTransportCost;
            wcCart.globalLabelCost = globalLabelCost += totalLabelCost;
            wcCart.globalCostExVat = globalCostExVat += totalCostExVat;
            wcCart.globalTaxes = globalTaxes += taxes;
            wcCart.globalCostIncVat = globalCostIncVat += totalCostIncVat;

            wcOrder.articles = articles;
            orders.add(wcOrder);
        }
        wcCart.orders = orders;

        jsonBody = JSON.serialize(wcCart);
        return jsonBody;


    }

    @AuraEnabled
    public static List<ContactPointAddress> getContactPointAddresses(String recordId) {

        WebCart cart = [SELECT AccountId FROM WebCart WHERE id =:recordId LIMIT 1];
        List<ContactPointAddress> contactPointAddress= [SELECT Name, IsDefault, Street, City, PostalCode, Country
        FROM ContactPointAddress
        WHERE ParentId = :cart.AccountId];
        return contactPointAddress;
    }

}