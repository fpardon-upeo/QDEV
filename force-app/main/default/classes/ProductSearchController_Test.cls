@isTest(seeAllData = false)
public with sharing class ProductSearchController_Test {
    @TestSetup 
    static void setup() {
        //inseert accounts
        List<Account> accounts = new List<Account>();
        Account newManufacturer = DataFactory.createAccount('new Manufacturer','Manufacturer');
        Account newAlternative = DataFactory.createAccount('new Alternative','Alternative');
        accounts.add(newManufacturer);
        accounts.add(newAlternative);
        Account newManufacturer2 = DataFactory.createAccount('new Manufacturer2','Manufacturer');
        Account newAlternative2 = DataFactory.createAccount('new Alternative2','Alternative');
        accounts.add(newManufacturer2);
        accounts.add(newAlternative2);
        Account testAccount = DataFactory.createAccount('testAccount','Portal User');
        accounts.add(testAccount);
        insert accounts;
        Account acc = [Select Id from Account where Name = 'testAccount' Limit 1];
        //insert Contact
        Contact testContact = DataFactory.createContact(acc.Id,'testContact');
        insert testContact;
        Contact con = [Select Id from Contact where Name = 'testContact' Limit 1];
        //insert brand
        Brand__c brand = DataFactory.createBrand('OLAB','OLAB MICHELIN TYRE');
        Brand__c brand2 = DataFactory.createBrand('OLAB2','OLAB2 MICHELIN TYRE');
        List<Brand__c> brands = new List<Brand__c>{brand,brand2};
        insert brands;

        //insert user
        // Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
        // DataFactory.Userr user = new DataFactory.Userr();
        // List<User> u = user.createUsers(1,con.Id,portalProfile.Id);
        // insert u;
        //insert standard pricebook
        Pricebook2 standardpricebook = DataFactory.createStandardPricebook();
        insert standardpricebook;
        //insert homologation brand 
        List<Homologation_Brand__c> homs = DataFactory.createHomologations(1);
        insert homs;
        //insert pricebook  
        DataFactory.Pricebook pricebook = new DataFactory.Pricebook();
        List<Pricebook2> p = pricebook.createPricebooks(1);
        insert p;
        //query the elements for the create cars
        Brand__c insertedBrand = [select id,Name from brand__c where Name = 'OLAB' limit 1];
        Account insertedMan = [select id from Account where Name = 'new Manufacturer' AND Type = 'Manufacturer' limit 1];
        Account insertedWho = [select id from Account where Name = 'new Alternative' AND Type = 'Alternative' limit 1];
        Brand__c insertedBrand2 = [select id,Name from brand__c where Name = 'OLAB2' limit 1];
        Account insertedMan2 = [select id from Account where Name = 'new Manufacturer2' AND Type = 'Manufacturer' limit 1];
        Account insertedWho2 = [select id from Account where Name = 'new Alternative2' AND Type = 'Alternative' limit 1];
        //insert products
        List<Product2> cars = DataFactory.createCars('AK',insertedBrand.Id, insertedMan.Id,insertedWho.Id, '19831012', 'jeveuxtesterlacreation', 'Tourism', 
    '199', '19', '15', '77', 'T', 'A', 'B', '69',200.00, 'Summer', 'AUD','testHomologation0', true, true, true, true, true,Date.newInstance(2022, 12, 22),
    '4',Date.newInstance(2022, 12, 25),'6',Date.newInstance(2022, 12, 28),'20',true);
    List<Product2> trucks = DataFactory.createTrucks('TR',insertedBrand.Id, insertedMan.Id,insertedWho.Id, '19831014', 'jeveuxtesterlacreation3', 'truck', 
    '399', '39', '35', '77', 'Z', 'C', 'D', '89',200.00, 'Summer', 'useTest','axisTest',Date.newInstance(2022, 12, 22),
    '6',Date.newInstance(2022, 12, 25),'10',Date.newInstance(2022, 12, 28),'20',true);
        List<Product2> cars2 = DataFactory.createCars('CC',insertedBrand2.Id, insertedMan2.Id,insertedWho2.Id, '19831013', 'jeveuxtesterlacreation2', 'Tourism', 
    '299', '29', '25', '77', 'T', 'A', 'B', '69',220.00, 'Winter', 'AUD','testHomologation0', true, true, true, true, true,Date.newInstance(2022, 12, 22),
    '6',Date.newInstance(2022, 12, 25),'10',Date.newInstance(2022, 12, 28),'20',true);
        cars.addAll(cars2);
        cars.addAll(trucks);
        insert cars;
        //insert attribut set
        // ProductAttributeSet att = DataFactory.createProductAttributeSet();
        // insert att;
        // //query the attribut set
        // ProductAttributeSet attribut = [select id from ProductAttributeSet limit 1];
        System.debug('ak products'+[select id from Product2 where Name LIKE '%AK%' AND Supplier__c != null AND Available_Quantity_1__c != null].size());
        //query the parent product and the variations
        Product2 parentProd = [select id from Product2 where Name = 'AK1' AND Brand__c != null limit 1];
        List<Product2> variations = [select id,Supplier__c,Supplier__r.Type from Product2 where Name LIKE '%AK%' AND Supplier__c != null AND Available_Quantity_1__c != null];
        Product2 parentProd2 = [select id from Product2 where Name = 'CC1' AND Brand__c != null limit 1];
        List<Product2> variations2 = [select id,Supplier__c,Supplier__r.Type from Product2 where Name LIKE '%CC%' AND Supplier__c != null AND Available_Quantity_1__c != null];
        //insert attribut set product
        ProductAttributeSet attSQL = [select id from ProductAttributeSet limit 1];
        System.debug('attribut set'+attSQL);
        List<Product2> elements = new list<Product2>{parentProd};
        List<Product2> elements2 = new list<Product2>{parentProd2};
        List<ProductAttributeSetProduct> attProducts = DataFactory.createProductAttributeSetProduct(attSQL.id,elements);
        List<ProductAttributeSetProduct> attProducts2 = DataFactory.createProductAttributeSetProduct(attSQL.id,elements2);
        attProducts.addAll(attProducts2);
        insert attProducts;
        // List<ProductAttribute> attributes = DataFactory.createProductAttributeSet(parentProd,variations);
        // insert attributes;
        Pricebook2 insertedPB = [select id from Pricebook2 where Name = 'testbook' limit 1];
        variations.addAll(variations2);
        List<PricebookEntry> entries = DataFactory.createStandardEntries(variations,Test.getStandardPricebookId());
        System.debug('std pb :'+Test.getStandardPricebookId());
        insert entries;
        List<PricebookEntry> entries2 = DataFactory.createPriceBookEntries(variations,insertedPB);
        insert entries2;
        
    }
    @isTest
    static void testProductController(){

        List<AggregateResult> prodList = [select Parent__r.Dim1__c from Product2 where Available_Quantity_1__c != '0' AND Parent__r.Dim1__c != null AND Parent__r.RecordType.Name = 'Car' group by Parent__r.Dim1__c];
        System.debug('prodList'+prodList);
        System.debug('prodList'+prodList.size());

        Address_Attributes__c addressAttributes = new Address_Attributes__c(
                Postal_Code__c = '1000'
        );

        insert addressAttributes;

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'QTeam Community Plus User' LIMIT 1 ].Id;

        Account a = new Account(Name = 'Test', Webcare_Id__c = '1234567888889');
        insert a;

        Contact c = new Contact(LastName = 'Test Contact', AccountId = a.Id, Webcare_Id__c = '987654321');
        insert c;

        User customerUser = new User();
        customerUser.Username = 'wcCustomer.email@test.com';
        customerUser.Email = customerUser.Username+ '.webcare';
        customerUser.FirstName = 'Test';
        customerUser.LastName = 'Customer';
        customerUser.Alias = 'test';
        customerUser.contactId = c.Id;
        customerUser.CommunityNickname = 'test';
        customerUser.EmailEncodingKey = 'ISO-8859-1';
        customerUser.LanguageLocaleKey = 'en_US';
        customerUser.LocaleSidKey = 'fr_BE';
        customerUser.TimeZoneSidKey = 'Europe/Paris';
        customerUser.ProfileId = profileId;
        customerUser.IsActive = true;
        customerUser.Type_of_User__c = 'd1';

        insert customerUser;


        List<Map<String,String>> widthOptions = new List<Map<String,String>>();
        system.assertEquals(0, widthOptions.size(), 'la liste des widths est vide');
        List<Map<String,String>> heightOptions = new List<Map<String,String>>();
        system.assertEquals(0, heightOptions.size(), 'la liste des heights est vide');
        List<Map<String,String>> inchesOptions = new List<Map<String,String>>();
        system.assertEquals(0, inchesOptions.size(), 'la liste des inches est vide');
        List<Map<String,String>> capacitiesOptions = new List<Map<String,String>>();
        system.assertEquals(0, capacitiesOptions.size(), 'la liste des capacities est vide');
        List<Map<String,String>> speedsOptions = new List<Map<String,String>>();
        system.assertEquals(0, speedsOptions.size(), 'la liste des speeds est vide');
        List<Map<String,String>> brandsOptions = new List<Map<String,String>>();
        system.assertEquals(0, brandsOptions.size(), 'la liste des brands est vide');
        List<Map<String,String>> fuelOptions = new List<Map<String,String>>();
        system.assertEquals(0, fuelOptions.size(), 'la liste des fuels est vide');
        List<Map<String,String>> gripOptions = new List<Map<String,String>>();
        system.assertEquals(0, gripOptions.size(), 'la liste des grips est vide');
        List<Map<String,String>> noiseOptions = new List<Map<String,String>>();
        system.assertEquals(0, noiseOptions.size(), 'la liste des noises est vide');
        List<Map<String,String>> categoryOptions = new List<Map<String,String>>();
        system.assertEquals(0, categoryOptions.size(), 'la liste des categories est vide');
        List<Map<String,String>> homologationOptions = new List<Map<String,String>>();
        system.assertEquals(0, homologationOptions.size(), 'la liste des homologations est vide');
        List<Map<String,String>> specificationOptions = new List<Map<String,String>>();
        system.assertEquals(0, specificationOptions.size(), 'la liste des specifications est vide');
        List<Map<String,String>> seasonsOptions = new List<Map<String,String>>();
        system.assertEquals(0, seasonsOptions.size(), 'la liste des seasons est vide');
        List<Map<String,String>> useOptions = new List<Map<String,String>>();
        system.assertEquals(0, useOptions.size(), 'la liste des uses est vide');
        List<Map<String,String>> axisOptions = new List<Map<String,String>>();
        system.assertEquals(0, axisOptions.size(), 'la liste des axis est vide');

        Test.startTest();
        User u = [select id,Type_of_User__c,Name,Username,Profile.name from User where Type_of_User__c = 'd1' Limit 1];
        system.runAs(u){
            String userType = ProductSearchController.getUserType(u.Type_of_User__c);
            system.assertEquals('d1', userType, 'c bon pour le user type');
        }
        system.debug('hello, userId = ' +u.Id);
        widthOptions = ProductController.getWidths('Car');
        system.assertEquals(0, widthOptions.size(), 'la liste widths est remplie');
        heightOptions = ProductController.getHeights('Car','199');
        system.assertEquals(1, heightOptions.size(), 'la liste heights est remplie');
        inchesOptions = ProductController.getInches('Car','19','199');
        system.assertEquals(1, inchesOptions.size(), 'la liste des inches est remplie');
        inchesOptions = ProductController.getInches('Car','19','299');
        system.assertEquals(0, inchesOptions.size(), 'la liste des inches n est pas remplie');
        capacitiesOptions = ProductController.getCapacities('Car','19','199','15');
        system.assertEquals(1, capacitiesOptions.size(), 'la liste des capacities est remplie');
        speedsOptions = ProductController.getSpeeds('Car','19','199','15','77');
        system.assertEquals(1, speedsOptions.size(), 'la liste des speeds est remplie');
        Map<String,String> option = new Map<String,String>();
        option.put('label','T');
        option.put('value','T');
        system.assertEquals(option, speedsOptions[0], 'la liste des speeds est bonne');
        brandsOptions = ProductController.getBrands('Car');
        List<String> brands = new List<String>();
        brands.add([SELECT Id FROM Brand__c Limit 1].Id);
        ProductSearchController.saveFavoriteBrands('"test", "test2',customerUser.Id);
        ProductSearchController.getFavoriteBrands(customerUser.Id);
        system.assertEquals(2, brandsOptions.size(), 'la liste des brands est remplie');
        fuelOptions = ProductController.getFuels('Car');
        system.assertEquals(0, fuelOptions.size(), 'la liste des fuels est remplie');
        gripOptions = ProductController.getGrips('Car','A');
        //system.assertEquals(1, gripOptions.size(), 'la liste des grips est remplie');
        noiseOptions = ProductController.getNoises('Car','A','B');
        //system.assertEquals(1, noiseOptions.size(), 'la liste des noises est remplie');
        categoryOptions = ProductController.getCategories();
        //system.assertEquals(1, categoryOptions.size(), 'la liste des categories est remplie');
        homologationOptions = ProductController.getHomologations();
        //system.assertEquals(1, homologationOptions.size(), 'la liste des homologations est remplie');
        specificationOptions = ProductController.getSpecifications();
        //system.assertEquals(1, specificationOptions.size(), 'la liste des specifications est remplie');
        seasonsOptions = ProductController.getSeasons();
        //system.assertEquals(3, seasonsOptions.size(), 'la liste des seasons est remplie');
        useOptions = ProductController.getUses();
        //system.assertEquals(1, useOptions.size(), 'la liste des uses est remplie');
        axisOptions = ProductController.getAxies();
        //system.assertEquals(1, axisOptions.size(), 'la liste des axis est remplie');
        system.debug('use of test class '+ useOptions);
        system.debug('specificationOptions :'+specificationOptions);
        system.debug('categories:'+categoryOptions);
        String s = ProductSearchController.search('Car', '199', null, null, null, null, null, 'OLAB,OLAB2', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        system.debug('car search '+s);
        Test.stopTest();
    }
    @isTest
    static void testProductSearchController(){
        Test.startTest();
        
        ProductSearchController.search('Car', '199', null, null, null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', null, null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', '77', null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', '77', 'T', null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', '77', 'T', null, 'OLAB', 'Summer', null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', '77', 'T', 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        // ProductSearchController.search('Truck', '199', '19', '15', '77', 'T', null, 'OLAB', 'Summer','useTest','axisTest', null, null, null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', null, null, null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', null, null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchController.search('Car', '199', '19', '15', '77', null, 'mich', 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1);
        ProductSearchController.search('Car', null, null, null, null, null, 'mich', 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1);
        ProductSearchController.search('Car', null, null, null, null, null, null, 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1);
        //ProductSearchController.search(recordType, Dim1, Serie, Dim3, capacity, speed, searchTerm, brand, season, use, axis, fuel, grip, noise, category, specification, homologation, runflat, pmsf, seal, sound, elt, offset)

        Product2 parentProd = [select Id, Supplier__r.Name, Supplier__r.Logo_Ext__c, Label__c,Ranking__c, Dimension_Indexed__c, Profile__c,
        Brand_Profile_Text__c, Brand__r.Description_NL__c, Image_Profile__c, Delivery_Date_1__c, Delivery_Date_2__c,Delivery_Date_3__c,Description_FR__c,QR_Eprel__c,
        Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c,Season_Ext__c,Brand_Ext__c,Drvm__c,Speed__c,BEclass__c,REvalue__c,List_Price__c,Grip__c,toLabel(Brand__r.level__c) FROM Product2 where Name = 'AK1' AND Brand__c != null limit 1];
        List<Product2> listofvariations = [select id,Supplier__c,Supplier__r.Type from Product2 where Name = 'AK%' AND Supplier__c != null AND Available_Quantity_1__c != null];
        System.debug('listofvariations'+listofvariations.size());
        System.debug('listofvariations'+listofvariations);
        System.debug('parentProd'+parentProd);
        
        List<PriceBookEntry> variations = [Select Id,
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
        Product2.Parent__r.Brand__r.Description_NL__c
        FROM PriceBookEntry where Product2.Name LIKE '%AK%' AND Product2.Supplier__c != null AND Product2.Available_Quantity_1__c != null];
        system.debug('variations to wrap'+ variations.size());
        system.debug('variations to wrap2'+ variations);
        ProductSearchWrapper.SearchResult searchResult = ProductSearchWrapper.parseSearchResult(parentProd, variations, 1);
        system.debug('searchResult done: ' + searchResult.brandName);

        
        
        
        Test.stopTest();
    }

    @IsTest
    static void testProductSearchControllerPriceDate(){
        Test.startTest();

        ProductSearchControllerPriceDate.search('Car', '199', null, null, null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', null, null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', null, null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', '77', null, null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', '77', 'T', null, 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', '77', 'T', null, 'OLAB', 'Summer', null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', '77', 'T', 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        // ProductSearchController.search('Truck', '199', '19', '15', '77', 'T', null, 'OLAB', 'Summer','useTest','axisTest', null, null, null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1);
        ProductSearchControllerPriceDate.search('Car', '199', null, null, null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', null, null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', null, null, 'mich', 'OLAB', null, null, null, null, null,null,null,null,null,null, null, null, null, 'testHomologation0', null, null, null, null, null, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', '199', '19', '15', '77', null, 'mich', 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', null, null, null, null, null, 'mich', 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1,'Price Ascending');
        ProductSearchControllerPriceDate.search('Car', null, null, null, null, null, null, 'OLAB', 'Summer', 'useTest', 'axisTest', 'A', 'B','69','null','null','null','null', 'null', 'Tourism', 'Audi', 'testHomologation0', true, true, true, true, true, 1,'Date Ascending');
        //ProductSearchController.search(recordType, Dim1, Serie, Dim3, capacity, speed, searchTerm, brand, season, use, axis, fuel, grip, noise, category, specification, homologation, runflat, pmsf, seal, sound, elt, offset)

        Product2 parentProd = [select Id, Supplier__r.Name, Supplier__r.Logo_Ext__c, Label__c,Ranking__c, Dimension_Indexed__c, Profile__c,
                Brand_Profile_Text__c, Brand__r.Description_NL__c, Image_Profile__c, Delivery_Date_1__c, Delivery_Date_2__c,Delivery_Date_3__c,Description_FR__c,QR_Eprel__c,
                Available_Quantity_1__c, Available_Quantity_2__c, Available_Quantity_3__c,Season_Ext__c,Brand_Ext__c,Drvm__c,Speed__c,BEclass__c,REvalue__c,List_Price__c,Grip__c,toLabel(Brand__r.level__c) FROM Product2 where Name = 'AK1' AND Brand__c != null limit 1];
        List<Product2> listofvariations = [select id,Supplier__c,Supplier__r.Type from Product2 where Name = 'AK%' AND Supplier__c != null AND Available_Quantity_1__c != null];
        System.debug('listofvariations'+listofvariations.size());
        System.debug('listofvariations'+listofvariations);
        System.debug('parentProd'+parentProd);

        List<PriceBookEntry> variations = [Select Id,
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
                Product2.Parent__r.Brand__r.Description_NL__c
        FROM PriceBookEntry where Product2.Name LIKE '%AK%' AND Product2.Supplier__c != null AND Product2.Available_Quantity_1__c != null];
        system.debug('variations to wrap'+ variations.size());
        system.debug('variations to wrap2'+ variations);
        ProductSearchWrapper.SearchResult searchResult = ProductSearchWrapper.parseSearchResult(parentProd, variations, 1);
        system.debug('searchResult done: ' + searchResult.brandName);
        ProductSearchWrapperPriceDate.SearchResult searchResult2 = ProductSearchWrapperPriceDate.parseSearchResult(variations[0], 1);
        system.debug('searchResult2 done: ' + searchResult2.brandName);




        Test.stopTest();
    }
}