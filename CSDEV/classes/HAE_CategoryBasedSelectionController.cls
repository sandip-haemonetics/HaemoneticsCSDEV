/**
* Name			:	HAE_CategoryBasedSelectionController
* Date			:	12/4/2019
* Description	:	This is the controller class for Hae_CategoryBasedSelection LWC.	
*/
public class HAE_CategoryBasedSelectionController {
    /**
	* Name			:	getFieldSetByCategory
	* Param			: 	String: caseCategory,String: caseRecordTypeName
	* Return		:   List of HAE_FieldSetUtils.FieldsOfFieldSet
	* Description	:	This method returns list of HAE_FieldSetUtils.FieldsOfFieldSet based on the parameters supplied to it.
	*/ 
    @AuraEnabled(cacheable=true)
    public static List<HAE_FieldSetUtils.FieldsOfFieldSet> getFieldSetByCategory(String caseCategory, String caseRecordTypeName) {
    	List<String> selectedFieldSetList = new List<String>(); 
        List<HAE_FieldSetUtils.FieldsOfFieldSet> FieldSetInfo = new List<HAE_FieldSetUtils.FieldsOfFieldSet>();
        if(caseCategory != NULL && caseRecordTypeName!= NULL){
            for(HAE_AdditionalInfromationMapping__mdt additionalInfo : [SELECT Id, HAE_Case_Category__c,HAE_Case_Record_Type_Name__c,HAE_FieldSet_API_Name__c FROM HAE_AdditionalInfromationMapping__mdt WHERE HAE_Active__c = true AND HAE_Case_Category__c= :caseCategory AND HAE_Case_Record_Type_Name__c= :caseRecordTypeName]){
                selectedFieldSetList.add(additionalInfo.HAE_FieldSet_API_Name__c);
            }    
            if(!selectedFieldSetList.isEmpty()){
                FieldSetInfo = HAE_FieldSetUtils.getFieldsOfFieldSet(HAE_ApexUtil.HAE_CASE,selectedFieldSetList[0]);    
            }
        }
        return FieldSetInfo;
    } 
}