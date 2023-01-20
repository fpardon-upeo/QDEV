/**
 * Created by fpardon on 30/11/2022.
 */


public class WebCareDeliveryAddress{
    public String id;	//
    public String alias;	//
    public String street;	//
    public String houseNumber;	//
    public String zip;	//
    public String city;	//
    public String country;	//
    public String userId;	//
    public String email;	//
    public static WebCareDeliveryAddress parse(String json){
        String jsonReplacedString = json.replace('"number":', '"houseNumber":');
        return (WebCareDeliveryAddress) System.JSON.deserialize(jsonReplacedString, WebCareDeliveryAddress.class);
    }
}