/**
 * Created by fpardon on 30/11/2022.
 */

public with sharing class ProductSearchController {

    @AuraEnabled(cacheable=true)
    /**
    *
    * @param Dim1 = Width --> Product2.Dim1__c
    * @param Dim2 = Width (other) --> Product2.Dim2__c
    * @param Dim3 = Inches --> Product2.Dim3__c
    * @param capacity = Load Capacity --> Product2.Drvm__c
    * @param speed = Max Allowed Speed --> Product2.Speed__c
    * @param searchTerm = Free text search --> Product2.Search_Field__c = concatenation of all searchable fields
    * @param brand = Brand --> Product2.Brand__c
    * @param season = Season --> Product2.Season__c
    * @param fuel = Fuel Consumption --> Product2.BEclass__c
    * @param grip = Grip --> Product2.Grip__c
    * @param noise = Noise --> Product2.Reclass__c
    * @param specification = Specification --> Product2.Specification__c
    * @param homologation = Car brand for which the tyre is made --> Product2.Homologation__c
    * @param runflat = Runflat --> Product2.Rof__c
    * @param pmsf = PMSF --> Product2.X3PMSF__c
    * @param seal = Seal --> Product2.Seal__c
    * @param sound = Sound --> Product2.Relabel__c
    * @param elt = tyre for Electric Vehicles --> Product2.Elt__c
    * @param offset = OFFSET parameter for the query, used in the pagination of the results
    *
    * @return String results --> JSON string with the results
    *
    * @description This method is used to search for products in the database based on the parameters entered
    * in the search component on the storefront. The search is done on the Product2 object and Pricebook Entry object.
    *
    */

    public static String search(
            String recordType,
            String Dim1,
            String Serie,
            String Dim3,
            String capacity,
            String speed,
            string searchTerm,
            String brand,
            String season,
            String use,
            String axis,
            String fuel,
            String grip,
            String noise,
            String type,
            String motoSeason,
            String position,
            String usage,
            String rubber,
            String category,
            String specification,
            String homologation,
            Boolean runflat,
            Boolean pmsf,
            Boolean seal,
            Boolean sound,
            Boolean elt,
            integer offset) {

        //----------------------------------------------INIT---------------------------------------------------------//

        //Get the user and the user type
        //we need to know the type of user to get the correct pricebook later on
        User curUser = [SELECT Id, Type_of_User__c FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('curUser: ' + curUser);
        String userType = curUser.Type_of_User__c;

        //Get the ranking order for the search results, this will determine the order of the results
        String rankingOrder;
        if (userType == 'p1' || userType == 'p2' || userType == 'p3' || userType == 'ps1' || userType == 'ps2' || userType == 'ps3') {
            rankingOrder = 'Ranking__c';
            system.debug('ranking');
        }else if (userType == 'd1' || userType == 'd2' || userType == 'd3') {
            rankingOrder = 'Ranking_Dist__c';
            system.debug('rankingDist');
        }

        //For testing purposes only, to be cleaned up when we release
        system.debug('userType: ' + userType);
        System.debug('Dim1: ' + Dim1);
        System.debug('Serie: ' + Serie);
        System.debug('Dim3: ' + Dim3);
        System.debug('capacity: ' + capacity);
        System.debug('speed: ' + speed);
        System.debug('searchTerm: ' + searchTerm);
        System.debug('brand: ' + brand);
        System.debug('Season: ' + Season);
        System.debug('fuel: ' + fuel);
        System.debug('Grip: ' + Grip);
        System.debug('Noise: ' + Noise);
        System.debug('Category: ' + Category);
        System.debug('Specification: ' + specification);
        System.debug('Runflat: ' + Runflat);
        System.debug('3PMSF: ' + PMSF);
        System.debug('Seal: ' + Seal);
        System.debug('Sound: ' + Sound);
        System.debug('Elt: ' + Elt);
        System.debug('offset: ' + offset);

        //Set the limit of the query
        Integer limitResult = 25;

        //Get the blocked suppliers for the current user, these need to be filtered out of the results
        List<String> blockedSuppliers = new List<String>();
        List<Supplier_Access__c> supplierAccess = [SELECT Supplier__c FROM Supplier_Access__c WHERE Status__c = 'Blocked' AND Contact__c IN (Select ContactId from User where Id = :UserInfo.getUserId())];
        for(Supplier_Access__c s : supplierAccess) {
            blockedSuppliers.add(s.Supplier__c);
        }
        System.debug('blockedSuppliers: ' + blockedSuppliers);

        //We receive the brands as a string, we need to convert it to a list
        List<String> brandList = new List<String>();

        if(brand != null){
            if(brand.length() > 0){

                if(brand.contains(',')){
                    List<String> tempBrandList = brand.split(',');
                    system.debug('brand: ' + brand);
                    for(String b : tempBrandList) {
                        b = b.trim();
                        brandList.add(b);
                        system.debug('b: ' + b);
                    }
                } else {
                    brandList.add(brand.trim());
                }

                system.debug('brand: ' + brand);
                system.debug('brandList: ' + brandList);
            }
        }
        if (homologation != null) {
            List<String> homologationValues2 = ProductSearchController.getHomologationValues(homologation);
        }


        //----------------------------------------------QUERY---------------------------------------------------------//
        //Construct the first query
        //This query will return the products that match the search criteria

        String baseQuery = 'SELECT Id, Brand__r.Ranking__c, Supplier__r.Name, Supplier__r.Logo_Ext__c, Label__c,Ranking__c, Dimension_Indexed__c, Profile__c,'
                +'Brand_Profile_Text__c, Brand__r.Description_NL__c, Image_Profile__c, Delivery_Date_1__c, Delivery_Date_2__c,Delivery_Date_3__c,Description_FR__c,QR_Eprel__c,'+
                +'Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c,Season_Ext__c,Brand_Ext__c,Drvm__c,Speed__c,BEclass__c,REvalue__c,List_Price__c,Grip__c,toLabel(Brand__r.level__c) '+
                'FROM Product2 ';
        //Add the where clause
        String whereClause = getWhereClause(recordType,Dim1, Serie, Dim3, capacity, speed, searchTerm, brand, Season, use, axis, fuel, Grip, Noise,type,motoSeason,position,usage, rubber, Category, specification, homologation, runflat, pmsf, seal, sound, elt, true, offset,rankingOrder, blockedSuppliers);
        String query = baseQuery + whereClause;

        //Add a second where clause, this will be used to get the total number of results in a separate query
        String whereClauseQSize = getWhereClause(recordType,Dim1, Serie, Dim3, capacity, speed, searchTerm, brand, Season, use, axis, fuel, Grip, Noise,type,motoSeason,position,usage,rubber, Category, specification, homologation, runflat, pmsf, seal, sound, elt, false, offset,rankingOrder, blockedSuppliers);

        //Query the parent products that match the search criteria
        String fullQueryString = 'SELECT Id FROM Product2 ' + whereClauseQSize;
        system.debug('fullQueryString: ' + fullQueryString);
        List<Product2> fullList = Database.query(fullQueryString);

        //Use the output of the fullQueryString add all products to the allParentIds list
        List<String> allParentIds = new List<String>();
        for(Product2 p : fullList) {
            allParentIds.add(p.Id);
        }

        System.debug('allParentIds: ' + allParentIds.size());

        //We use the allParentIds list to query all PriceBook Entries that match the search criteria
        //Based on that, we know how many pages we will need for the pagination component
        String returnSizeQueryString = 'SELECT count() FROM PriceBookEntry WHERE Product2.Parent__c IN :allParentIds AND product2.parent__r.RecordType.Name =: recordType AND Product2.Supplier__c NOT IN :blockedSuppliers AND Pricebook2.Type__c = :userType AND Product2.ProductClass = \'Variation\' AND Product2.Available_Quantity_1__c != \'0\' AND Product2.Available_Quantity_2__c != \'0\' AND Product2.Available_Quantity_3__c != \'0\'';
        Integer returnSize = Database.countQuery(returnSizeQueryString);
        system.debug('returnSize: ' + returnSize);


        //Now, do the actual queries for the search results
        //In the where clause of the query we set the limit of the results we want to return to 100 to make sure
        //we get all the results we need, we will filter the results later on
        //We also set an offset value to make sure we get the correct results for the current page
        //We receive the offset value from the pagination component
        List<Product2> productResults = Database.query(query);
        system.debug('productResults: ' + productResults.size());

        //Create a list and a map of the parent product Ids
        List<Id> parentIds = new List<Id>();
        Map<Id, Product2> parentMap = new Map<Id, Product2>();
        for(Product2 p : productResults) {
            parentIds.add(p.Id);
            parentMap.put(p.Id, p);
        }


        System.debug('parentIds: ' + parentIds.size());
        System.debug('parentMap: ' + parentIds);

        //This gives us a list of parent products we need to parse in order to get the correct variation
        //products and price book entries needed for the component to display
        //We need to do this because the search results are based on the parent product
        //The variation products are the ones that are actually added to the search results
        //The parentIds list is used to query the variation products

        // String productStringQuery = 'SELECT Id,Product2.Name,Product2Id,Product2.Parent__c, Product2.Supplier__r.Name, Product2.Supplier__r.Logo_Ext__c,Product2.Delivery_Date_1__c,Product2.Delivery_Date_2__c,Product2.Delivery_Date_3__c,'+
        // 'Product2.Available_Quantity_1__c, Product2.Available_Quantity_2__c,Product2.Available_Quantity_3__c, Product2.QR_Eprel__c,UnitPrice,Distribution_Discount__c '+
        // 'FROM PriceBookEntry WHERE Product2.Parent__c IN :parentIds AND Pricebook2.Type__c = :userType AND Product2.ProductClass = \'Variation\' AND Product2.Supplier__c NOT IN :blockedSuppliers'+
        // 'ORDER BY Product2.Supplier__r.Type ASC, :rankingOrder, UnitPrice ASC';
        // List<PriceBookEntry> products = Database.query(productStringQuery);

        List<PriceBookEntry> products = new List<PriceBookEntry>();

        if (rankingOrder == 'Ranking__c'){

            products = [   Select Id,
                    Product2.Name,
                    Product2Id,
                    Product2.Parent__c,
                    Product2.Supplier__r.Name,
                    Product2.Supplier__r.Logo_Ext__c,
                    Product2.Delivery_Date_1__c,
                    Product2.Delivery_Date_2__c,
                    Product2.Delivery_Date_3__c,
                    Product2.Available_Quantity_1__c,
                    Product2.Available_Quantity_2__c,
                    Product2.Available_Quantity_3__c,
                    Product2.QR_Eprel__c,
                    UnitPrice,Distribution_Discount__c,
                    Product2.Parent__r.Brand__r.Description_NL__c,
                    Product2.Parent__r.Brand__r.Ranking__c,
                    Product2.Parent__r.Ranking__c
            FROM PriceBookEntry
            WHERE Product2.Parent__c IN :parentIds
            AND IsActive = true
            AND product2.parent__r.RecordType.Name =: recordType
            AND Pricebook2.Type__c = :userType
            AND Product2.ProductClass = 'Variation'
            AND Product2.Supplier__c NOT IN :blockedSuppliers
            AND Product2.Available_Quantity_1__c != '0'
            AND Product2.Available_Quantity_2__c != '0'
            AND Product2.Available_Quantity_3__c != '0'
            ORDER BY Product2.Parent__r.Brand__r.Ranking__c DESC NULLS LAST, Product2.Parent__r.Ranking__c DESC NULLS LAST,  Product2.Supplier__r.Type ASC, UnitPrice ASC
            ];

        } else {

            products = [   Select Id,
            Product2.Name,
            Product2Id,
            Product2.Parent__c,
            Product2.Supplier__r.Name,
            Product2.Supplier__r.Logo_Ext__c,
            Product2.Delivery_Date_1__c,
            Product2.Delivery_Date_2__c,
            Product2.Delivery_Date_3__c,
            Product2.Available_Quantity_1__c,
            Product2.Available_Quantity_2__c,
            Product2.Available_Quantity_3__c,
            Product2.QR_Eprel__c,
            UnitPrice,Distribution_Discount__c,
            Product2.Parent__r.Brand__r.Description_NL__c,
            Product2.Parent__r.Brand__r.Ranking__c,
            Product2.Parent__r.Ranking__c
            FROM PriceBookEntry
            WHERE Product2.Parent__c IN :parentIds
            AND IsActive = true
            AND product2.parent__r.RecordType.Name =: recordType
            AND Pricebook2.Type__c = :userType
            AND Product2.ProductClass = 'Variation'
            AND Product2.Supplier__c NOT IN :blockedSuppliers
            AND Product2.Available_Quantity_1__c != '0'
            AND Product2.Available_Quantity_2__c != '0'
            AND Product2.Available_Quantity_3__c != '0'
            ORDER BY Product2.Parent__r.Brand__r.Ranking__c DESC NULLS LAST, Product2.Parent__r.Ranking_Dist__c DESC NULLS LAST,  Product2.Supplier__r.Type ASC, UnitPrice ASC
            ];
        }

        System.debug('products: ' + products.size());

        List<ProductSearchWrapper.SearchResult> results = new List<ProductSearchWrapper.SearchResult>();

        //Next, we need a map of the parent products and a list of the variation products
        //that are children of the parent product

        //Before we can populate this map properly, we need a list with all unique Product2.Parent__c values
        //from the list of PriceBookEntry records

        List<Id> uniqueParentIds = new List<Id>();
        for(PriceBookEntry p : products) {
            if(!uniqueParentIds.contains(p.Product2.Parent__c)) {
                uniqueParentIds.add(p.Product2.Parent__c);
            }
        }


        //Loop through the unique list of Ids, and for every value find the corresponding PriceBookEntry records
        //and add them to the map

        Integer index = 0;
        Integer linesAdded = 0;

        System.debug('uniqueParentIds: ' + uniqueParentIds.size());
        for(Id pId : uniqueParentIds) {
            system.debug('linesAdded: ' + linesAdded);
            List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
            for(PriceBookEntry p : products) {
                if(p.Product2.Parent__c == pId) {
                    pbeList.add(p);
                }
            }
        //Call the wrapper to parse the current result
            ProductSearchWrapper.SearchResult searchResult = ProductSearchWrapper.parseSearchResult(parentMap.get(pId), pbeList, index);
            //Check if the searchResult quantity is greater than 0 and whether wholesalers and manufactuers have values
            //If so, add the searchResult to the results list
            //We keep on adding results until we reach the maximum number of results we want to display
            if(searchResult.quantity == 0 && searchResult.wholesalers.size() == 0 && searchResult.manufacturers.size() == 0) {
                //Do nothing
            } else {
                if(linesAdded < limitResult) {
                    results.add(searchResult);
                    index++;
                    linesAdded++;
                } else {
                    break;
                }
            }

        }
        system.debug('results size :'+allParentIds.size());
        try {
            results[0].totalRecords = allParentIds.size();
        } catch(Exception e) {
            system.debug('Exception: ' + e);
        }
    return JSON.serialize(results);
    }

    public static String getWhereClause(String recordType,
            String Dim1,
            String Serie,
            String Dim3,
            String capacity,
            String speed,
            String searchTerm,
            String brand,
            String Season,
            String use,
            String axis,
            String fuel,
            String Grip,
            String Noise,
            String type,
            String motoSeason,
            String position,
            String usage,
            String rubber,
            String Category,
            String specification,
            String homologation,
            Boolean Runflat,
            Boolean PMSF,
            Boolean Seal,
            Boolean Sound,
            Boolean Elt,
            Boolean fullQuery,
            Integer offset,
            String rankingOrder,
            List<String> blockedSuppliers){

        System.debug('Dim1: ' + Dim1);
        System.debug('Serie: ' + Serie);
        System.debug('Dim3: ' + Dim3);
        System.debug('capacity: ' + capacity);
        System.debug('speed: ' + speed);
        System.debug('searchTerm: ' + searchTerm);

        //Build a string of all filter values to check whether any of them are not empty
        String filterValues = String.valueOf(Dim1) + String.valueOf(Serie) + String.valueOf(Dim3) + String.valueOf(capacity) + String.valueOf(speed);
        filterValues = filterValues.replaceAll('null', '');
        System.debug('filterValues: ' + filterValues);
        String whereClause = '';

        //list containing all the values corresponding to the homologation label choosen

        //There are 4 possible scenarios:
            //1. No search term, no filters
            //2. Search term, no filters
            //3. No search term, filters
            //4. Search term, filters

        //1. No search term, no filters

        if(String.isBlank(searchTerm) && String.isBlank(filterValues)) {
            system.debug('No search term, no filters'); //ORDER BY Ranking__c DESC, Delivery_Date_1__c ASC
            whereClause = 'WHERE Id != null AND RecordType.Name =: recordType';
        }

        //2. Search term, no filters
        if(!String.isBlank(searchTerm) && String.isBlank(filterValues)) {
            system.debug('Search term, no filters');
            whereClause = 'WHERE (Search_Field__c LIKE \'%' +searchTerm +'%\' OR Dimension_Indexed__c LIKE \'%'+searchTerm+'%\' OR Brand_Profile_Text__c LIKE \'%'+searchTerm+'%\') AND RecordType.Name =: recordType';
        }

        //3. No search term, filters
        if(String.isBlank(searchTerm) && !String.isBlank(filterValues)) {
            System.debug('No search term, filters');
            //We're going to assume that if a value is not null, all preceding values are not null
            if(speed != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 AND Drvm__c =: capacity AND Speed__c = :speed AND RecordType.Name =: recordType';
            } else if (capacity != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 AND Drvm__c =: capacity AND RecordType.Name =: recordType';
            } else if (Dim3 != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 AND RecordType.Name =: recordType';
            } else if (Serie != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND RecordType.Name =: recordType';
            } else if (Dim1 != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND RecordType.Name =: recordType';
            }
        }

        //4. Search term, filters
        if(!String.isBlank(searchTerm) && !String.isBlank(filterValues)) {
            System.debug('Search term, filters');
            //We're going to assume that if a value is not null, all preceding values are not null
            if(speed != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 AND Drvm__c =: capacity AND Speed__c = :speed ';
            } else if (capacity != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 AND Drvm__c =: capacity ';
            } else if (Dim3 != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie AND Dim3__c = :Dim3 ';
            } else if (Serie != null){
                whereClause += 'WHERE Dim1__c = :Dim1 AND Serie__c = :Serie ';
            } else if (Dim1 != null){
                whereClause += 'WHERE Dim1__c = :Dim1 ';
            }
            whereClause += 'AND (Search_Field__c LIKE \'%' +searchTerm +'%\' OR Dimension_Indexed__c LIKE \'%'+searchTerm+'%\' OR Brand_Profile_Text__c LIKE \'%'+searchTerm+'%\') AND RecordType.Name =: recordType';
        }

        //Next, we check the brand, season, fuel, grip and noise filters one by one and add them to the where clause
        //if they are not null

        if(brand != null) {
            System.debug('brand: ' + brand);
            whereClause += ' AND Brand__r.Description_NL__c IN :brandList';
        }
        if(Season != null){
            whereClause += ' AND Season__c = :Season';
        }
        if(use != null){
            whereClause += ' AND truckappl__c = :use';
        }
        if(axis != null){
            whereClause += ' AND truckax__c = :axis';
        }
        if(fuel != null){
            whereClause += ' AND BEclass__c = :fuel';
        }
        if(Grip != null){
            whereClause += ' AND Grip__c = :Grip';
        }
        if(Noise != null){
            whereClause += ' AND REvalue__c = :Noise';
        }
        if(type != null){
            whereClause += ' AND (Article_Type__r.Description_NL__c = :type OR Article_Type__r.Description_FR__c = :type)';
        }
        if(motoSeason != null){
            whereClause += ' AND Moto_Season__c = :motoSeason';
        }
        if(position != null){
            whereClause += ' AND Position__c = :position';
        }
        if(usage != null){
            whereClause += ' AND Usage__c = :usage';
        }
        if(rubber != null){
            whereClause += ' AND Rubber_Hardness__c = :rubber';
        }
        if(Category != null){
            whereClause += ' AND Product_Category__c = :Category';
        }
        if(specification != null){
            whereClause += ' AND Fitm__c = :specification';
        }
        if(homologation != null){
            // homologationValues2 = ProductSearchController.getHomologationValues(homologation);
            system.debug('homologation values is not empty');
            whereClause += ' AND Application__c IN :homologationValues2';
        }
        if (Runflat == true) {
            whereClause += ' AND Rof__c = :Runflat';
        }
        if (PMSF == true) {
            whereClause += ' AND X3PMSF__c = :PMSF';
        }
        if (Seal == true) {
            whereClause += ' AND Seal__c = :Seal';
        }
        if (Sound == true) {
            whereClause += ' AND Sound__c = :Sound';
        }
        if (Elt == true) {
            whereClause += ' AND Elt__c = :Elt';
        }



        if(fullQuery) {
            if (rankingOrder == 'Ranking__c') {
                whereClause += ' AND hasVariations__c = TRUE ORDER BY Brand__r.Ranking__c DESC NULLS LAST, Ranking__c DESC, Delivery_Date_1__c ASC LIMIT 100 OFFSET :offset';
            }else if(rankingOrder == 'Ranking_Dist__c'){
                whereClause += ' AND hasVariations__c = TRUE ORDER BY Brand__r.Ranking__c DESC NULLS LAST, Ranking_Dist__c DESC, Delivery_Date_1__c ASC LIMIT 100 OFFSET :offset';
            }
        } else {
            whereClause += ' AND hasVariations__c = TRUE';
        }


        system.debug('whereClause: ' + whereClause);
        return whereClause;

    }
    @AuraEnabled(cacheable=true)
    public static List<String> getHomologationValues (String homologation){
        List<Homologation_Brand__c> homologations = [select Value__c, Name from Homologation_Brand__c where Name = :homologation];
        List<String> homologationValues = new List<String>();
        for(Homologation_Brand__c currValue : homologations) {
            homologationValues.add(currValue.Value__c);
        }
        system.debug('values :'+ homologationValues);
        return homologationValues;
    }

    @AuraEnabled
    public static void saveFavoriteBrands(String brand, String userId) {

        system.debug('brand: ' + brand);
        system.debug('userId: ' + userId);


        User curUser = [Select Contact.Favorite_Brands__c, ContactId from User where Id = :userId];
        string favoriteBrands = brand;
        favoriteBrands = favoriteBrands.replace('[', '');
        favoriteBrands = favoriteBrands.replace(']', '');
        favoriteBrands = favoriteBrands.replace('"', '');

        Contact c = new Contact(Id = curUser.ContactId, Favorite_Brands__c = favoriteBrands);
        update c;
        System.debug('Favorite brands saved');
    }

    @AuraEnabled
    public static String getFavoriteBrands(String userId) {

        User curUser = [Select Contact.Favorite_Brands__c, ContactId from User where Id = :userId];
        string favoriteBrands = curUser.Contact.Favorite_Brands__c;
        System.debug('Favorite brands: ' + favoriteBrands);
        return favoriteBrands;
    }
    @AuraEnabled
    public static String getUserType(String userId) {
        User curUser = [SELECT Id, Type_of_User__c FROM User WHERE Id = :UserInfo.getUserId()];
        // system.debug('curUser: ' + curUser);
        return curUser.Type_of_User__c;
        // system.debug('user type from Product Search Wrapper: ' + userType);
    }
}