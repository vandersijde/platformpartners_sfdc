/** File Name: batchReviewArticles
    * Description: This batch class contains methods to automate article review process
    * Copyright : Shell
    * @author : Kishore Neelapu
    * Modification Log ===============================================================
   **/
 
global class PublishReviewBatchApex implements Database.Batchable<sObject> {
    
    public PublishReviewBatchApex(){}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Entered Start');
        //Map<String,DateforArticleReview__c> DateforArticleReviewMap = DateforArticleReview__c.getAll();
        Integer articleReviewDuration = 0;
        //if(!DateforArticleReviewMap.isEmpty())
        //articleReviewDuration=Integer.ValueOf(DateforArticleReviewMap.get('Article Review Duration').Article_Review_Duration__c);
        Date reviewDate = System.Today();
        if(articleReviewDuration!=null)
        reviewDate=reviewDate.addDays(-articleReviewDuration);
 
        String query = 'SELECT id,Title, UrlName, KnowledgeArticleId, OwnerId FROM KnowledgeArticleVersion WHERE publishStatus=\'Online\''+ 'AND language =\'en_US\'' +'and IsLatestVersion=true and DAY_ONLY(LastPublishedDate)<=:reviewDate';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<KnowledgeArticleVersion> scope) {
        System.debug('Entered Execute');
 
        for(KnowledgeArticleVersion ka:scope)
            {
                         System.debug('Entered For');
                         String articleId = ka.KnowledgeArticleId ;
                         String id = KbManagement.PublishingService.editOnlineArticle (articleId, true);
                         String assigneeId = ka.ownerId;
                         String instructions = 'Please review this draft article';
                         Date dToday = System.Today()+90;
                         Datetime dueDate = Datetime.newInstanceGmt(dToday.year(), dToday.month(),dToday.day());
                         KbManagement.PublishingService.assignDraftArticleTask(articleId, assigneeId, instructions,dueDate,true);
            }
     }  
 
    global void finish(Database.BatchableContext BC) {
    }
}