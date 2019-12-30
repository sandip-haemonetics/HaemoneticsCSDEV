/* hae_ProductView.js */
/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import REGION_FIELD from '@salesforce/schema/Case.HAE_Region2__c';
import REGION_FIELD_PL from '@salesforce/schema/Case.HAE_Region__c';
import fetchProducts from '@salesforce/apex/HAE_SearchProducts.fetchProductsByName';
import fetchFieldSetInfo from '@salesforce/apex/HAE_FieldSetUtils.getFieldsOfFieldSet';

import Search from '@salesforce/label/c.HAE_Search';
import Product from '@salesforce/label/c.HAE_Product_Label';
import Error_Message from '@salesforce/label/c.HAE_Error_Message';
import No_Records from '@salesforce/label/c.HAE_No_Records_found';
import Product_Attribute_API_Name from '@salesforce/label/c.HAE_Product_Attribute_API_Name';
import Product_Attribute_FieldSet_ProductView from '@salesforce/label/c.HAE_Product_Attribute_FieldSet_ProductView';
import HAE_LWC_ERROR from '@salesforce/label/c.HAE_LWC_ERROR';

export default class Hae_ProductView extends LightningElement {
    @api recordId = '$recordId';
    @track caseRegion;
    @track caseRegion_PL;
    @track fields = [];
    @track isLoading = false;
    @track btnEnable = false;
    @track productAttributeIds = [];
    @track queryTerm;
    @track displayResults = false;
    @track noRecords = false;
    label = { Product, No_Records, Search, Product_Attribute_API_Name, Product_Attribute_FieldSet_ProductView, Error_Message };

    //Wire method to fetch Case Region and fieldset associated with it.
    @wire(getRecord, { recordId: '$recordId', fields: [REGION_FIELD,REGION_FIELD_PL] })
    getCase({ error, data }) {
        this.isLoading = true;
        if (data) {
            this.caseRegion = data.fields.HAE_Region2__c.value;
            this.caseRegion_PL = data.fields.HAE_Region__c.value;
            console.log(this.caseRegion+'---'+this.caseRegion_PL);
            if (this.caseRegion !== null || this.caseRegion_PL ) {
                this.fetchFieldSet();
            }
            else {
                this.btnEnable = false;
            }
            this.isLoading = false;
        }
        else if (error) {
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: HAE_LWC_ERROR,
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        }
    }
    
    //Method to fetch fields API name based on the fieldset supplied to it.
    fetchFieldSet() {
        var fields = [];
        fetchFieldSetInfo({ objectAPIName: this.label.Product_Attribute_API_Name, fieldSetName: this.label.Product_Attribute_FieldSet_ProductView }).then(result => {
            if (result) {
                result.forEach(function (element) {
                    fields.push(element.APIName);
                });
                if (fields.lenght === 0) {
                    this.btnEnable = false;
                }
                else {
                    this.fields = fields;
                }
            }
        }).catch(error => {
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            const toastEvent = new ShowToastEvent({
                title: HAE_LWC_ERROR,
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        });
    }

    //Method to handle keypress events
    handleKeyUp(event) {
        this.queryTerm = event.target.value;
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = event.target.value;
            if(this.caseRegion !== null){
                this.handleSearch(event);
            }
        }
        else {
            this.queryTerm = event.target.value;
        }
        if (this.noRecords) {
            this.noRecords = false;
        }
        if ((this.queryTerm === null || this.queryTerm === "" || this.queryTerm === undefined || this.queryTerm.trim().length === 0))  {           
            this.displayResults = false;
            this.btnEnable = false;
            this.productAttributeIds = [];
        }
        else{
            if(this.caseRegion === null && this.caseRegion_PL === null){
                this.btnEnable = false; 
            }
            else{
                this.btnEnable = true; 
            }
        }
    }
    
    //For future Implementation
    handleMainSectionToggle(event) {
    }

    //Method to fetch Product Attribute records based on the search key and case region.
    handleSearch(event) {
        var productAttributes = [];
        this.isLoading = true;
        fetchProducts({ productName: this.queryTerm, caseRegion: this.caseRegion }).then(result => {
            if (result) {
                if (result.length === 0) {                 
                    this.displayResults = false;
                    this.noRecords = true;
                }
                else {
                    result.forEach(function (element) {
                        productAttributes.push(element.Id);
                    });
                    if (productAttributes) {
                        this.productAttributeIds = productAttributes;
                        this.displayResults = true;
                        this.noRecords = false;
                    }
                }
                this.isLoading = false;
            }
        }).catch(error => {
            this.error = error;
            let errorMsg;
            errorMsg = JSON.stringify(error.body.message);
            // Fire error toast
            const toastEvent = new ShowToastEvent({
                title: HAE_LWC_ERROR,
                message: errorMsg,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.isLoading = false;
        });
    }

    //Method to error events.
    handleErrorAction() {
        const toastEvent = new ShowToastEvent({
            title: HAE_LWC_ERROR,
            message: this.label.Error_Message,
            variant: 'error'
        });
        this.dispatchEvent(toastEvent);
    }
}