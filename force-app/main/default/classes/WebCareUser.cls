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
 * Created: 22/11/2022
 * Last Updated: 22/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
Description:

Change Log:

Dependencies:

*/

public class WebCareUser {

    public class Modules {
        public String tourism;
        public String moto;
        public string truck;
    }

    public class MainAddress {
        public String street;
        public String number_z;
        public String city;
        public String country;
        public String zip;
    }

    public class SupplierCodes {
        public String supplier;
        public String shipTo;
        public string orderTo;
    }

    public class Customer {
        public String id;
        public String email;
        public String clientId;
        public String partnerType;
        public String priceGrid;
        public Modules modules;
        public Boolean blockedCustomer;
        public Integer amountOverdue;
        public Integer openAmount;
        public Integer creditLimit;
        public MainAddress mainAddress;
        public String firstname;
        public String surname;
        public List<SupplierCodes> supplierCodes;
    }

    public static WebCareUser parseMultipleUsers(String json) {
        String jsonReplacedString = json.replace('"number":', '"number_z":');
        return (WebCareUser) System.JSON.deserialize(jsonReplacedString, WebCareUser.class);
    }

    public static WebCareUser.Customer parseSingleUser(String json) {
        String jsonReplacedString = json.replace('"number":', '"number_z":');
        return (WebCareUser.Customer) System.JSON.deserialize(jsonReplacedString, WebCareUser.Customer.class);
    }



}