public with sharing class GenerateInvoiceExtension {

    private Id invoiceId;
    private Invoice__c invoiceRec;
    
    public GenerateInvoiceExtension(ApexPages.StandardController controller) {
        invoiceId = controller.getId();
        invoiceRec = (Invoice__c) controller.getRecord();
    }

    public Map<Id, Map<String, String>> amountMap{
        get{
            if(amountMap == null){
                amountMap = new Map<Id, Map<String, String>>();
                List<Invoice_Line__c> ilList = [SELECT Id, Amount_excl_VAT__c, Rate__c FROM Invoice_Line__c WHERE Invoice__c = :invoiceId];
                for(Invoice_Line__c il:ilList){
                    amountMap.put(il.Id, new Map<String, String>{'Rate__c'=>GetAmountString(il.Rate__c), 'Amount_excl_VAT__c'=>GetAmountString(il.Amount_excl_VAT__c)});
                }
                amountMap.put(invoiceId, new Map<String, String>{'VAT__c'=>GetAmountString(InvoiceRec.VAT__c), 'Amount_incl_VAT__c'=>GetAmountString(InvoiceRec.Amount_incl_VAT__c), 'Amount_excl_VAT__c'=>GetAmountString(InvoiceRec.Amount_excl_VAT__c)});
            }
            return amountMap;
        }
        set;
    }
    
    private String GetAmountString(Decimal amount){
        String retVal = '';
        String amnt = String.valueOf(amount).replace('.', ',');
        
        if(amnt.length() > 6) amnt = amnt.left(amnt.length() - 6) + '.' + amnt.right(6);
                
        return amnt;
    }
}