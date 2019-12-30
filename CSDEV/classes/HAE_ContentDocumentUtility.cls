/**
    Name: HAE_ContentDocumentUtility
    Description: This class is responsible to query the Content Note records.
    Date: 12/12
**/

public with sharing class HAE_ContentDocumentUtility {
    
    public static List<ContentNote> fetchContentNotes(Id parentId){

        Set<Id> contentDocumentIdSet = new Set<Id>();
        List<ContentNote> contentNoteList = New List<ContentNote>();
        Integer contentLimit = Integer.valueof(System.Label.HAE_Content_Note_Limit);

        for(ContentDocumentLink cdl : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: parentId]){
            contentDocumentIdSet.add(cdl.ContentDocumentId);
        }
        

        if(contentDocumentIdSet <> NULL && !contentDocumentIdSet.isEmpty()){
            contentNoteList = [SELECT Id, Title, TextPreview, CreatedBy.Name, LastModifiedDate FROM ContentNote WHERE Id IN: contentDocumentIdSet ORDER BY LastModifiedDate DESC LIMIT: contentLimit];
        }
        
        if(contentNoteList <> NULL && !contentNoteList.isEmpty()){
            return contentNoteList;
        }       

        return null;
    }
}