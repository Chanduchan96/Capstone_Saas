trigger CreateOderTrigger on Order (before insert, after update) {
    if(trigger.isBefore && trigger.isInsert){
        
        for(Order InsertOrder : trigger.new)
        {
            List<Order> existingOrder=[SELECT id from Order WHERE Case__c=:InsertOrder.Case__c];
            System.debug(existingOrder);
            
            if(!existingOrder.isEmpty())
            {
                System.debug('in Error Loop');
                InsertOrder.addError('Order already created');
            }
        }
    }

    //if(trigger.isUpdate == true && trigger.isAfter == true){
        //OrderProductsClone.Clone(Trigger.New);
    //}

}