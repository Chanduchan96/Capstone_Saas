import { LightningElement, api } from 'lwc';
import CreateOrderRecord from '@salesforce/apex/createOrder.CreateOrderRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LwcCreateNewOrder extends LightningElement {
    
  
    @api recordId;
    /*
    connectedCallback()
    {
        this.CreateOrderRecordonLoad();
    }
    */
    handleClick(){
        CreateOrderRecord({recordId:this.recordId})
        .then((result) => {
            if(result=='Success'){
            const evt = new ShowToastEvent({
                title: 'Toast Success',
                message: 'Created Order sucessfully',
                variant: 'Success',
            });
            console.log('On Toast Success');
            this.dispatchEvent(evt);
        }else if(result=='Error'){
            const evt = new ShowToastEvent({
                title: 'Toast Error',
                message: 'Error while creating Order Record - Case Reason must be sales Order to create new order',
                variant: 'Error',
            
            });
            this.dispatchEvent(evt);
            console.log('On Toast Error');
        }

        })
        .catch((error) => {
            const evt = new ShowToastEvent({
                title: 'Toast Error',
                message: 'Error while creating Order Record - Order Already Created',
                variant: 'Error',
            
            });
            this.dispatchEvent(evt);
            console.log('On Error Promise');
        });
      
        

    }
}