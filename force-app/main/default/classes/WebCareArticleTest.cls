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
public class WebCareArticleTest {

    static testMethod void testParse() {
        String json = '{'+
                '    \"articles\": ['+
                '        {'+
                '            \"id\": \"100782\",'+
                '            \"reference\": \"\",'+
                '            \"ean\": \"\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"125 R 15 X OLDTIMER 68S TL\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"125 R 15 68S X OLDTIMER TL\"'+
                '                }'+
                '            ],'+
                '            \"brand\": \"MI\",'+
                '            \"type\": \"TO\",'+
                '            \"vat\": \"21\",'+
                '            \"ecotax\": \"800704\",'+
                '            \"dim1\": \"125\",'+
                '            \"dim2\": \"\",'+
                '            \"series\": \"\",'+
                '            \"category\": \"R\",'+
                '            \"dim3\": \"15\",'+
                '            \"profile\": \"X\",'+
                '            \"application\": \"\",'+
                '            \"xlrf\": \"\",'+
                '            \"rof\": false,'+
                '            \"specialDesignation\": \"OLDTIMER\",'+
                '            \"loadbalancing\": \"68\",'+
                '            \"speed\": \"S\",'+
                '            \"specification\": \"TL\",'+
                '            \"BEclass\": \"\",'+
                '            \"grip\": \"\",'+
                '            \"REvalue\": \"\",'+
                '            \"REclass\": \"\",'+
                '            \"commercial\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"\"'+
                '                }'+
                '            ],'+
                '            \"qr\": ['+
                '                {'+
                '                    \"type\": \"eprel\",'+
                '                    \"value\": \"\"'+
                '                },'+
                '                {'+
                '                    \"type\": \"supplier\",'+
                '                    \"value\": \"\"'+
                '                }'+
                '            ],'+
                '            \"ranking\": 0'+
                '        },'+
                '        {'+
                '            \"id\": \"101174\",'+
                '            \"reference\": \"MI136016\",'+
                '            \"ean\": \"3528701360164\",'+
                '            \"description\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"215/65 R 15 104T AGILIS 51 SNOWICE m+s 3pmsf TL\"'+
                '                }'+
                '            ],'+
                '            \"brand\": \"MI\",'+
                '            \"type\": \"CTMS\",'+
                '            \"vat\": \"21\",'+
                '            \"ecotax\": \"811135\",'+
                '            \"dim1\": \"215\",'+
                '            \"dim2\": \"\",'+
                '            \"series\": \"65\",'+
                '            \"category\": \"R\",'+
                '            \"dim3\": \"15\",'+
                '            \"profile\": \"AGILIS 51 SNOWICE\",'+
                '            \"application\": \"\",'+
                '            \"xlrf\": \"\",'+
                '            \"rof\": false,'+
                '            \"specialDesignation\": \"\",'+
                '            \"loadbalancing\": \"104\",'+
                '            \"speed\": \"T\",'+
                '            \"specification\": \"TL\",'+
                '            \"BEclass\": \"D\",'+
                '            \"grip\": \"A\",'+
                '            \"REvalue\": \"71\",'+
                '            \"REclass\": \"B\",'+
                '            \"commercial\": ['+
                '                {'+
                '                    \"lang\": \"nl\",'+
                '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                '                },'+
                '                {'+
                '                    \"lang\": \"fr\",'+
                '                    \"value\": \"AGILIS 51 SNOW-ICE m+s 3pmsf\"'+
                '                }'+
                '            ],'+
                '            \"qr\": ['+
                '                {'+
                '                    \"type\": \"eprel\",'+
                '                    \"value\": \"https://eprel.ec.europa.eu/qr/408944\"'+
                '                },'+
                '                {'+
                '                    \"type\": \"supplier\",'+
                '                    \"value\": \"https://www.tyrelabelling.eu/EU/2020-740/en/136016_fcs_en.pdf\"'+
                '                }'+
                '            ],'+
                '            \"ranking\": 0'+
                '        }'+
                '    ]'+
                '}';
        WebCareArticle obj = WebCareArticle.parseMultipleArticles(json);
        System.assert(obj != null);
    }
}