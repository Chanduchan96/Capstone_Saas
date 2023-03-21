public with sharing class QueryOrderProducts {
    @AuraEnabled(cacheable=true)
    public static string Email_Class(String recordId)
    {
   try {
    EmailTemplate et =[SELECT id,Subject,Body FROM EmailTemplate WHERE Name='Send Customer Email'];
    String orderId=recordId;  
    System.debug(orderId);
    System.debug(et);  
    List<String> Recepiantemails = new List<String>();
 	List<Order> orderObj=[SELECT id,BillToContact.Email FROM Order WHERE Id=:orderId];
    
    
     Recepiantemails.add(orderObj[0].BillToContact.Email);
     Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
     email.setTemplateId(et.id);
     email.setwhatId(orderObj[0].id);
     email.setTargetObjectId(orderObj[0].BillToContactid);
     email.setSubject(et.Subject);
     email.setPlainTextBody(et.Body);
     email.setToaddresses(Recepiantemails);
     System.debug(Recepiantemails);
     Messaging.sendEmailResult[] result = Messaging.sendEmail(new Messaging.singleEmailMessage[] {email});
     System.debug(result); 
        if(result.get(0).isSuccess())
        {
        return 'Success';
        } return 'Error';
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
    
    }
}