public with sharing class previewArticleDocController {

    public PageReference previewDoc(){
        PageReference pr = new PageReference('https://c.eu0.content.force.com/servlet/fileField?id=0BE20000000L5Sq');
        pr.setRedirect(true);
        return pr;
    }
}