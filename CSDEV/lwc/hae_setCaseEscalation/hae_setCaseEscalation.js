/* eslint-disable no-console */
import { LightningElement,api, track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASE_Escalated from '@salesforce/schema/Case.IsEscalated';
import CASE_Id from '@salesforce/schema/Case.Id';
import {getRecord, updateRecord} from 'lightning/uiRecordApi';
import CAPTURE_ESCALATE_DATE from '@salesforce/schema/Case.HAE_Capture_Escalate_Date__c';
import HAE_LWC_ESCALATE from '@salesforce/label/c.HAE_LWC_ESCALATE';
import HAE_LWC_ERROR from '@salesforce/label/c.HAE_LWC_ERROR';
import HAE_LWC_SUCCESS_MSG from '@salesforce/label/c.HAE_LWC_Common_Success_Message';
import HAE_LWC_SUCCESS from '@salesforce/label/c.HAE_LWC_SUCCESS';

const FIELDS = [CASE_Escalated];

export default class hae_setCaseEscalation extends LightningElement {
    fieldValue;
    setTrue = true;
    @api recordId;
    @track isDisabled=false;
    escalateButtonLabel = HAE_LWC_ESCALATE;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    case({error, data
    }){
        if (data){
            let storeIsEscalated = data.fields.IsEscalated.value;
            if(storeIsEscalated){
                this.isDisabled=true;
            }
        }
        else if(error){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: HAE_LWC_ERROR,
                    message: error.message.body,
                    variant: 'error',
                }),
            );
        }
    } 

    handleEscalate(){
        const fields = {};
        let dateobj = new Date();
        let dateIsoStr = dateobj.toISOString(); 
        console.log('datetime###'+dateIsoStr);
        fields[CASE_Escalated.fieldApiName] = this.setTrue;
        fields[CASE_Id.fieldApiName] = this.recordId;
        fields[CAPTURE_ESCALATE_DATE.fieldApiName]= dateIsoStr;
        const caseRecord  = {fields}; 

        updateRecord(caseRecord)
        .then(() => {
            this.isDisabled=true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: HAE_LWC_SUCCESS,
                    message: HAE_LWC_SUCCESS_MSG,
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            //this.isDisabled=false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: HAE_LWC_ERROR,
                    message: error.message.body,
                    variant: 'error',
                }),
            );
        });
    }      
}