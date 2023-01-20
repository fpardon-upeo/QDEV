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

public class WebCareCustomer {

    public class Modules {
        public Boolean tourism;
        public Boolean moto;
        public Boolean truck;
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

    public class Client {
        public String id;
        public String name;
        public String vatnumberCountry;
        public String vatnumber;
    }


    public List<Customer> customers;

    public class Customer {
        public String id;
        public String email;
        public Client client;
        public String partnerType;
        public String priceGrid;
        public Modules modules;
        public Boolean blockedCustomer;
        public String amountOverdue;
        public String openAmount;
        public String creditLimit;
        public MainAddress mainAddress;
        public String firstname;
        public String surname;
        public List<SupplierCodes> supplierCodes;
        public List<String> nonActiveSuppliers;
    }

    public static WebCareCustomer parseMultipleUsers(String json) {
        String jsonReplacedString = json.replace('"number":', '"number_z":');
        System.debug('jsonReplacedString: ' + jsonReplacedString);
        system.debug(System.JSON.deserialize(jsonReplacedString, WebCareCustomer.class));
        return (WebCareCustomer) System.JSON.deserialize(jsonReplacedString, WebCareCustomer.class);
    }

    public static WebCareCustomer.Customer parseSingleUser(String json) {
        String jsonReplacedString = json.replace('"number":', '"number_z":');
        return (WebCareCustomer.Customer) System.JSON.deserialize(jsonReplacedString, WebCareCustomer.Customer.class);
    }



}