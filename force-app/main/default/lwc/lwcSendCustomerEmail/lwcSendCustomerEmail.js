import { LightningElement,api } from 'lwc';
import Email_Class from '@salesforce/apex/QueryOrderProducts.Email_Class';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LwcSendCustomerEmail extends LightningElement {
    @api recordId;
  // recordId='8010T0000004ZEyQAM';
    handleClick(){
        console.log('in handle Click');
        console.log(this.recordId);
        Email_Class({recordId:this.recordId})
        .then((result) => {
            if(result=='Success'){
            const evt = new ShowToastEvent({
                title: 'Toast Success',
                message: 'Sent Email sucessfully',
                variant: 'Success',
            });
            console.log('On Toast Success');
            this.dispatchEvent(evt);
        }else if(result=='Error'){
            const evt = new ShowToastEvent({
                title: 'Toast Error',
                message: 'Error while sending Email',
                variant: 'Error',
            
            });
            this.dispatchEvent(evt);
            console.log('On Toast Error');
        }

        })
        .catch((error) => {
            const evt = new ShowToastEvent({
                title: 'Toast Error',
                message: 'Error while sending Email',
                variant: 'Error',
            
            });
            this.dispatchEvent(evt);
            console.log('On Error Promise');
        });
    }
}