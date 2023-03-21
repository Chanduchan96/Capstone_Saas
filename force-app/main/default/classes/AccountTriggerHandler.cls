public with sharing class AccountTriggerHandler {
    /* Platfrom Event Trigger Handler */
    public void myTrigger(List<Account> newAccount ){
        //Create Instance of Platform Event
        Account_Verification__e accEvent = new Account_Verification__e();
         List<Account_Verification__e> verificationList=new List<Account_Verification__e>();
         //check if mandatory fields are filled & assign values to the platform event fields
        for(Account acc:newAccount){
            if(acc.Status__c=='Verification Initiated'){
                if(acc.Name != null && acc.Phone != null && acc.BillingCity!=null && acc.ShippingCity !=null
                  && acc.Site !=null)
                {
                    
                    accEvent.Account_Name__c=acc.Name;
                    accEvent.Account_Site__c=acc.Site;
                    accEvent.Billing_City__c=acc.BillingCity;
                    accEvent.Billing_Country__c=acc.BillingCountry;
                    accEvent.Billing_State_Province__c=acc.BillingState;
                    accEvent.Billing_Street__c=acc.BillingStreet;
                    accEvent.Billing_Zip_Postal_Code__c=acc.BillingPostalCode;
                    accEvent.Shipping_City__c=acc.ShippingCity;
                    accEvent.Shipping_Country__c=acc.ShippingCountry;
                    accEvent.Shipping_State_Province__c=acc.ShippingState;
                    accEvent.Shipping_Street__c=acc.ShippingStreet;
                    accEvent.Shipping_Zip_Postal_Code__c=acc.ShippingPostalCode;
                    accEvent.Phone__c=acc.Phone;
                    verificationList.add(accEvent);
                    
                }
            }
        }
        
         
        //Publishing to Event Bus and save in Database.saveResult
        List<Database.SaveResult> results=EventBus.publish(verificationList);
        
        for(Database.SaveResult sr:results){
            if(sr.isSuccess()){
                System.debug('Succesfully publiched Event');
                
            }else{
                for (Database.Error err:sr.getErrors())
                 System.debug('Error Returned::'+err.getStatusCode());
		}
        }
     
        
	}
    
    public void myVerificationTrigger(List<Account> newAccount, Map<Id,Account> oldAccount)
    {
       
        RecordType Customer = [SELECT id FROM RecordType WHERE Name ='Customer Account' AND SobjectType='Account'];
    
        for(Account acc:newAccount){
            Account oldAcc=new Account();
            oldAcc=oldAccount.get(acc.id);
            if(acc.Status__c == 'Verification Completed' && oldAcc.Status__c=='Verification Initiated')
            {
            	acc.RecordTypeId=Customer.id;
               
            }
            
        }
   
        
    }
    
    public void createCaseTrigger(List<Account> newAccount, Map<Id,Account> oldAccount)
    {
        List<Case> newCase=new List<Case>();
        for(Account acc:newAccount)
        {
           
            Account accOld = new Account();
            accOld=oldAccount.get(acc.id);
            Case cs=new Case();
            if(acc.Status__c=='Verification Completed' && accOld.Status__c == 'Verification Initiated')
            {
                
                cs.AccountId=acc.id;
                cs.Origin='Internal';
                cs.Reason='Sales Order';
                cs.Date_Time_Opened__c=System.today();
                cs.Severity__c='High';
                cs.Status='New';
                cs.Subject='New Customer Order';
                if(acc.OwnerId=='0050T000002lQrD')
                {
                    cs.OwnerId='0050T000002lQrX';
				}
                else if(acc.Owner.Title=='KAM- Melbourne')
                {
                     cs.OwnerId='3D00G0T000002qvK8';
                }
                else if(acc.Owner.Title=='KAM-Sydney')
                {
                     cs.OwnerId='3D00G0T000002qvJt';
                }
                else if(acc.Owner.Title=='KAM-Brisbane')
                {
                    cs.OwnerId='3D00G0T000002qvJy';
                }
                else
                {
                   cs.OwnerId='0055i000004QDth';
                }
               newCase.add(cs);
                System.debug('New Created Case::'+newCase);
                
            }
            
            
            
        }
        
        if(!newCase.isEmpty())
        {
            insert newCase;
              System.debug(' Created Case');
        }
    }
}