public with sharing class ReadWordDocController {

    public Blob fileBody {get;set;}
    public String fileName {get;set;}
    public String fileExtension {get;set;}
    public String fileToString {get;set;}

    public PageReference LoadAndShowDoc(){
        ContentVersion cv = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId = '06920000001zqy7'];
        if(cv != null){
            fileToString =  EncodingUtil.base64Encode(cv.VersionData);
        }else{
            fileToString = '### NULL ###';
        }
        
        /*fileToString = String.valueOf(fileBody);
        fileToString.replace('{!Account.Name}', 'Platform Partners B.V.');
        fileToString.replace('{!Contact.Name}', 'Richard van der Sijde');
        
        FeedItem f = new FeedItem();
        f.ContentData = Blob.valueOf(fileToString);
        f.ContentFileName = 'output.docx';
        f.ParentId = UserInfo.getUserId();
        insert f;
        
        f = null;
        fileToString = null;
        fileBody = null;
        fileName = null;
        fileExtension = null;*/
        return null;
    }
}