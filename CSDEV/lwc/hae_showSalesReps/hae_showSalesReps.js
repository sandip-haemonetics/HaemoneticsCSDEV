import { LightningElement, api, wire } from 'lwc';
import {updateRecord} from 'lightning/uiRecordApi';
import getSalesReps from "@salesforce/apex/HAE_ShowAccountTeamMembers.getSalesReps";
import SALES_REP_ID from '@salesforce/schema/Case.HAE_Sales_Rep__c';
import CASE_RECORD_Id from '@salesforce/schema/Case.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import HAE_LWC_SUCCESS from '@salesforce/label/c.HAE_LWC_SUCCESS';
import HAE_LWC_ERROR from '@salesforce/label/c.HAE_LWC_ERROR';
import HAE_LWC_SUCCESS_MSG from '@salesforce/label/c.HAE_LWC_Common_Success_Message';
import HAE_LWC_SAVE from '@salesforce/label/c.HAE_LWC_SAVE';

export default class Hae_showSalesReps extends LightningElement {

    @api recordId;
    selectedUserId;
    saveButtonLabel = HAE_LWC_SAVE;

    @wire(getSalesReps,{recordId: '$recordId'}) accountTeamMemberObj;

    handleChange(event) {
        this.selectedUserId = event.detail.value;
        console.log('value-->'+this.selectedUserId);
    }

    updateCase(){
        const FIELDS = {};
        FIELDS[SALES_REP_ID.fieldApiName] = this.selectedUserId;
        FIELDS[CASE_RECORD_Id.fieldApiName] = this.recordId;
        const caseRecord  = {fields: FIELDS};
        updateRecord(caseRecord)
            .then(()=> {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: HAE_LWC_SUCCESS,
                        message: HAE_LWC_SUCCESS_MSG,
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: HAE_LWC_ERROR,
                        message: error.body.message,//error.body.output.fieldErrors,
                        variant: 'error',
                    }),
                );  
            });
    }

    

}