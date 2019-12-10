/* Hae_CategoryBasedSelection.js*/
/* eslint-disable no-console */
import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import CATEGORY_FIELD from '@salesforce/schema/Case.Category__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASE_RECORDTYPE_FIELD from '@salesforce/schema/Case.RecordTypeId';
import Error_Message from '@salesforce/label/c.HAE_Error_Message';
import Additional_Fields from '@salesforce/label/c.HAE_Additional_Fields';
import fetchFieldSet from '@salesforce/apex/HAE_CategoryBasedSelectionController.getFieldSetByCategory';


export default class Hae_CategoryBasedSelection extends LightningElement {
    @api recordId = '$recordId';
    @track fields = [];
    @track recordTypeId;
    @track caseCategory;
    @track recordTypeName;
    @track isLoading = true;
    @track isEditable = true;
    @track isCmpVisible = false;
    @track isBtnDisabled = false;
    label = { Additional_Fields,Error_Message };

    @wire(getRecord, { recordId: '$recordId', fields: [CASE_RECORDTYPE_FIELD, CATEGORY_FIELD] })
    getCase({ error, data }) {
        this.isLoading = true;
        if (data) {
            this.caseCategory = data.fields.Category__c.value;
            this.recordTypeName = data.recordTypeInfo.name;
            this.recordTypeId = data.recordTypeInfo.recordTypeId;
            this.fetchFieldSet();
            this.isLoading = false;
        }
        else if (error) {
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        }
    }
    fetchFieldSet() {
        fetchFieldSet({ caseCategory: this.caseCategory, caseRecordTypeName: this.recordTypeName }).then(result => {
            this.fields = result;
            if (this.fields.length === 0) {
                this.isCmpVisible = false;
            }
            else {
                this.isCmpVisible = true;
            }
            this.isLoading = false;
        }).catch(error => {
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        });
    }
    handleFormSubmittedAction() {
        this.isBtnDisabled = false;
    }
    handleEditAction() {
        this.isLoading = true;
    }
    handleSuccessAction() {
        if (this.isEditable === true) {
            this.isEditable = false;
        }
        else {
            this.isEditable = true;
        }
        this.isBtnDisabled = false;
    }
    handleErrorAction() {
        const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: this.label.Error_Message,
            variant: 'error'
        });
        this.dispatchEvent(toastEvent);
    }
    handleSubmitAction() {
        var fields = this.template.querySelectorAll('lightning-input-field');
        var errorFound = false;
        this.isLoading = true;
        this.isBtnDisabled = true;        
        if (fields) {
            fields.forEach((element) => {
                if (element.reportValidity() === false) {
                    errorFound = true;                                     
                }
            });
        }
        if(errorFound){
            this.isLoading = false;
            this.isBtnDisabled = false;   
        }
    }
}