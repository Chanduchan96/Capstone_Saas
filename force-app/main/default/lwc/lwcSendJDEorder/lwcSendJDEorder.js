import { LightningElement,api } from 'lwc';
import JDEOrdercallOutNamedCred from '@salesforce/apex/getJDEOrderDetails.JDEOrdercallOutNamedCred';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcSendJDEorder extends LightningElement {
    @api recordId;
    // recordId='8010T0000004ZEyQAM';
    
      handleClick(){
         
          console.log('in handle Click');
          console.log(this.recordId);
          JDEOrdercallOutNamedCred({OrderId:this.recordId})
          .then((result) => {
             
              const evt = new ShowToastEvent({
                  title: 'Toast Success',
                  message: 'sucessfully Sent JDE Order',
                  variant: 'Success',
              });
              console.log('On Toast Success');
              this.dispatchEvent(evt);
          })
       
          .catch((error) => {
              const evt = new ShowToastEvent({
                  title: 'Toast Error',
                  message: 'Error while JDE Order request',
                  variant: 'Error',
              
              });
              this.dispatchEvent(evt);
              console.log('On Error Promise');
          });
      }
  }