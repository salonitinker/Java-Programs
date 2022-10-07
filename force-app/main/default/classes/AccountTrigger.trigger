trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert) {}
        
        if (Trigger.isUpdate) {
            //AccountTriggerEmailTesting.method(Trigger.new, Trigger.Old, Trigger.newMap, Trigger.oldMap);
            AccountTriggerHandler.onAfterUpdate (Trigger.new, Trigger.Old, Trigger.newMap, Trigger.oldMap);
        }
        
        if (Trigger.isDelete) {}
        
        if (Trigger.isUndelete) {}
        
    }
}