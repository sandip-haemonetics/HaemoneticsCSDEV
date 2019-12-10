/* hae_ProductView.js */
/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchProducts from '@salesforce/apex/HAE_SearchProducts.fetchProductsByName';

import Search from '@salesforce/label/c.HAE_Search';
import Product from '@salesforce/label/c.HAE_Product_Label';
import No_Records from '@salesforce/label/c.HAE_No_Records_found';
import Product_Status from '@salesforce/label/c.HAE_Product_Status';
import Product_Case_Weight from '@salesforce/label/c.HAE_Product_Case_Weight';
import Product_Business_Unit from '@salesforce/label/c.HAE_Product_Business_Unit';
import Product_Substitute_Item from '@salesforce/label/c.HAE_Product_Substitute_Item';
import Product_Replacement_Item from '@salesforce/label/c.HAE_Product_Replacement_Item';
import Product_Case_Width_inches from '@salesforce/label/c.HAE_Product_Case_Width_inches';
import Product_Case_Length_inches from '@salesforce/label/c.HAE_Product_Case_Length_inches';
import Product_Case_Height_inches from '@salesforce/label/c.HAE_Product_Case_Height_inches';
import Product_Availability_Status from '@salesforce/label/c.HAE_Product_Availability_Status';
import Product_Estimated_Date_of_Recovery from '@salesforce/label/c.HAE_Product_Estimated_Date_of_Recovery';

export default class Hae_ProductView extends LightningElement {
    @track queryTerm;
    @track productList = [];
    @track productListSize = 0;
    @track displayResults = false;
    @track noRecords = false;
    @track activeMainSections = [];
    @track isLoading = false;
    label = { Product, No_Records, Search, Product_Status, Product_Business_Unit, Product_Substitute_Item, Product_Replacement_Item, Product_Availability_Status, Product_Estimated_Date_of_Recovery,
    Product_Case_Weight, Product_Case_Height_inches, Product_Case_Width_inches, Product_Case_Length_inches};
    handleKeyUp(event) {
        this.queryTerm = event.target.value;
        console.log(event.target.value);
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            this.queryTerm = event.target.value;
            this.handleSearch(event);
        }
        else {
            this.queryTerm = event.target.value;
        }
        if (this.noRecords) {
            this.noRecords = false;
        }
        if (this.queryTerm === null || this.queryTerm === "" || this.queryTerm === undefined) {
            this.productList = [];
            this.productListSize = 0;
            this.displayResults = false;
        }
    }
    handleMainSectionToggle(event) {
        const openSections = event.detail.openSections;

    }
    handleSearch(event) {
        this.isLoading = true;
        fetchProducts({ productName: this.queryTerm }).then(result => {
            if (result) {
                if (result.length === 0) {
                    this.productList = [];
                    this.productListSize = 0;
                    this.displayResults = false;
                    this.noRecords = true;
                }
                else {
                    this.productList = result;
                    this.productListSize = result.length;
                    this.displayResults = true;
                    this.noRecords = false;
                }
                this.isLoading = false;
            }
        }).catch(error => {
            this.isLoading = false;
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
        });
    }
}