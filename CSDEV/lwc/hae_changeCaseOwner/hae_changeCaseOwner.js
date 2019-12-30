/*hae_changeCaseOwner.js*/
import { LightningElement, api, wire } from 'lwc';
import {getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import CASE_OWNER_ID from '@salesforce/schema/Case.OwnerId';
import CASE_RECORD_Id from '@salesforce/schema/Case.Id';
import CASE_STATUS from '@salesforce/schema/Case.Status';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from '@salesforce/user/Id';
import getGroupMembers from "@salesforce/apex/HAE_CaseQueueMemberSelectionController.getGroupMembers";
import CASE_CLOSED_STATUS from '@salesforce/label/c.HAE_Closed_Case_Status';
import HAE_LWC_SUCCESS from '@salesforce/label/c.HAE_LWC_SUCCESS';
import HAE_LWC_ERROR from '@salesforce/label/c.HAE_LWC_ERROR';
import HAE_LWC_SUCCESS_MSG from '@salesforce/label/c.HAE_LWC_Common_Success_Message';
import HAE_LWC_SAVE from '@salesforce/label/c.HAE_LWC_SAVE';

export default class HAE_changeCaseOwner extends LightningElement {

    @api recordId;
    userId = userId;
    selectedUserId;
    saveButtonLabel = HAE_LWC_SAVE;

    @wire(getRecord,{recordId: '$recordId', fields: CASE_STATUS}) caseObj;
    
    @wire(getGroupMembers, {recordId:'$recordId', loggedinUserId: '$userId'}) users;

    get disableButton()
    {
        if(getFieldValue(this.caseObj.data, CASE_STATUS) === CASE_CLOSED_STATUS)
            return true;
        
        return false;
    }

    handleChange(event) {
        this.selectedUserId = event.detail.value;
    }

    updateCase(){
        const FIELDS = {};
        FIELDS[CASE_OWNER_ID.fieldApiName] = this.selectedUserId;
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