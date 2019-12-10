/* eslint-disable no-unused-vars */
/* eslint-disable no-console */


import { LightningElement, api, wire, track } from 'lwc';
import CASE_Id from '@salesforce/schema/Case.Id';
import { updateRecord } from 'lightning/uiRecordApi';
import { getRecord, getRecordUi } from "lightning/uiRecordApi";
import CASE_RECORDTYPE_FIELD from '@salesforce/schema/Case.RecordTypeId';
import fetchRecordTypeSettings from '@salesforce/apex/HAE_RecordTypeChangeController.fetchRecordTypeChangeInfo';
import { NavigationMixin } from 'lightning/navigation';
import CASEGROUP_FIELD from '@salesforce/schema/Case.HAE_Case_Group__c';



export default class HaeChangeRecordType extends NavigationMixin(LightningElement) {
    @api caseId;
    @api recordId;
    @track recTypeId;
    @track selectedValue;
    @track options = [];
    @track value = '';
    @track disableNxtBtn = true;
    @track activeRecordTypes = [];
    @track currentCaseRecordTypeId;
    @track currentCaseRecordName;
    @track caseGroup;

    @wire(getRecord, { recordId: '$recordId', fields: [CASE_RECORDTYPE_FIELD,CASEGROUP_FIELD] })
    getCase({ error, data }) {
        if (data) {
            let result = JSON.parse(JSON.stringify(data));
            console.log(result);
            this.value = this.recTypeId;
            this.currentCaseRecordTypeId = this.recTypeId;
            this.currentCaseRecordName = result.recordTypeInfo.name;
            this.recTypeId = result.fields.RecordTypeId.value;
            this.caseGroup = result.fields.HAE_Case_Group__c.value;
            console.log(this.caseGroup);
            //console.log('Case Record Id : ' + this.caseId);
            //console.log('Case Record Type : ' + this.recTypeId);
            //console.log('Case Record Type Name : ' + result.recordTypeInfo.name);
            this.fetchRecordTypeInfo();
        } else if (error) {
            let result = JSON.parse(JSON.stringify(error));
            console.log('error: ', result);
        }
    }

    fetchRecordTypeInfo() {
        fetchRecordTypeSettings().then(result => {
            let optionsValues = [];
            let recTypeMap = result;
            for (let key in recTypeMap) {
                if (recTypeMap[key]) {
                    optionsValues.push({
                        label: recTypeMap[key],
                        value: key
                    })
                }
            }
            this.options = optionsValues;
        }).catch(error => {
                this.error = error;
                console.log('ERROR ' + JSON.stringify(error));
            });
    }

    handleRecordTypeChange(event) { 
        let recordTypeId = event.detail.value;
        this.value = recordTypeId;
        if (this.currentCaseRecordTypeId === recordTypeId) {
            this.disableNxtBtn = true;
        }
        else {
            this.disableNxtBtn = false;
        }
    }

    handleUpdateRecordType(event) {
        let options;
        let nextRecordType;
        const fields = {};
        fields[CASE_RECORDTYPE_FIELD.fieldApiName] = this.value;
        fields[CASE_Id.fieldApiName] = this.recordId;
        options = this.options;


        console.log(JSON.stringify(event.detail));
        console.log(JSON.stringify(this.options));
        if (options) {
            for (let op in options) {
                if (options[op].value === this.value) {
                    nextRecordType = options[op].label;
                    break;
                }
            }
        }
        console.log('nextRecordType ' + nextRecordType);
        if (this.currentCaseRecordName === 'Customer Service: Inquiry' && nextRecordType === 'Customer Service: Order') {
            console.log('Inquiry to Order');
            if (this.caseGroup === 'CS NA') {
                console.log('CS NA');
                fields[CASEGROUP_FIELD.fieldApiName] = 'CS OrdersNA';
            }       
        }

        console.log(this.value);
        console.log(this.currentCaseRecordName);
        console.log(this.caseGroup);
        const userRecordInput = { fields };
        updateRecord(userRecordInput)
            .then(() => {
                console.log('success');
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Case',
                        actionName: 'view'
                    },
                });

            })
            .catch(error => {
                console.log('error ' + JSON.stringify(error));
            });
            
    }
    
}