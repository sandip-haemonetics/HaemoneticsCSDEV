/**
* Name			:	HAE_FieldSetUtils
* Date			:	12/4/2019
* Description	:	This is the utility class.	
*/
public class HAE_FieldSetUtils {
    /**
	* Name			:	getFieldsOfFieldSet
	* Param			: 	String: objectAPIName,String: fieldSetName
	* Return		:   List of FieldsOfFieldSet
	* Description	:	This method returns list of FieldsOfFieldSet based on the parameters supplied to it.
	*/ 
    @AuraEnabled(cacheable=true)
    public static List<FieldsOfFieldSet> getFieldsOfFieldSet(String objectAPIName, String fieldSetName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult objDescribeRslt = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objDescribeRslt.fieldSets.getMap();   
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();        
        List<FieldsOfFieldSet> fields = new List<FieldsOfFieldSet>();
        for (Schema.FieldSetMember member : fieldSetMembers) {
            FieldsOfFieldSet fieldsOfFS = new FieldsOfFieldSet(member);
            fields.add(fieldsOfFS);
        }
        return fields;
    }
/* Wrapper Class*/    
    public class FieldsOfFieldSet {
        @AuraEnabled 
        public Boolean DBRequired;
        @AuraEnabled 
        public String APIName;
        @AuraEnabled 
        public String Label;        
        @AuraEnabled 
        public Boolean Required;
        @AuraEnabled 
        public String Type;        
        public FieldsOfFieldSet(Schema.FieldSetMember fsm) {
            this.DBRequired = fsm.DBRequired;
            this.APIName = fsm.fieldPath;
            this.Label = fsm.label;
            this.Required = fsm.required;
            this.Type = String.valueOf(fsm.getType());
        }
    }
}