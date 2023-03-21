public with sharing class createOrder {
   @AuraEnabled
   public static String CreateOrderRecord(String recordId){
    try {
        String caseId=recordId;
        System.debug(caseId);
        List<Case> CaseRecord=[SELECT id,AccountId,Reason FROM Case WHERE id=:caseId AND Reason='Sales Order' ];
        List<Contact> BillToContact=[SELECT id,Address_Type__c ,MailingStreet, MailingCity, MailingState, MailingPostalCode,
        MailingCountry FROM Contact WHERE AccountId=:CaseRecord[0].AccountId AND Address_Type__c='Bill To' ];
        List<Contact> ShipToContact=[SELECT id,Address_Type__c, OtherStreet, OtherCity, OtherState, OtherPostalCode,
        OtherCountry FROM Contact WHERE AccountId=:CaseRecord[0].AccountId AND Address_Type__c='Ship To' ];


     
        List<Order> orderList=new List<Order>();
        for(Case cr:CaseRecord){
            Order od=new Order();
            
            od.AccountId=cr.AccountId;
            od.Type=cr.Reason;
            od.Status='Draft';
            if(!BillToContact.isEmpty())
            {
            od.BillingStreet=BillToContact[0].MailingStreet;
            od.BillingCity=BillToContact[0].MailingCity;
            od.BillingState=BillToContact[0].MailingState;
            od.BillingPostalCode=BillToContact[0].MailingPostalCode;
            od.BillingCountry=BillToContact[0].MailingCountry;
            od.BillToContactId=BillToContact[0].id;
            }
            if(!ShipToContact.isEmpty())
            {
            od.ShippingStreet=ShipToContact[0].OtherStreet;
            od.ShippingCity=ShipToContact[0].OtherCity;
            od.ShippingState=ShipToContact[0].OtherState;
            od.ShippingPostalCode=ShipToContact[0].OtherPostalCode;
            od.ShippingCountry=ShipToContact[0].OtherCountry;
            od.ShipToContactId=ShipToContact[0].id;
            }
            od.Case__c=cr.id;
            od.EffectiveDate=system.today();
            od.RecordTypeId='0120T000000DHH7QAO';
            orderList.add(od);
        }
        if(insertDML(orderList)){
        return 'Success';
       
    }   
      
        
   return 'Error';
 } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
   }


   public static boolean insertDML(List<Order> newOrder)
{
    if(!newOrder.isEmpty())
    {
        insert newOrder;
        return true;
    }return false;
}
}