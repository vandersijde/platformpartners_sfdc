trigger AccountAddressTrigger on Account (before insert, before update) {

    if(Trigger.isBefore && Trigger.isUpdate || Trigger.isInsert){
        for(Account acc:Trigger.new){
            if(acc.Match_Billing_Address__c == true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
}