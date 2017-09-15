trigger OrderTrigger on Order__c (after update) {

    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            //Get all changed orders to totally invoiced
            Set<Id> orderIdSet = new Set<Id>();
            for(Order__c order:Trigger.new){
                if(order.Status__c == 'Totally invoiced' && order.Status__c != Trigger.oldMap.get(order.Id).Status__c) orderIdSet.add(order.Id);
            }
        
            //Get all order lines with ready to invoice
            List<Order_line__c> orderLineList = [SELECT Status__c FROM Order_line__c WHERE Order__c IN :orderIdSet AND Status__c = 'Ready to invoice'];
            if(!orderLineList.isEmpty()){    
                for(Order_line__c orderLine:orderLineList){
                    orderLine.Status__c = 'Invoiced';
                }
                update orderLineList;
            }
        }
    }
}