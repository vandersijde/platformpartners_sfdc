public class GenerateVoucherOverviewExt {

    public Id projectId {get;set;}
    
    public GenerateVoucherOverviewExt(ApexPages.StandardController contr){
        projectId = contr.getId();
    }
    
    public List<Timereport__c> relatedTimeReportList{
        get{
            if(relatedTimeReportList == null){
                relatedTimeReportList = [SELECT Id, Date__c, Total_time__c, Description__c FROM Timereport__c WHERE Project__c = :projectId ORDER BY Date__c asc];
            }
            return relatedTimeReportList;
        }
        set;
    }
}