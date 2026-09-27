trigger FlightTrigger on Flight__c (after update) {
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        FlightTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}