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

    
    /**
      * This method is responsible to denote the Customer Service Case record.
    **/
    private static boolean isRecordForCustomerService(){
        if(!Trigger.isDelete){
            for (Case caseIns : Trigger.new) {
                if(caseIns.HAE_Customer_Service_Case__c)
                    return true;
            } 
        }else{
            for (Case caseIns : Trigger.old) {
                if(caseIns.HAE_Customer_Service_Case__c)
                    return true;
            } 
        }       
        return false;
    }
    
    /**
      * Condition to segrigate the existing logic and new logic for Customer Service based on record type selection.
      */
    if(isRecordForCustomerService()){
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