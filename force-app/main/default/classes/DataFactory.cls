/* created by :
    Abdelhafid Khribech
    on 02/12/2022
*/
public with sharing class DataFactory {
    public DataFactory() {

    }
    // instance of UTIL_METHODS class which help to fill the data
    private static final UTIL_Methods util = new UTIL_Methods();
    //create users
    public class Userr{
        public List<User> createUsers(Integer counter,Id ContactId,Id portalId){
            User obj =new User();
            List<User> objs = new List<User>();
            for(Integer i=0;i<counter;i++){
                obj = (User) util.populateMandatoryField(Constants.OBJ_API_USER, obj, i);
                objs.add(obj);
            }
            return objs;
        }
    }
    //create contact
    public static Contact createContact(Id accountId, String lastName){
        Contact newCon = new Contact();
        newCon.LastName = lastName;
        newCon.AccountId = accountId;
        return newCon;
    }

    // create pricebooks
    public class Pricebook{
        public List<Pricebook2> createPricebooks(Integer counter){
            Pricebook2 obj =new Pricebook2();
            List<Pricebook2> objs = new List<Pricebook2>();
            for(Integer i=0;i<counter;i++){
                obj = (Pricebook2) util.populateMandatoryField(Constants.OBJ_API_PRICEBOOK, obj, i);
                objs.add(obj);
            }
            return objs;
        }
    }

    public static Pricebook2 createStandardPricebook(){
        Pricebook2 obj =new Pricebook2();
        // obj.IsStandard = true;
        obj.Name = 'Standard Price Book';
        obj.IsActive = true;
        return obj;
    }
    //create accounts
    // public class Account{
    //     public List<Account> createAccounts(Integer counter,String accountName,String accountType){
    //         Account obj =new Account();
    //         List<Account> objs = new List<Account>();
    //         for(Integer i=0;i<counter;i++){
    //             obj = (Account) util.populateMandatoryField(Constants.OBJ_API_ACCOUNT, obj, i, 'HafidTest', 'Manufacturer');
    //             objs.add(obj);
    //         }
    //         return objs;
    //     }
    // }
    public static Account createAccount(String accountName, String accountType){
        Account newAcc = new Account();
        newAcc.Name = accountName;
        newAcc.Type = accountType;
        return newAcc;
    }
    public static Brand__c createBrand(String brandName,String description){
        Brand__c newBrand = new Brand__c();
        newBrand.Name = brandName;
        newBrand.Active__c = true;
        newBrand.description_FR__c = description;
        return newBrand;
    }
    public static List<Homologation_Brand__c> createHomologations(Integer counter){
        List<Homologation_Brand__c> homs = new List<Homologation_Brand__c>();
        for(Integer i = 0; i<counter;i++){
            Homologation_Brand__c hom = new Homologation_Brand__c();
            hom.Name = 'testHomologation'+i;
            homs.add(hom);
        }
        return homs;
    }
    public static List<Product2> createCars(String name,Id brandId, Id ManufacturerId,Id WholesalerId, String EANcode, String descriptionFR, String category, 
    String width, String height, String inches, String loadCapacity, String speedIndex, String fuel, String grip, String noise, 
    Decimal listPrice, String season, String oem,String homologation, Boolean runflat, Boolean pmsf, Boolean seal, Boolean sound, Boolean elt,Date date1,
    String quantity1,Date date2,String quantity2,Date date3,String quantity3,Boolean withManufacturer){
        List<Product2> productsList = new List<Product2>();
        Id carRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Car').getRecordTypeId();
        system.debug('test class oem'+ oem);
        Product2 parentProduct = new Product2();
        // parentProduct.ProductClass = 'VariationParent';
        parentProduct.Name = name+'1';
        parentProduct.RecordTypeId = carRecordTypeId;
        parentProduct.Type = 'Base';
        parentProduct.Brand__c = brandId;
        parentProduct.EAN_Code__c = EANcode;
        parentProduct.Description_FR__c = descriptionFR;
        parentProduct.Product_Category__c = category;
        parentProduct.Dim1__c = width;
        parentProduct.Serie__c = height;
        parentProduct.Dim3__c = inches;
        parentProduct.Drvm__c = loadCapacity;
        parentProduct.Speed__c = speedIndex;
        parentProduct.BEclass__c = fuel;
        parentProduct.Grip__c = grip;
        parentProduct.REvalue__c = noise;
        parentProduct.List_Price__c = listPrice;
        parentProduct.Season__c = season;
        parentProduct.Season__c = homologation;
        parentProduct.Fitm__c = oem;
        parentProduct.Rof__c = runflat;
        parentProduct.X3PMSF__c = pmsf;
        parentProduct.Seal__c = seal;
        parentProduct.Sound__c = sound;
        parentProduct.Elt__c = elt;
        system.debug(' : '+ parentProduct);
        productsList.add(parentProduct);
        if (withManufacturer == true) {
            Product2 manProduct = new Product2();
            // manProduct.ProductClass = 'Variation';
            manProduct.Name = name+'2';
            manProduct.RecordTypeId = carRecordTypeId;
            manProduct.Supplier__c = ManufacturerId;
            manProduct.Parent__c = parentProduct.Id;
            manProduct.Available_Quantity_1__c = quantity1;
            manProduct.Available_Quantity_2__c = quantity2;
            manProduct.Available_Quantity_3__c = quantity3;
            manProduct.Delivery_Date_1__c = date1;
            manProduct.Delivery_Date_2__c = date2;
            manProduct.Delivery_Date_3__c = date3;
            system.debug(' : '+ manProduct);
            productsList.add(manProduct);
        }
        Product2 whProduct = new Product2();
        // whProduct.ProductClass = 'Variation';
        whProduct.Name = name+'3';
        whProduct.RecordTypeId = carRecordTypeId;
        whProduct.Supplier__c = WholesalerId;
        whProduct.Parent__c = parentProduct.Id;
        whProduct.Available_Quantity_1__c = quantity1;
        whProduct.Available_Quantity_2__c = quantity2;
        whProduct.Available_Quantity_3__c = quantity3;
        whProduct.Delivery_Date_1__c = date1;
        whProduct.Delivery_Date_2__c = date2;
        whProduct.Delivery_Date_3__c = date3;
        system.debug(' : '+ whProduct);
        productsList.add(whProduct);
        system.debug('size cars : '+ productsList.size());
        system.debug(' cars inserted : '+ productsList);
        system.debug('Fitm__c : '+ProductController.getSpecifications());
        return productsList;

    }

//     public static List<Product2> createMotos(String name,Id brandId, Id ManufacturerId,Id WholesalerId, String EANcode, String descriptionFR, String type, 
//     String width, String height, String inches, String loadCapacity, String speedIndex, String motoSeason, String position, String usage, String rubber,
//     Decimal listPrice, String season, String use, String axis, Date date1,
//     String quantity1,Date date2,String quantity2,Date date3,String quantity3,Boolean withManufacturer){
// List<Product2> productsList = new List<Product2>();
//         Id motoRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Moto').getRecordTypeId();
//         system.debug('test class oem'+ oem);
//         Product2 parentProduct = new Product2();
//         // parentProduct.ProductClass = 'VariationParent';
//         parentProduct.Name = name+'1';
//         parentProduct.RecordTypeId = motoRecordTypeId;
//         parentProduct.Type = 'Base';
//         parentProduct.Brand__c = brandId;
//         parentProduct.EAN_Code__c = EANcode;
//         parentProduct.Description_FR__c = descriptionFR;
//         parentProduct.Article_Type__r.Description_FR__c = type;
//         parentProduct.Dim1__c = width;
//         parentProduct.Serie__c = height;
//         parentProduct.Dim3__c = inches;
//         parentProduct.Drvm__c = loadCapacity;
//         parentProduct.Speed__c = speedIndex;
//         parentProduct.Moto_Season__c = motoSeason;
//         parentProduct.Position__c = position;
//         parentProduct.Usage__c = usage;
//         parentProduct.List_Price__c = listPrice;
//         parentProduct.Rubber_Hardness__c = rubber;
//         // parentProduct.Season__c = homologation;
//         system.debug(' : '+ parentProduct);
//         productsList.add(parentProduct);
//         if (withManufacturer == true) {
//             Product2 manProduct = new Product2();
//             // manProduct.ProductClass = 'Variation';
//             manProduct.Name = name+'2';
//             manProduct.RecordTypeId = motoRecordTypeId;
//             manProduct.Supplier__c = ManufacturerId;
//             manProduct.Parent__c = parentProduct.Id;
//             manProduct.Available_Quantity_1__c = quantity1;
//             manProduct.Available_Quantity_2__c = quantity2;
//             manProduct.Available_Quantity_3__c = quantity3;
//             manProduct.Delivery_Date_1__c = date1;
//             manProduct.Delivery_Date_2__c = date2;
//             manProduct.Delivery_Date_3__c = date3;
//             system.debug(' : '+ manProduct);
//             productsList.add(manProduct);
//         }
//         Product2 whProduct = new Product2();
//         // whProduct.ProductClass = 'Variation';
//         whProduct.Name = name+'3';
//         whProduct.RecordTypeId = motoRecordTypeId;
//         whProduct.Supplier__c = WholesalerId;
//         whProduct.Parent__c = parentProduct.Id;
//         whProduct.Available_Quantity_1__c = quantity1;
//         whProduct.Available_Quantity_2__c = quantity2;
//         whProduct.Available_Quantity_3__c = quantity3;
//         whProduct.Delivery_Date_1__c = date1;
//         whProduct.Delivery_Date_2__c = date2;
//         whProduct.Delivery_Date_3__c = date3;
//         system.debug(' : '+ whProduct);
//         productsList.add(whProduct);
//         return productsList;
//     }

    public static List<Product2> createTrucks(String name,Id brandId, Id ManufacturerId,Id WholesalerId, String EANcode, String descriptionFR, String category, 
    String width, String height, String inches, String loadCapacity, String speedIndex, String fuel, String grip, String noise, 
    Decimal listPrice, String season, String use, String axis, Date date1,
    String quantity1,Date date2,String quantity2,Date date3,String quantity3,Boolean withManufacturer){
        List<Product2> productsList = new List<Product2>();
        Id truckRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Truck').getRecordTypeId();
        Product2 parentProduct = new Product2();
        // parentProduct.ProductClass = 'VariationParent';
        parentProduct.Name = name+'1';
        parentProduct.RecordTypeId = truckRecordTypeId;
        parentProduct.Type = 'Base';
        parentProduct.Brand__c = brandId;
        parentProduct.EAN_Code__c = EANcode;
        parentProduct.Description_FR__c = descriptionFR;
        parentProduct.Product_Category__c = category;
        parentProduct.Dim1__c = width;
        parentProduct.Serie__c = height;
        parentProduct.Dim3__c = inches;
        parentProduct.Drvm__c = loadCapacity;
        parentProduct.Speed__c = speedIndex;
        parentProduct.BEclass__c = fuel;
        parentProduct.Grip__c = grip;
        parentProduct.REvalue__c = noise;
        parentProduct.List_Price__c = listPrice;
        parentProduct.Season__c = season;
        parentProduct.truckappl__c = use;
        parentProduct.truckax__c = axis;
        // parentProduct.Season__c = homologation;
        // parentProduct.Fitm__c = oem;
        // parentProduct.Rof__c = runflat;
        // parentProduct.X3PMSF__c = pmsf;
        // parentProduct.Seal__c = seal;
        // parentProduct.Sound__c = sound;
        // parentProduct.Elt__c = elt;
        productsList.add(parentProduct);
        system.debug('use of truck'+ use);
        
        system.debug('truckapll : '+parentProduct.truckappl__c);
        if (withManufacturer == true) {
            Product2 manProduct = new Product2();
            // manProduct.ProductClass = 'Variation';
            manProduct.Name = name+'2';
            manProduct.RecordTypeId = truckRecordTypeId;
            manProduct.Supplier__c = ManufacturerId;
            manProduct.Parent__c = parentProduct.Id;
            manProduct.Available_Quantity_1__c = quantity1;
            manProduct.Available_Quantity_2__c = quantity2;
            manProduct.Available_Quantity_3__c = quantity3;
            manProduct.Delivery_Date_1__c = date1;
            manProduct.Delivery_Date_2__c = date2;
            manProduct.Delivery_Date_3__c = date3;
            productsList.add(manProduct);
        }
        Product2 whProduct = new Product2();
        // whProduct.ProductClass = 'Variation';
        whProduct.Name = name+'3';
        whProduct.RecordTypeId = truckRecordTypeId;
        whProduct.Supplier__c = WholesalerId;
        whProduct.Parent__c = parentProduct.Id;
        whProduct.Available_Quantity_1__c = quantity1;
        whProduct.Available_Quantity_2__c = quantity2;
        whProduct.Available_Quantity_3__c = quantity3;
        whProduct.Delivery_Date_1__c = date1;
        whProduct.Delivery_Date_2__c = date2;
        whProduct.Delivery_Date_3__c = date3;
        productsList.add(whProduct);
        system.debug('size trucks : '+ productsList.size());
        system.debug(' trucks inserted : '+ productsList);
        system.debug('Use : '+ProductController.getUses());
        return productsList;

    }
    public static List<ProductAttribute> createProductAttribute(Product2 parent, List<Product2> variations){
        List<ProductAttribute> attributes = new List<ProductAttribute>();
        for (Product2 currVar : variations) {
            ProductAttribute pAttibute = new ProductAttribute();
            pAttibute.VariantParentId = parent.Id;
            pAttibute.ProductId = currVar.Id;
            pAttibute.Supplier__c = currVar.Supplier__c;
            attributes.add(pAttibute);
        }
        return attributes;
    }
    public static List<PricebookEntry> createStandardEntries(List<Product2> products,Id standardPricebookId){
        System.debug('pricebooks stand id :'+standardPricebookId);
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for (Product2 currProd : products) {
            PricebookEntry standardEntry = new PricebookEntry();
            standardEntry.IsActive = true;
            standardEntry.UnitPrice = 180;
            standardEntry.Pricebook2ID = standardPricebookId;
            standardEntry.Product2Id = currProd.Id;
            entries.add(standardEntry);
        }
        return entries;
    }
    public static List<PricebookEntry> createPriceBookEntries(List<Product2> products,Pricebook2 pricebook){
        System.debug('pricebooks id :'+pricebook.Id);
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for (Product2 currProd : products) {
            PricebookEntry entry = new PricebookEntry();
            entry.IsActive = true;
            entry.UnitPrice = 150;
            entry.Pricebook2Id = pricebook.Id;
            entry.Product2Id = currProd.Id;
            entries.add(entry);
        }
        return entries;
    }
    public static ProductAttributeSet createProductAttributeSet(){
        ProductAttributeSet att = new ProductAttributeSet();
        return att;
    }
    public static List<ProductAttributeSetProduct> createProductAttributeSetProduct(Id ProductAttributeSetId,List<Product2> products){
        List<ProductAttributeSetProduct> attibuteSets = new List<ProductAttributeSetProduct>();
        for (Product2 currProd : products) {
            ProductAttributeSetProduct p = new ProductAttributeSetProduct();
            p.ProductId = currProd.Id;
            p.ProductAttributeSetId = ProductAttributeSetId;
            attibuteSets.add(p);
        }
        return attibuteSets;
    }
}