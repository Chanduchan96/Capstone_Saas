trigger AccountTrigger on Account (after update,before update) {
    
    if(trigger.isAfter && trigger.isupdate)
    {
        AccountTriggerHandler handler=new AccountTriggerHandler();
        handler.myTrigger(Trigger.new);
        handler.createCaseTrigger(Trigger.new,Trigger.oldMap);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        AccountTriggerHandler handler=new AccountTriggerHandler();
        handler.myVerificationTrigger(Trigger.new,Trigger.oldMap);
    }
}