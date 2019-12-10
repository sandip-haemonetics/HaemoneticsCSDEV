//
//This trigger calls some background jobs for Case
//
//Author: CERVELLO INC - Dmitry Belyaevsky (03-03-2017)
/** Modified By : Cognizant
  * Date : 10 Nov, 2019
  * Description : 
  *        For Customer Service business logic implementation we are segrigating the existing logic and new logic 
  *        based on record type selection. All the Case trigger logic for Customer Service will be handled by
  *        HAE_CaseTriggerHandler apex class.         
**/

trigger HFSL_CaseTrigger on Case (after insert, before insert, before update, before delete, after update) {

    
    //Case Record Types used for Customer Service.
    private static final String HAE_CLAIM_RECORD_TYPE = 'Customer Service: Claims';
    private static final String HAE_GHX_RECORD_TYPE = 'Customer Service: GHX';
    private static final String HAE_INQUIRY_RECORD_TYPE = 'Customer Service: Inquiry';
    private static final String HAE_ORDER_RECORD_TYPE = 'Customer Service: Order';
    private static final String HAE_SERVICE_REQUEST_RECORD_TYPE = 'Customer Service: Service Request';
    private static final String HAE_CONTRACT_REQUEST_RECORD_TYPE = 'Customer Service: Contract Request';
    
    Map<ID,Schema.RecordTypeInfo> recordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    
    /**
      * This method is responsible to find out the record is for Customer Service's Case Record Type or not.
      **/
    private static boolean isRecordForCustomerService(){
        for (Case caseIns : Trigger.new) {
             if(recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_CLAIM_RECORD_TYPE)
                 || recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_GHX_RECORD_TYPE)
                 || recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_INQUIRY_RECORD_TYPE)
                 || recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_ORDER_RECORD_TYPE)
                 || recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_SERVICE_REQUEST_RECORD_TYPE)
               	 || recordTypeMap.get(caseIns.recordTypeID).getName().equalsIgnoreCase(HAE_CONTRACT_REQUEST_RECORD_TYPE)) {
                 return true;
             }
        }
        
        return false;
    }
    
    /**
      * Condition to segrigate the existing logic and new logic for Customer Service based on record type selection.
      */
    if(!Trigger.isDelete && isRecordForCustomerService()){
        System.debug(':::::::::::::: Calling from CS module');
        //New Logic for Customer service is delegated to helper classes.
        HAE_CaseTriggerHandler.executeTrigger();  
       
        
    } else {        
        // Existing Logic .......
        if (!HFSL_CustomSettings.triggersEnabled()) {
            System.debug(LoggingLevel.INFO, '\'HFSL_CaseTrigger\' trigger is disabled!');
            return;
        }
    
        if (Trigger.isBefore && Trigger.isInsert) {
            HFSL_CaseUtils.onCaseBeforeInsert(Trigger.new);
        }
    
        if (Trigger.isBefore && Trigger.isUpdate) {
            HFSL_CaseUtils.onCaseBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    
        if (Trigger.isBefore && Trigger.isDelete) {
            HFSL_CaseUtils.onCaseBeforeDelete(Trigger.old);
        }
    
        if (Trigger.isAfter && Trigger.isUpdate) {
            HFSL_CaseUtils.onCaseAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}