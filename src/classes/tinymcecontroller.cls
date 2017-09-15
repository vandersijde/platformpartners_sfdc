public with sharing class tinymcecontroller {
    public String tinyText {
        get{
            if(tinyText == null){
                tinyText = 'Hello, world!';
            }
            return tinyText;
        }
        set;
    }
}