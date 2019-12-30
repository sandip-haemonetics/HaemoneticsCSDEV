/**
    @name:HAE_RecordTypeChangeController 
    @description:This is the controller class for HaeChangeRecordType LWC	
    @date:11/7/2019
*/
public class HAE_RecordTypeChangeController {    
    /**
	    @name:fetchRecordTypeChangeInfo
	    @param: String: ObjectAPI name
	    @return:List of HAE_Record_Type_Change_Settings__mdt
	    @description:This method returns list of HAE_Record_Type_Change_Settings__mdt
	*/      
    @AuraEnabled(cacheable=true)
    public static Map<String,String> fetchRecordTypeChangeInfo(String objectAPIName){        
        List<String> activeRecordTypes = new List<String>();      
        Map<String,String> mapofCaseRecordTypeIdandName = new Map<String,String>();
        for(HAE_Record_Type_Change_Settings__mdt cs : [SELECT Id, Record_Type_Name__c, Active__c FROM HAE_Record_Type_Change_Settings__mdt WHERE Active__c = true]){
            activeRecordTypes.add(cs.Record_Type_Name__c);
        }       
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            if(activeRecordTypes.contains(info.getName())){
                mapofCaseRecordTypeIdandName.put(info.getRecordTypeId(),info.getName());
            }            
        }
        return mapofCaseRecordTypeIdandName;
    } 
}