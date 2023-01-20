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
 * Created: 16/11/2022
 * Last Updated: 16/11/2022
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

public class WebCareAuthResponse {

    public String accessToken;
    public String refreshToken;


    public static WebCareAuthResponse parse(String json) {
        return (WebCareAuthResponse) System.JSON.deserialize(json, WebCareAuthResponse.class);
    }
}