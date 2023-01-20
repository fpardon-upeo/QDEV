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
 * Created: 6/12/2022
 * Last Updated: 6/12/2022
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

public class WebCareTransportCost {

    public class Tourism {
        public Integer amount;
        public String price;
        public String priceDistri;
        public String pricePartner;
    }

    public List<Supplier> suppliers;

    public class Supplier {
        public Integer id;
        public String cutoffTime;
        public String deliveryTime;
        public List<Tourism> tourism;
        public List<Tourism> moto;
        public List<Tourism> truck;
    }


    public static WebCareTransportCost parse(String json) {
        return (WebCareTransportCost) System.JSON.deserialize(json, WebCareTransportCost.class);
    }
}