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

public class WebCareArticle {

    public class Qr {
        public String type;
        public String value;
    }

    public class Description {
        public String lang;
        public String value;
    }

    public class EcoTaxDescription {
        public String lang;
        public String value;
    }

    public List<Article> articles;
    public Integer count;

    public class Article {
        public String id;
        public String reference;
        public String ean;
        public List<Description> description;
        public String brand;
        public String type;
        public String vat;
        public String ecotax;
        public String dim1;
        public String dim2;
        public String series;
        public String category;
        public String dim3;
        public String profile;
        public String application;
        public String xlrf;
        public String rof;
        public String specialDesignation;
        public String loadbalancing;
        public String speed;
        public String specification;
        public String BEclass;
        public String grip;
        public String REvalue;
        public String REclass;
        public List<Description> commercial;
        public List<EcoTaxDescription> ecotaxdescription;
        public List<Qr> qr;
        public Integer ranking;
        public Integer rankingdist;
        public String pmsf;
        public String seal;
        public String sound;
        public String elt;
        public String fitm;
        public String truckax;
        public String truckappl;

    }




    public static WebCareArticle parseMultipleArticles(String json) {
        return (WebCareArticle) System.JSON.deserialize(json, WebCareArticle.class);
    }

    public static WebCareArticle.Article parseSingleArticle(String json) {
        return (WebCareArticle.Article) System.JSON.deserialize(json, WebCareArticle.Article.class);
    }
}