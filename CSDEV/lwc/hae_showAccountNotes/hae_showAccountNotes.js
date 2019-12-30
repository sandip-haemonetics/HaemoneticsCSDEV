/*hae_showAccountNotes.js*/
import { LightningElement, api, wire } from 'lwc';
import getContentNotes from "@salesforce/apex/HAE_ShowAccountNotesController.getContentNotes";

export default class Hae_showAccountNotes extends LightningElement  {

        @api recordId;
        @api objectApiName;
        @wire(getContentNotes, {linkedRecordId:'$recordId', sObjectAPiName: '$objectApiName'}) contentNotes;

          
}