public class WebCareBrand {

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

    public class Brand {
        public String abbreviation {get;set;}
        public String abbreviationRenta {get;set;}
        public List<Description> description {get;set;}
        public String class_Z {get;set;} // in json: class
        public Integer ranking {get;set;}
        public String level {get;set;}
        public Boolean active {get;set;}

        public Brand(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'abbreviation') {
                            abbreviation = parser.getText();
                        } else if (text == 'abbreviationRenta') {
                            abbreviationRenta = parser.getText();
                        } else if (text == 'description') {
                            description = arrayOfDescription(parser);
                        } else if (text == 'class') {
                            class_Z = parser.getText();
                        } else if (text == 'ranking') {
                            ranking = parser.getIntegerValue();
                        } else if (text == 'level') {
                            level = parser.getText();
                        } else if (text == 'active') {
                            active = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Brands consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public List<Brand> brands {get;set;}

    public WebCareBrand(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'brands') {
                        brands = arrayOfBrands(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'WebCareBrand consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }


    public static WebCareBrand parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new WebCareBrand(parser);
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




    private static List<Description> arrayOfDescription(System.JSONParser p) {
        List<Description> res = new List<Description>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Description(p));
        }
        return res;
    }




    private static List<Brand> arrayOfBrands(System.JSONParser p) {
        List<Brand> res = new List<Brand>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Brand(p));
        }
        return res;
    }



}