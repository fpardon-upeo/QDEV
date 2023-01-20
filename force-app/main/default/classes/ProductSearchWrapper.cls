/**
 * Created by fpardon on 30/11/2022.
 */

public class ProductSearchWrapper {

    public class SearchResult {
        public integer index;
        public String id;
        public String productId;
        public String season;
        public String supplier;
        public String supplierLogoName;
        public String brandName;
        public String category;
        public String brandLogo;
        public String profile;
        public String dimension;
        public String loadFactor;
        public String speedRating;
        public String brandProfile;
        public String distributionDiscount;
        public String label;
        public String img;
        public String fuel;  
        public String grip;
        public String noise;
        public String QReprelLink;
        public Date deliveryDate;
        public Double quantity;
        public Double orderQuantity;
        public Double salesPrice;
        public Double listPrice;
        public Boolean showLine;
        public Boolean showButton;
        public Boolean buttonState;
        public Integer totalRecords;
        public List<SearchResult> wholesalers;
        public List<SearchResult> manufacturers;
    }

    public static SearchResult parseSearchResult(Product2 mainProd, List<PricebookEntry> childProds, Integer index){

        User curUser = [SELECT Id, Type_of_User__c FROM User WHERE Id = :UserInfo.getUserId()];
        // system.debug('curUser: ' + curUser);
        String userType = curUser.Type_of_User__c;
        // system.debug('user type from Product Search Wrapper: ' + userType);

        SearchResult result = new SearchResult();

        //First create the first row data
        result.id = mainProd.Id;
        result.index = index;
        result.season = mainProd.Season_Ext__c;
        result.brandLogo = mainProd.Brand_Ext__c;
        result.category = mainProd.Brand__r.level__c;
        result.loadFactor = mainProd.Drvm__c;
        result.speedRating = mainProd.Speed__c;
        result.productId = childProds[0].Product2Id;
        result.supplier = childProds[0].Product2.Supplier__r.Name;
        result.supplierLogoName = childProds[0].Product2.Supplier__r.Logo_Ext__c;
        result.brandName = mainProd.Brand__r.description_NL__c;
        result.profile = mainProd.Profile__c;
        result.QReprelLink = mainProd.QR_Eprel__c;
        result.distributionDiscount = String.valueOf(childProds[0].Distribution_Discount__c);
        result.dimension = mainProd.Description_FR__c;
        result.img = mainProd.Image_Profile__c;
        result.brandProfile = mainProd.Brand_Profile_Text__c;
        result.label = mainProd.Label__c;
        result.fuel = mainProd.BEclass__c;
        result.grip = mainProd.Grip__c;
        result.noise = mainProd.REvalue__c + ' db';
        result.deliveryDate = childProds[0].Product2.Delivery_Date_1__c;
        result.quantity = parseQuantity(childProds[0].Product2.Available_Quantity_1__c);
        if(result.quantity >= 2){
            result.orderQuantity = 2;
        } else {
            result.orderQuantity = result.quantity;
        }
        result.salesPrice = childProds[0].UnitPrice;
        result.listPrice = mainProd.List_Price__c;
        //Add a row to the wholesaler list for Deliver_Date_2
        result.wholesalers = new List<SearchResult>();
        integer subIndex = 0;
        if(parseQuantity(childProds[0].Product2.Available_Quantity_2__c) > 0){
            SearchResult wholesalerLine1 = new SearchResult();
            wholesalerLine1.id = String.valueOf(childProds[0].Product2.Delivery_Date_2__c) + mainProd.Id;
            wholesalerLine1.index = subIndex;
            wholesalerLine1.productId = childProds[0].Product2Id;
            wholesalerLine1.deliveryDate = childProds[0].Product2.Delivery_Date_2__c;
            wholesalerLine1.quantity = parseQuantity(childProds[0].Product2.Available_Quantity_2__c);
            if(wholesalerLine1.quantity >= 2){
                wholesalerLine1.orderQuantity = 2;
            } else {
                wholesalerLine1.orderQuantity = wholesalerLine1.quantity;
            }
            wholesalerLine1.salesPrice = childProds[0].UnitPrice;
            wholesalerLine1.distributionDiscount = String.valueOf(childProds[0].Distribution_Discount__c);
            wholesalerLine1.listPrice = mainProd.List_Price__c;
            wholesalerLine1.showLine = showLine(result.quantity);
            wholesalerLine1.showButton = showLine(result.quantity);
            wholesalerLine1.buttonState = false;
            result.wholesalers.add(wholesalerLine1);
            subIndex++;
        }
        //Add a row to the wholesaler list for Deliver_Date_2
        if(parseQuantity(childProds[0].Product2.Available_Quantity_3__c) > 0){
            SearchResult wholesalerLine2 = new SearchResult();
            wholesalerLine2.id = String.valueOf(childProds[0].Product2.Delivery_Date_2__c) + mainProd.Id;
            wholesalerLine2.index = subIndex;
            wholesalerLine2.productId = childProds[0].Product2Id;
            wholesalerLine2.deliveryDate = childProds[0].Product2.Delivery_Date_3__c;
            wholesalerLine2.quantity = parseQuantity(childProds[0].Product2.Available_Quantity_3__c);
            if(wholesalerLine2.quantity >= 2){
                wholesalerLine2.orderQuantity = 2;
            } else {
                wholesalerLine2.orderQuantity = wholesalerLine2.quantity;
            }
            wholesalerLine2.salesPrice = childProds[0].UnitPrice;
            wholesalerLine2.distributionDiscount = String.valueOf(childProds[0].Distribution_Discount__c);
            wholesalerLine2.listPrice = mainProd.List_Price__c;
            wholesalerLine2.showLine = false;
            wholesalerLine2.showButton = false;
            wholesalerLine2.buttonState = false;
            result.wholesalers.add(wholesalerLine2);
        }

        if(result.wholesalers.size() == 1 ) {
            result.wholesalers[0].showButton = false;
            result.wholesalers[0].buttonState = false;
        }

        //Then loop through the rest of the child products to create the manufacturer rows
        result.manufacturers = new List<SearchResult>();
        for(Integer i = 1; i < childProds.size(); i++){
            if(parseQuantity(childProds[i].Product2.Available_Quantity_1__c) > 0){
                SearchResult manufacturerLine = new SearchResult();
                manufacturerLine.id = childProds[i].Product2.Id+ String.valueOf(i);
                manufacturerLine.index = i-1;
                manufacturerLine.productId = childProds[i].Product2Id;
                manufacturerLine.supplier = childProds[i].Product2.Supplier__r.Name;
                manufacturerLine.supplierLogoName = childProds[i].Product2.Supplier__r.Logo_Ext__c;
                manufacturerLine.deliveryDate = childProds[i].Product2.Delivery_Date_1__c;
                manufacturerLine.distributionDiscount = String.valueOf(childProds[i].Distribution_Discount__c);
                manufacturerLine.quantity = parseQuantity(childProds[i].Product2.Available_Quantity_1__c);
                if(manufacturerLine.quantity >= 2){
                    manufacturerLine.orderQuantity = 2;
                } else {
                    manufacturerLine.orderQuantity = manufacturerLine.quantity;
                }
                manufacturerLine.salesPrice = childProds[i].UnitPrice;
                manufacturerLine.listPrice = mainProd.List_Price__c;
                manufacturerLine.buttonState = false;
                result.manufacturers.add(manufacturerLine);
                if(i == 1){
                    System.debug('i = 1');
                    manufacturerLine.showLine = true;
                    if(childProds.size() > 0){
                        System.debug('childProds.size() > 0');
                        manufacturerLine.showButton = true;
                    }
                } else {
                    manufacturerLine.showLine = false;
                    manufacturerLine.showButton = false;

                }
            }
        }

        if(result.manufacturers.size() == 1 ) {
            result.manufacturers[0].showButton = false;
        }

        return result;

    }

    public static double parseQuantity(String quantity){
        double result = 0;

        if(quantity != null && quantity != ''){
            if(quantity.contains('>')){
                Integer.valueOf(quantity.substringAfter('>').trim());
            }else{
                result = Double.valueOf(quantity.trim());
            }
        }
        return result;
    }

    public static boolean showLine(Double quantity){
        return quantity < 8;
    }


}