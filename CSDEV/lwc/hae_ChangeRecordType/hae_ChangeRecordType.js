/* hae_ChangeRecordType.js */
/* eslint-disable no-console */
import { LightningElement, api, wire, track } from 'lwc';
import CASE_Id from '@salesforce/schema/Case.Id';
import { getRecord } from "lightning/uiRecordApi";
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASE_PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import CASEGROUP_FIELD from '@salesforce/schema/Case.HAE_Case_Group__c';
import CASE_RECORDTYPE_FIELD from '@salesforce/schema/Case.RecordTypeId';
import fetchRecordTypeSettings from '@salesforce/apex/HAE_RecordTypeChangeController.fetchRecordTypeChangeInfo';

import CS_NA from '@salesforce/label/c.HAE_CS_NA';
import CS_OrdersNA from '@salesforce/label/c.HAE_CS_OrdersNA';
import CHANGE_RECORD_TYPE_BTN from '@salesforce/label/c.HAE_Change';
import CHANGE_RECORD_TYPE from '@salesforce/label/c.HAE_Case_Record_Types';
import Customer_Service_Order from '@salesforce/label/c.HAE_Customer_Service_Order';
import Customer_Service_Inquiry from '@salesforce/label/c.HAE_Customer_Service_Inquiry';
import Record_Type_Update_Message from '@salesforce/label/c.HAE_Record_Type_Update_Message';
import Case_Inquiry_To_Order_Priority from '@salesforce/label/c.HAE_Case_Inquiry_To_Order_Priority';



export default class Hae_ChangeRecordType extends NavigationMixin(LightningElement) {
    @api recordId;
    @track recTypeId;
    @track selectedValue;
    @track options = [];
    @track value = '';
    @track disableNxtBtn = true;
    @track activeRecordTypes = [];
    @track currentCaseRecordTypeId;
    @track currentCaseRecordDeveloperName;
    @track caseGroup;
    @track showSpinner = false;
    label = {
        CHANGE_RECORD_TYPE, CHANGE_RECORD_TYPE_BTN, Customer_Service_Inquiry, Customer_Service_Order, CS_NA, CS_OrdersNA, Case_Inquiry_To_Order_Priority, Record_Type_Update_Message
    };
    @wire(getRecord, { recordId: '$recordId', fields: [CASE_RECORDTYPE_FIELD, CASEGROUP_FIELD] })
    getCase({ error, data }) {
        this.showSpinner = true;
        if (data) {
            let result = JSON.parse(JSON.stringify(data));
            this.value = this.recTypeId;
            this.currentCaseRecordTypeId = this.recTypeId;
            this.currentCaseRecordDeveloperName = result.recordTypeInfo.name;
            this.recTypeId = result.fields.RecordTypeId.value;
            this.caseGroup = result.fields.HAE_Case_Group__c.value;
            this.fetchRecordTypeInfo();
            this.showSpinner = false;
        } else if (error) {
            this.showSpinner = false;
            //console.log('error: ', result);
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            // Fire error toast
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }

    fetchRecordTypeInfo() {                                                                             //JS method to fetch record type information from Custom Metadata Types
        this.showSpinner = true;
        fetchRecordTypeSettings({ objectAPIName: 'Case' }).then(result => {
            let optionsValues = [];
            let recTypeMap = result;
            if (recTypeMap) {
                for (let key in recTypeMap) {
                    if (recTypeMap[key]) {
                        optionsValues.push({
                            label: recTypeMap[key],
                            value: key
                        })
                    }
                }
            }
            this.options = optionsValues;
            this.showSpinner = false;
        }).catch(error => {
            this.error = error;
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            // Fire error toast
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.showSpinner = false;
        });
    }

    handleRecordTypeChange(event) {                                                                 //JS method to handle record type change
        let recordTypeId = event.detail.value;
        this.value = recordTypeId;
        if (this.currentCaseRecordTypeId === recordTypeId) {
            this.disableNxtBtn = true;
        }
        else {
            this.disableNxtBtn = false;
        }
    }

    handleUpdateRecordType() {                                                                      //JS method to update the record type for the current record
        this.showSpinner = true;
        let options;
        let nextRecordType;
        const fields = {};
        fields[CASE_RECORDTYPE_FIELD.fieldApiName] = this.value;
        fields[CASE_Id.fieldApiName] = this.recordId;
        options = this.options;
        if (options) {
            for (let op in options) {
                if (options[op].value === this.value) {
                    nextRecordType = options[op].label;
                    break;
                }
            }
        }
        if (this.currentCaseRecordDeveloperName === this.label.Customer_Service_Inquiry && nextRecordType === this.label.Customer_Service_Order) {
            if (this.caseGroup === this.label.CS_NA) {
                fields[CASEGROUP_FIELD.fieldApiName] = this.label.CS_OrdersNA;
            }
            fields[CASE_PRIORITY_FIELD.fieldApiName] = this.label.Case_Inquiry_To_Order_Priority;
        }
        const userRecordInput = { fields };
        updateRecord(userRecordInput)
            .then(() => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Case',
                        actionName: 'view'
                    },
                });
                this.showSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: this.label.Record_Type_Update_Message,
                    variant: 'Success'
                });
                this.showSpinner = false;
                this.dispatchEvent(event);
            })
            .catch(error => {
                let errorMsg;
                errorMsg = JSON.stringify(error.body.message);
                // Fire error toast
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: errorMsg,
                    variant: 'error'
                });
                this.showSpinner = false;
                this.dispatchEvent(event);
            });
    }

}