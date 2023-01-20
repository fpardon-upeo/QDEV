/* created by :
    Abdelhafid Khribech 
    on 21/11/2022 
*/


public with sharing class ProductController {
    // public ProductController() {

    // }
    // public class WholesalerProduct{
    //     @AuraEnabled
    //     public String RecordTypeName;
    //     @AuraEnabled
    //     public String Supplier;
    //     @AuraEnabled
    //     public String Brand;
    //     @AuraEnabled
    //     public String EAN_Code;
    //     @AuraEnabled
    //     public String Dimension;
    //     @AuraEnabled
    //     public String BrandProfil;
    //     @AuraEnabled
    //     public String Label;
    //     @AuraEnabled
    //     public Date DeliveryDate;
    //     @AuraEnabled
    //     public String Quantity;
    //     @AuraEnabled
    //     public Double SalesPrice;
    //     @AuraEnabled
    //     public Double ListPrice;
    //     @AuraEnabled
    //     public Boolean Manufacturer;
    //     @AuraEnabled
    //     public Boolean FirstManufacturer;
        
        
    //     public WholesalerProduct(String RecordTypeName, String Supplier, String Brand, String EAN_Code, String Dimension, String BrandProfil, String Label, Date DeliveryDate, String Quantity, Double SalesPrice, Double ListPrice, Boolean Manufacturer){
    //         this.RecordTypeName = RecordTypeName;
    //         this.Supplier = Supplier;
    //         this.Brand = Brand;
    //         this.EAN_Code = EAN_Code;
    //         this.Dimension = Dimension;
    //         this.BrandProfil = BrandProfil;
    //         this.Label = Label;
    //         this.DeliveryDate = DeliveryDate;
    //         this.Quantity = Quantity;
    //         this.SalesPrice = SalesPrice;
    //         this.ListPrice = ListPrice;
    //         this.Manufacturer = Manufacturer;
    //         this.FirstManufacturer = FirstManufacturer;
    //     }
    //     public WholesalerProduct(){

    //     }
    // }
    // public class WrapperProduct{
    //     @AuraEnabled
    //     public String Name;
    //     @AuraEnabled
    //     public String RecordTypeName;
    //     @AuraEnabled
    //     public String Supplier;
    //     @AuraEnabled
    //     public String Brand;
    //     @AuraEnabled
    //     public String EAN_Code;
    //     @AuraEnabled
    //     public String Dimension;
    //     @AuraEnabled
    //     public String BrandProfil;
    //     @AuraEnabled
    //     public String Label;
    //     @AuraEnabled
    //     public Date DeliveryDate;
    //     @AuraEnabled
    //     public String Quantity;
    //     @AuraEnabled
    //     public Double SalesPrice;
    //     @AuraEnabled
    //     public Double ListPrice;
    //     @AuraEnabled
    //     public Boolean Manufacturer;
    //     @AuraEnabled
    //     public Boolean FirstManufacturer;
    //     @AuraEnabled
    //     public List<WrapperProduct> wholesalers;
    //     @AuraEnabled
    //     public List<WrapperProduct> manufacturerLines;
        
        
    //     public WrapperProduct(String Name, String RecordTypeName, String Supplier, String Brand, String EAN_Code, String Dimension, String BrandProfil, String Label, Date DeliveryDate, String Quantity, Double SalesPrice, Double ListPrice, Boolean Manufacturer,List<WrapperProduct> wholesalers,List<WrapperProduct> manufacturerLines){
    //         this.Name = Name;
    //         this.RecordTypeName = RecordTypeName;
    //         this.Supplier = Supplier;
    //         this.Brand = Brand;
    //         this.EAN_Code = EAN_Code;
    //         this.Dimension = Dimension;
    //         this.BrandProfil = BrandProfil;
    //         this.Label = Label;
    //         this.DeliveryDate = DeliveryDate;
    //         this.Quantity = Quantity;
    //         this.SalesPrice = SalesPrice;
    //         this.ListPrice = ListPrice;
    //         this.Manufacturer = Manufacturer;
    //         this.FirstManufacturer = FirstManufacturer;
    //         this.wholesalers = wholesalers;
    //         this.manufacturerLines = manufacturerLines;
    //     }
    //     public WrapperProduct(){

    //     }

    // }
    // //third step
    // @AuraEnabled(cacheable=true)
    // public static List<WrapperProduct> getManufacturers(String recordType,Id UserId, String width, String heigth, String inches, String capacity, String speed, String searchTerm){
    //     String whereClause = ' WHERE RecordType.Name = \'Car\' AND Supplier__r.Type = \'Manufacturer\'';
    //     // 'SELECT Id FROM MyCustomObject__c WHERE field1__c =  :resolvedField1'
    //     if (searchTerm != null){
    //         whereClause += ' AND (Dimension_Indexed__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR BrandProfil__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\')';
            
    //     }
    //     if (width != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Dim1__c = :width';
    //     }
    //     if (heigth != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Serie__c = :heigth';
    //     }
    //     if (inches != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Dim3__c = :inches';
    //     }
    //     if (capacity != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Drvm__c = :capacity';
    //     }
    //     if (speed != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Speed__c = :speed';
    //     }
    //     String query = 'select Id, Name, RecordType.Name, RecordTypeId, Supplier__r.Name,Supplier__r.Type, Brand__c,EAN_Code__c,Brand__r.Name,Dimension_Indexed__c, BrandProfil__c, Label__c,Delivery_Date_1__c, Delivery_Date_2__c, Delivery_Date_3__c, Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c from Product2'+ whereClause;
    //     system.debug('the query :' + query);
    //     // List<Product2> products = [select Id, Name, RecordType.Name, RecordTypeId, Supplier__r.Name,Supplier__r.Type, Brand__c,EAN_Code__c,Brand__r.Name,Dimension_Indexed__c, BrandProfil__c, Label__c,Delivery_Date_1__c, Delivery_Date_2__c, Delivery_Date_3__c, Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c from Product2 where RecordType.Name = 'Car' AND Supplier__r.Type = 'Manufacturer' AND EAN_Code__c = '8714692505287'];
    //     List<Product2> products = Database.query(query);
    //     List<WrapperProduct> manufacturers = new List<WrapperProduct>();
    //     Map<Id,List<Double>> pricesList = getPrices(UserId);
    //     for (Product2 prod : products) {
    //         for(Id key: pricesList.keySet()){
    //             if (key == prod.Id && prod.Available_Quantity_1__c != null) {
    //                 List<Double> prices = pricesList.get(key);
    //                 Double salesPrice;
    //                 if (prices.size() < 2) {
    //                     salesPrice = 0.0;
    //                 }
    //                 else {
    //                     salesPrice = prices[1];
    //                 }
    //                 Integer Stock1;
    //                 Integer Stock2;
    //                 //initialisation des stocks par les quantités du manufacturer 
    //                 if (prod.Available_Quantity_1__c.contains('>')) {
    //                     Stock1 = Integer.valueOf(prod.Available_Quantity_1__c.substringAfter('>').trim());
    //                 }
    //                 else {
    //                     Stock1 = Integer.valueOf(prod.Available_Quantity_1__c.trim());
    //                 }
    //                 if (prod.Available_Quantity_2__c.contains('>')) {
    //                     Stock2 = Integer.valueOf(prod.Available_Quantity_2__c.substringAfter('>').trim());
    //                 }
    //                 else {
    //                     Stock2 = Integer.valueOf(prod.Available_Quantity_2__c.trim());
    //                 }
    //                 //add product instance to the list which will be returned
    //                 system.debug('hello 1.5');
    //                 WrapperProduct firstProduct = new WrapperProduct();
    //                 firstProduct.Name = prod.Name;
    //                 firstProduct.RecordTypeName = prod.RecordType.Name;
    //                 firstProduct.Supplier = prod.Supplier__r.Name;
    //                 firstProduct.Brand = prod.Brand__r.Name;
    //                 firstProduct.EAN_Code = prod.EAN_Code__c;
    //                 firstProduct.Dimension = prod.Dimension_Indexed__c;
    //                 firstProduct.BrandProfil = prod.BrandProfil__c;
    //                 firstProduct.Label = prod.Label__c;
    //                 firstProduct.DeliveryDate = prod.Delivery_Date_1__c;
    //                 firstProduct.Quantity = prod.Available_Quantity_1__c;
    //                 firstProduct.ListPrice = prices[0];
    //                 firstProduct.SalesPrice = salesPrice;
    //                 firstProduct.Manufacturer = true;
    //                 firstProduct.FirstManufacturer = true;
    //                 firstProduct.manufacturerLines = new List<WrapperProduct>();
    //                 system.debug('new Product : '+firstProduct);
    //                 //Check if stock1 is under 8
    //                 if (Stock1 < 8 ) {
    //                     system.debug('hello 2');
    //                     //add second product instance to the list
    //                     WrapperProduct secondProduct = new WrapperProduct();
    //                     secondProduct.Name = prod.Name;
    //                     secondProduct.RecordTypeName = prod.RecordType.Name;
    //                     secondProduct.Supplier = prod.Supplier__r.Name;
    //                     secondProduct.Brand = prod.Brand__r.Name;
    //                     secondProduct.EAN_Code = prod.EAN_Code__c;
    //                     secondProduct.Dimension = prod.Dimension_Indexed__c;
    //                     secondProduct.BrandProfil = prod.BrandProfil__c;
    //                     secondProduct.Label = prod.Label__c;
    //                     secondProduct.DeliveryDate = prod.Delivery_Date_2__c;
    //                     secondProduct.Quantity = prod.Available_Quantity_2__c;
    //                     secondProduct.ListPrice = prices[0];
    //                     secondProduct.SalesPrice = salesPrice;
    //                     secondProduct.Manufacturer = true;
    //                     secondProduct.FirstManufacturer = false;
    //                     firstProduct.manufacturerLines.add(secondProduct);
    //                     system.debug('new Product : '+secondProduct);
    //                 }
    //                 if (Stock2 < 8) {
    //                     system.debug('hello 3');
    //                     WrapperProduct thirdProduct = new WrapperProduct();
    //                     thirdProduct.Name = prod.Name;
    //                     thirdProduct.RecordTypeName = prod.RecordType.Name;
    //                     thirdProduct.Supplier = prod.Supplier__r.Name;
    //                     thirdProduct.Brand = prod.Brand__r.Name;
    //                     thirdProduct.EAN_Code = prod.EAN_Code__c;
    //                     thirdProduct.Dimension = prod.Dimension_Indexed__c;
    //                     thirdProduct.BrandProfil = prod.BrandProfil__c;
    //                     thirdProduct.Label = prod.Label__c;
    //                     thirdProduct.DeliveryDate = prod.Delivery_Date_3__c;
    //                     thirdProduct.Quantity = prod.Available_Quantity_3__c;
    //                     thirdProduct.ListPrice = prices[0];      
    //                     thirdProduct.SalesPrice = salesPrice;
    //                     thirdProduct.Manufacturer = true;
    //                     thirdProduct.FirstManufacturer = false;
    //                     firstProduct.manufacturerLines.add(thirdProduct);
    //                 }
    //                 manufacturers.add(firstProduct);
    //             }
    //         }
    //     }
    //     system.debug('manufacturer size : '+manufacturers.size());
    //     for (WrapperProduct man : manufacturers) {
    //         system.debug('response lines : '+ man.manufacturerLines);
    //         system.debug('response : '+ man);
    //     }
    //     // system.debug('manufacturerlines size : '+manufacturers.manufacturerLines.size());
    //     system.debug(manufacturers);
    //     return manufacturers;
    // }

    // //4th step
    // @AuraEnabled(cacheable=true)
    // public static List<WrapperProduct> getWholesalers(String recordType,Id UserId, String width, String heigth, String inches, String capacity, String speed, String searchTerm){
    //     String whereClause = ' WHERE RecordType.Name = \'Car\' AND Supplier__r.Type = \'Alternative\'';
        // 'SELECT Id FROM MyCustomObject__c WHERE field1__c =  :resolvedField1'
    //     if (searchTerm != null){
    //         whereClause += ' AND (Dimension_Indexed__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR BrandProfil__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\')';
    //     }
    //     if (width != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Dim1__c = :width';
    //     }
    //     if (heigth != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Serie__c = :heigth';
    //     }
    //     if (inches != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Dim3__c = :inches';
    //     }
    //     if (capacity != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Drvm__c = :capacity';
    //     }
    //     if (speed != null) {
    //         if (whereClause != '') {
    //             whereClause += ' AND ';
    //         }
    //         whereClause += 'Speed__c = :speed';
    //     }
    //     String query = 'select Id, Name, RecordType.Name, RecordTypeId, Supplier__r.Name,Supplier__r.Type, Brand__c,EAN_Code__c,Brand__r.Name,Dimension_Indexed__c, BrandProfil__c, Label__c,Delivery_Date_1__c, Delivery_Date_2__c, Delivery_Date_3__c, Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c from Product2'+ whereClause;
    //     system.debug('the query :' + query);
    //     // List<Product2> products = [select Id, Name, RecordType.Name, RecordTypeId, Supplier__r.Name,Supplier__r.Type, Brand__c,EAN_Code__c,Brand__r.Name,Dimension_Indexed__c, BrandProfil__c, Label__c,Delivery_Date_1__c, Delivery_Date_2__c, Delivery_Date_3__c, Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c from Product2 where RecordType.Name = 'Car' AND Supplier__r.Type = 'Manufacturer' AND EAN_Code__c = '8714692505287'];
    //     List<Product2> products = Database.query(query);
    //     //List<Product2> products = [select Id, Name, RecordType.Name, RecordTypeId, Supplier__r.Name,Supplier__r.Type, Brand__c,EAN_Code__c,Brand__r.Name,Dimension_Indexed__c, BrandProfil__c, Label__c,Delivery_Date_1__c, Available_Quantity_1__c from Product2 where RecordType.Name = 'Car' AND Supplier__r.Type = 'Alternative'AND EAN_Code__c = '8714692505287'];
    //     List<WrapperProduct> wholesalers = new List<WrapperProduct>();
    //     Map<Id,List<Double>> pricesList = getPrices(UserId);
    //     for (Product2 currProduct : products) {
    //         for(Id key: pricesList.keySet()){
    //             if (key == currProduct.Id) {
    //                 List<Double> prices = pricesList.get(key);
    //                 WrapperProduct newWholesaler = new WrapperProduct();
    //                 newWholesaler.Name = currProduct.Name;
    //                 newWholesaler.RecordTypeName = currProduct.RecordType.Name;
    //                 newWholesaler.Supplier = currProduct.Supplier__r.Name;
    //                 newWholesaler.Brand = currProduct.Brand__r.Name;
    //                 newWholesaler.EAN_Code = currProduct.EAN_Code__c;
    //                 newWholesaler.Dimension = currProduct.Dimension_Indexed__c;
    //                 newWholesaler.BrandProfil = currProduct.BrandProfil__c;
    //                 newWholesaler.Label = currProduct.Label__c;
    //                 newWholesaler.DeliveryDate = currProduct.Delivery_Date_1__c;
    //                 newWholesaler.Quantity = currProduct.Available_Quantity_1__c;
    //                 newWholesaler.ListPrice = prices[0];
    //                 if (prices.size() < 2) {
    //                     newWholesaler.SalesPrice = 0.0;
    //                 }
    //                 else {
    //                     newWholesaler.SalesPrice = prices[1];
    //                 }
    //                 newWholesaler.Manufacturer = false;
    //                 newWholesaler.FirstManufacturer = false;
    //                 wholesalers.add(newWholesaler);                    
    //             }
    //         }
    //     }
    //     system.debug('wholesaler size : '+wholesalers.size());
    //     system.debug(wholesalers);
    //     return wholesalers;
    // }

    // //5th step
    // @AuraEnabled(cacheable=true)
    // public static List<WrapperProduct> getVariations(String recordType,Id UserId, String width, String heigth, String inches, String capacity, String speed, String searchTerm){
    //     //List<WrapperProduct> variations = new List<WrapperProduct>();
    //     List<WrapperProduct> manufacturers = new List<WrapperProduct>();
    //     List<String> EANcodes = new List<String>();
    //     List<WrapperProduct> manufacturersToAdd = new List<WrapperProduct>();
    //     manufacturers.addAll(getManufacturers(recordType,UserId,width,heigth,inches,capacity,speed,searchTerm)); 
    //     List<WrapperProduct> wholesalers = getWholesalers(recordType,UserId,width,heigth,inches,capacity,speed,searchTerm);
    //     for (WrapperProduct currManufacturer : manufacturers) {
    //         List<WrapperProduct> wholesalersToAdd = new List<WrapperProduct>();
    //         for (WrapperProduct currWholesaler : wholesalers) {
    //             if (currManufacturer.EAN_Code == currWholesaler.EAN_Code) {
    //                 wholesalersToAdd.add(currWholesaler);
    //             }else {
    //                 if (!EANcodes.contains(currWholesaler.EAN_Code)) {
    //                     EANcodes.add(currWholesaler.EAN_Code);
    //                     manufacturersToAdd.add(currWholesaler);
    //                 }
    //             }
    //         }
    //         currManufacturer.wholesalers = wholesalersToAdd;
    //     }
    //     manufacturers.addAll(manufacturersToAdd);

    //     system.debug('variation size : '+ manufacturers.size());
    //     system.debug(manufacturers);
    //     // system.debug('le json : '+ JSON.serialize(variations));
    //     return manufacturers;
    // }

    //second step
    // @AuraEnabled(cacheable=true)
    // public static Map<Id,List<Double>> getPrices(Id UserId){
    //     Pricebook2 pricebook = getUserPricebook(UserId);
    //     List<PricebookEntry> standardPriceBookEntries = [select id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name = 'Standard Price Book'];
    //     List<PricebookEntry> priceBookEntries =[select id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice from PricebookEntry where Pricebook2Id =: pricebook.Id];
    //     Map<Id,List<Double>> pricesList = new Map<Id,List<Double>>();
    //     // system.debug('pricebook entries size : ' +standardPriceBookEntries.size());
    //     // system.debug('pricebook entries : ' +standardPriceBookEntries);
    //     // system.debug('pricebook entries size : ' +priceBookEntries.size());
    //     // system.debug('pricebook entries : ' +priceBookEntries);

    //     for (PricebookEntry standardPriceEntry : standardPriceBookEntries) {
    //         pricesList.put(standardPriceEntry.Product2Id, new List<Double> { standardPriceEntry.UnitPrice });
    //     }
    //     for (PricebookEntry priceEntry : priceBookEntries) {
    //         List<Double> prices = pricesList.get(priceEntry.Product2Id);
    //         prices.add(priceEntry.UnitPrice);
    //         pricesList.put(priceEntry.Product2Id, prices);
    //     }           
    //     system.debug('priceList : '+pricesList);
    //     return pricesList; 
    // }
        
    // //first step
    // @AuraEnabled(cacheable=true)
    // public static Pricebook2 getUserPricebook(Id UserId){
    //     User user = [select id,Type_of_User__c,ContactId from User where id =: UserId][0];
    //     // Contact contact = [select id,AccountId from Contact where id =: user.ContactId][0];
    //     // Account account = [select id from Account where id =: contact.AccountId ][0];
    //     // BuyerGroupMember buyerGroupMember = [select id,BuyerId,BuyerGroupId from BuyerGroupMember where BuyerId =: account.id][0];
    //     // BuyerGroup buyerGroup = [select id from BuyerGroup where id =: buyerGroupMember.BuyerGroupId][0];
    //     // BuyerGroupPricebook groupPriceBook = [select id,Pricebook2Id,BuyerGroupId from BuyerGroupPricebook where BuyerGroupId =:buyerGroup.id AND IsActive = true][0];
    //     Pricebook2 pricebook = [select id,Name,Type__c from Pricebook2 where Type__c =: user.Type_of_User__c][0];
    //     system.debug(pricebook);
    //     return pricebook;
    // }
    //Get height options for combo box
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getHeights(String recordType,String width){
        List<Map<String,String>> heightOptions = new List<Map<String,String>>();
        List<AggregateResult> heights = [select Serie__c from Product2 where Serie__c != null and Dim1__c =: width and RecordType.Name =:recordType group by Serie__c];
        for (AggregateResult height : heights) {
            String h = String.valueOf(height.get('Serie__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',h);
            option.put('value',h);
            heightOptions.add(option);
       }
       return heightOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getWidths(String recordType){
        List<Map<String,String>> widthOptions = new List<Map<String,String>>();
        List<AggregateResult> widths = [select Parent__r.Dim1__c from Product2 where Available_Quantity_1__c != '0' AND ProductClass = 'Variation' AND Parent__r.Dim1__c != null AND Parent__r.RecordType.Name =:recordType group by Parent__r.Dim1__c];
        for (AggregateResult width : widths) {
            String w = String.valueOf(width.get('Dim1__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',w);
            option.put('value',w);
            widthOptions.add(option);
        }
        return widthOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getInches(String recordType,String height, String width){
        List<Map<String,String>> inchesOptions = new List<Map<String,String>>();
        List<AggregateResult> inches = [select Dim3__c from Product2 where Dim3__c != null and Serie__c =: height and Dim1__c =: width and RecordType.Name =:recordType group by Dim3__c];
        for (AggregateResult inch : inches) {
            String i = String.valueOf(inch.get('Dim3__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',i);
            option.put('value',i);
            inchesOptions.add(option);
        }
        return inchesOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getCapacities(String recordType,String height, String width, String inches){
        List<Map<String,String>> capacitiesOptions = new List<Map<String,String>>();
        List<AggregateResult> capacities = [select Drvm__c from Product2 where Drvm__c != null and Dim3__c =:inches and Serie__c =:height and Dim1__c =:width and RecordType.Name =:recordType group by Drvm__c];
        for (AggregateResult capacity : capacities) {
            String c = String.valueOf(capacity.get('Drvm__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',c);
            option.put('value',c);
            capacitiesOptions.add(option);
        }
        return capacitiesOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getSpeeds(String recordType,String height, String width, String inches, String capacity){
        List<Map<String,String>> speedsOptions = new List<Map<String,String>>();
        List<AggregateResult> speeds = [select Speed__c from Product2 where Speed__c != null and Drvm__c =:capacity and Dim3__c =:inches and Serie__c =:height and Dim1__c =:width and RecordType.Name =:recordType group by Speed__c];
        for (AggregateResult speed : speeds) {
            String s = String.valueOf(speed.get('Speed__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',s);
            option.put('value',s);
            speedsOptions.add(option);
        }
        return speedsOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getBrands(String recordType){
        List<Map<String,String>> brandsOptions = new List<Map<String,String>>();
        List<AggregateResult> brands = [select count(id), Brand__r.description_FR__c descrp from Product2 where Brand__r.description_FR__c != null AND recordType.Name =:recordType group by Brand__r.description_FR__c];
        for (AggregateResult currBrand : brands) {
            String b = String.valueOf(currBrand.get('descrp'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',b);
            option.put('value',b);
            brandsOptions.add(option);
        }
        system.debug('brands : '+brandsOptions.size());
        return brandsOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getFuels(String recordType){
        List<Map<String,String>> fuelOptions = new List<Map<String,String>>();
        List<AggregateResult> fuels = [select Parent__r.BEclass__c from Product2 where Parent__r.BEclass__c != null and Parent__r.RecordType.Name =:recordType AND ProductClass = 'Variation' AND Available_Quantity_1__c != '0'  group by Parent__r.BEclass__c order by Parent__r.BEclass__c];
        for (AggregateResult currFuel : fuels) {
            String f = String.valueOf(currFuel.get('BEclass__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',f);
            option.put('value',f);
            fuelOptions.add(option);
        }
        return fuelOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getGrips(String recordType,String fuel){
        List<Map<String,String>> gripOptions = new List<Map<String,String>>();
        List<AggregateResult> grips = [select Parent__r.Grip__c from Product2 where Parent__r.Grip__c != null AND Parent__r.RecordType.Name =:recordType AND ProductClass = 'Variation' AND Available_Quantity_1__c != '0' group by Parent__r.Grip__c order by Parent__r.Grip__c];
        for (AggregateResult currGrip : grips) {
            String g = String.valueOf(currGrip.get('Grip__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',g);
            option.put('value',g);
            gripOptions.add(option);
       }
       return gripOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getNoises(String recordType,String fuel,String grip){
        List<Map<String,String>> noiseOptions = new List<Map<String,String>>();
        List<AggregateResult> noises = [select Parent__r.REvalue__c from Product2 where Parent__r.REvalue__c != null AND Parent__r.RecordType.Name =:recordType AND ProductClass = 'Variation' AND Available_Quantity_1__c != '0'  group by Parent__r.REvalue__c order by Parent__r.REvalue__c];
        for (AggregateResult currNoise : noises) {
            String n = String.valueOf(currNoise.get('REvalue__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',n);
            option.put('value',n);
            noiseOptions.add(option);
       }
       return noiseOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getCategories(){
        List<Map<String,String>> categoryOptions = new List<Map<String,String>>();
        List<AggregateResult> categories = [select Parent__r.Product_Category__c from Product2 where Parent__r.Product_Category__c != null and Parent__r.RecordType.Name = 'Car' AND ProductClass = 'Variation' AND Available_Quantity_1__c != '0'  group by Parent__r.Product_Category__c ];
        for (AggregateResult currCategory : categories) {
            String c = String.valueOf(currCategory.get('Product_Category__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',c);
            option.put('value',c);
            categoryOptions.add(option);
       }
       return categoryOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getHomologations(){
        List<Map<String,String>> homologationOptions = new List<Map<String,String>>();
        List<AggregateResult> homologations = [select Name from Homologation_Brand__c group by Name];
        for (AggregateResult currHomologation : homologations) {
            String h = String.valueOf(currHomologation.get('Name'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',h);
            option.put('value',h);
            homologationOptions.add(option);
            
        }
        system.debug('ho;ologations :'+homologationOptions.size());
        system.debug('size : '+homologationOptions.size());
        return homologationOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getSpecifications(){
        List<Map<String,String>> specificationOptions = new List<Map<String,String>>();
        List<AggregateResult> specifications = [select Fitm__c from Product2 where Fitm__c != null and RecordType.Name = 'Car' group by Fitm__c];
        for (AggregateResult currSpecification : specifications) {
            String s = String.valueOf(currSpecification.get('Fitm__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',s);
            option.put('value',s);
            specificationOptions.add(option);
       }
       return specificationOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getSeasons(){
        List<Map<String,String>> seasonsOptions = new List<Map<String,String>>();
        Schema.DescribeFieldResult objFieldDescribe = Product2.Season__c.getDescribe();
        List<Schema.PicklistEntry> seasonPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : seasonPickListValues) {
            //System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
            Map<String,String> option = new Map<String,String>();
            option.put('label',objPickList.getLabel());
            option.put('value',objPickList.getValue());
            seasonsOptions.add(option);
        }
        system.debug('seasons'+seasonsOptions);
        return seasonsOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getUses(){
        List<Map<String,String>> useOptions = new List<Map<String,String>>();
        List<AggregateResult> uses = [select truckappl__c from Product2 where truckappl__c != null and RecordType.name = 'Truck' group by truckappl__c];
        for (AggregateResult currUse : uses) {
            String u = String.valueOf(currUse.get('truckappl__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',u);
            option.put('value',u);
            useOptions.add(option);
        }
        return useOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getAxies(){
        List<Map<String,String>> axieOptions = new List<Map<String,String>>();
        List<AggregateResult> axies = [select truckax__c from Product2 where truckax__c != null and RecordType.name = 'Truck' group by truckax__c];
        for (AggregateResult currAxie : axies) {
            String a = String.valueOf(currAxie.get('truckax__c'));
            Map<String,String> option = new Map<String,String>();
            option.put('label',a);
            option.put('value',a);
            axieOptions.add(option);
        }
        return axieOptions;
    }
    // Start of Moto filters functions
    // @AuraEnabled(cacheable=true)
    // public static List<Map<String,String>> getMotoSeasons(){
    //     List<Map<String,String>> seasonsOptions = new List<Map<String,String>>();
    //     List<AggregateResult> seasons = [select Moto_Season__c from Product2 where Moto_Season__c !=null and RecordType.name = 'Moto' group by Moto_Season__c];
    //     for (AggregateResult currSeason : seasons) {
    //         String s = String.valueOf(currSeason.get('Moto_Season__c'));
    //         Map<String,String> option = new Map<String,String>();
    //         option.put('label',s);
    //         option.put('value',s);
    //         seasonsOptions.add(option);
    //     }
    //     return seasonsOptions;
    // }
    // @AuraEnabled(cacheable=true)
    // public static List<Map<String,String>> getPositions(){
    //     List<Map<String,String>> positionOptions = new List<Map<String,String>>();
    //     Schema.DescribeFieldResult objFieldDescribe = Product2.Position__c.getDescribe();
    //     List<Schema.PicklistEntry> positionPickListValues = objFieldDescribe.getPickListValues();
    //     for (Schema.PicklistEntry objPickList : positionPickListValues) {
    //         Map<String,String> option = new Map<String,String>();
    //         option.put('label',objPickList.getLabel());
    //         option.put('value',objPickList.getValue());
    //         positionOptions.add(option);
    //     }
    //     system.debug('seasons'+positionOptions);
    //     return positionOptions;
    // }
    // @AuraEnabled(cacheable=true)
    // public static List<Map<String,String>> getTypes(){
    //     List<Map<String,String>> typeOptions = new List<Map<String,String>>();
    //     List<AggregateResult> types = new List<AggregateResult>();
    //     User curUser = [SELECT Id, LanguageLocaleKey FROM User WHERE Id = :UserInfo.getUserId()];
    //     // for (Product2 currType : types) {
    //     //     typeSet.add(currType.Moto_Type__c);
    //     // }
    //     // for (String currType : typeSet) {
    //     //     Map<String,String> option = new Map<String,String>();
    //     //     option.put('label',currType);
    //     //     option.put('value',currType);
    //     //     typeOptions.add(option);
    //     // }
        
    //     if (curUser.LanguageLocaleKey == 'fr') {
    //         types = [select Article_Type__r.Description_FR__c article from Product2 where Article_Type__r.Description_FR__c !=null and RecordType.Name = 'Moto' group by Article_Type__r.Description_FR__c];
    //         for (AggregateResult currType : types) {
    //             String s = String.valueOf(currType.get('article'));
    //             Map<String,String> option = new Map<String,String>();
    //             option.put('label',s);
    //             option.put('value',s);
    //             typeOptions.add(option);
    //         }
    //     }else {
    //         types = [select Article_Type__r.Description_NL__c article from Product2 where Article_Type__r.Description_NL__c !=null and RecordType.Name = 'Moto' group by Article_Type__r.Description_NL__c];
    //         for (AggregateResult currType : types) {
    //             String s = String.valueOf(currType.get('article'));
    //             Map<String,String> option = new Map<String,String>();
    //             option.put('label',s);
    //             option.put('value',s);
    //             typeOptions.add(option);
    //         }
    //     }
    //     system.debug('types :'+typeOptions.size());
    //     return typeOptions;
    // }
    
    // @AuraEnabled(cacheable=true)
    // public static List<Map<String,String>> getUsages(){
    //     List<Map<String,String>> usageOptions = new List<Map<String,String>>();
    //     List<AggregateResult> usages = [select Usage__c from Product2 where Usage__c !=null and RecordType.Name = 'Moto' group by Usage__c];
    //     for (AggregateResult currUsage : usages) {
    //         String u = String.valueOf(currUsage.get('Usage__c'));
    //         Map<String,String> option = new Map<String,String>();
    //         option.put('label',u);
    //         option.put('value',u);
    //         usageOptions.add(option);
    //     }
    //     system.debug('usages : '+usageOptions.size());
    //     return usageOptions;
    // }
    // @AuraEnabled(cacheable=true)
    // public static List<Map<String,String>> getRubbers(){
    //     List<Map<String,String>> rubberOptions = new List<Map<String,String>>();
    //     Schema.DescribeFieldResult objFieldDescribe = Product2.Rubber_Hardness__c.getDescribe();
    //     List<Schema.PicklistEntry> positionPickListValues = objFieldDescribe.getPickListValues();
    //     for (Schema.PicklistEntry objPickList : positionPickListValues) {
    //         Map<String,String> option = new Map<String,String>();
    //         option.put('label',objPickList.getLabel());
    //         option.put('value',objPickList.getValue());
    //         rubberOptions.add(option);
    //     }
    //     system.debug('rubbers'+rubberOptions);
    //     return rubberOptions;
    // }
    // End of Moto filters functions
    
}