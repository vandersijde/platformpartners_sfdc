global with sharing class UploadFilesController {

    @RemoteAction
    global static void AttachToChatter(String fileName, String body){
        try{
            FeedItem f = new FeedItem();
            f.ContentData = Blob.valueOf(body);
            f.ContentFileName = fileName;
            f.ParentId = UserInfo.getUserId();
            insert f;
            system.debug('#### chatter feed created: ' + f);
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }

}