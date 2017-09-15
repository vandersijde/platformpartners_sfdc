trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        List<Task> newTaskList = new List<Task>();
        
        for(Opportunity oppty:Trigger.new){
            if((Trigger.isInsert || (Trigger.isUpdate && oppty.StageName != Trigger.oldMap.get(oppty.Id).StageName)) && oppty.StageName == 'Closed Won'){
                newTaskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = oppty.Id));
            }            
        }
        
        if(!newTaskList.isEmpty()) insert newTaskList;
    }
}