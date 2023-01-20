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
@IsTest
public class WebCareAuthResponseTest {

    static testMethod void testParse() {
        String json = '{'+
                '    \"accessToken\": \"OEQ2RkJFQjMtMEI2Qi00QTVFLUI2MTgtMkJDODlFMEU5QzA5\",'+
                '    \"refreshToken\": \"NEZCQzM5MTItOEU1OS00QjY1LUFERTgtRjZFOURFMDdEOTE2\"'+
                '}';
        WebCareAuthResponse obj = WebCareAuthResponse.parse(json);
        System.assert(obj != null);
    }
}