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
 * Created: 29/11/2022
 * Last Updated: 29/11/2022
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

public class WebCareStockPrice {

    public class Orders {
        public String supplier;
        public String deliveryAddressId;
        public String transport;
        public List<Articles> articles;
        public String orderWebCare;
        public String delnoteWebcare;
    }

    public String customer;
    public String basket;
    public List<Orders> orders;

    public class Articles {
        public String id;
        public String price;
        public String quantity;
        public String deliveryTime;
        public Boolean changed;
    }


    public static WebCareStockPrice parse(String json) {
        return (WebCareStockPrice) System.JSON.deserialize(json, WebCareStockPrice.class);
    }
}