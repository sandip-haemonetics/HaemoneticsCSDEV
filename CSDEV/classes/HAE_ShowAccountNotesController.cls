/**
    Name: HAE_ShowAccountNotesController
    Description: This class is responsible to show the Account Notes in the Account & Case record page.
    Date: 12/12
**/

public with sharing class HAE_ShowAccountNotesController {
    
    @AuraEnabled(cacheable = true)
    public static List<ContentNote> getContentNotes(Id linkedRecordId, String sObjectAPiName){
        if(sObjectAPiName == 'Account')
            return HAE_ContentDocumentUtility.fetchContentNotes(linkedRecordId);
        else if(sObjectAPiName == 'Case'){
            Case caseObj = [SELECT Id, HAE_Bill_To_Account__c FROM Case WHERE Id =: linkedRecordId];
            if(caseObj.HAE_Bill_To_Account__c <> NULL)
                return HAE_ContentDocumentUtility.fetchContentNotes(caseObj.HAE_Bill_To_Account__c);
            
            return null;
        }

        return null;
    }
}