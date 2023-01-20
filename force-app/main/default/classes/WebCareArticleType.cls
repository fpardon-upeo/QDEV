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
 * Created: 17/11/2022
 * Last Updated: 17/11/2022
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

public class WebCareArticleType {

    public class Type {
        public String abbreviation {get;set;}
        public String tav {get;set;}
        public String code {get;set;}
        public String group_Z {get;set;} // in json: group
        public Intrastat intrastat {get;set;}
        public String class_Z {get;set;} // in json: class
        public String rdc {get;set;}
        public String selection {get;set;}
        public String split1 {get;set;}
        public String split2 {get;set;}
        public String split3 {get;set;}
        public Boolean noStockvalue {get;set;}
        public List<Description> description {get;set;}


        public Type(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'abbreviation') {
                            abbreviation = parser.getText();
                        } else if (text == 'tav') {
                            tav = parser.getText();
                        } else if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'group') {
                            group_Z = parser.getText();
                        } else if (text == 'intrastat') {
                            intrastat = new Intrastat(parser);
                        } else if (text == 'class') {
                            class_Z = parser.getText();
                        } else if (text == 'rdc') {
                            rdc = parser.getText();
                        } else if (text == 'selection') {
                            selection = parser.getText();
                        } else if (text == 'split1') {
                            split1 = parser.getText();
                        } else if (text == 'split2') {
                            split2 = parser.getText();
                        } else if (text == 'split3') {
                            split3 = parser.getText();
                        } else if (text == 'noStockvalue') {
                            noStockvalue = parser.getBooleanValue();
                        } else if (text == 'description') {
                            description = arrayOfDescription(parser);
                        }
                        else {
                            System.debug(LoggingLevel.WARN, 'Types consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Intrastat_Z {
        public String code {get;set;}
        public Decimal weight {get;set;}

        public Intrastat_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'weight') {
                            weight = parser.getDecimalValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Intrastat_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public List<Type> types {get;set;}

    public WebCareArticleType(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'types') {
                        types = arrayOfTypes(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'WebCareArticleType consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public class Intrastat {
        public String code {get;set;}
        public Integer weight {get;set;}

        public Intrastat(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'weight') {
                            if(parser.readValueAs(Integer.class) == null) {
                                weight = 0;
                            } else {
                                weight = parser.getIntegerValue();
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Intrastat consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }


    public static WebCareArticleType parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WebCareArticleType(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }


    public class Description {
        public String lang {get;set;}
        public String value {get;set;}

        public Description(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'lang') {
                            lang = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Description consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    private static List<Description> arrayOfDescription(System.JSONParser p) {
        List<Description> res = new List<Description>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Description(p));
        }
        return res;
    }


    private static List<Type> arrayOfTypes(System.JSONParser p) {
        List<Type> res = new List<Type>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Type(p));
        }
        return res;
    }
}