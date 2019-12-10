/** Created By : Cognizant
* Date : 10 Nov, 2019
* Description : 
*        This class is responsible to handle all Case trigger logic related to Customer Service Module.         
**/
public with sharing class HAE_CaseTriggerHandler {

    private Static final String HAE_ORDER_RECORD_TYPE_DEVELOPER_NAME = 'HAE_Customer_Service_Order';
    

    /**
    * This method is calling from trigger and from this method all template methods are called.
    */
    public static void executeTrigger() {        
        if (Trigger.isBefore){ // Before Trigger operation
            if (Trigger.isInsert)
            	beforeInsert((List<Case>) Trigger.new);
            if (Trigger.isUpdate)
            	beforeUpdate((List<Case>) Trigger.new, (Map<id,Case>) Trigger.newMap, (List<Case>) Trigger.old, (Map<id,Case>) Trigger.oldMap);
            if (Trigger.isDelete)
            	beforeDelete((List<Case>) Trigger.old, (Map<id,Case>) Trigger.oldMap);
        } else { // Before Trigger operation
            if (Trigger.isInsert)
            	afterInsert((List<Case>) Trigger.new, (Map<id,Case>) Trigger.newMap);
            if (Trigger.isUpdate)
            	afterUpdate((List<Case>) Trigger.new, (Map<id,Case>) Trigger.newMap, (List<Case>) Trigger.old, (Map<id,Case>) Trigger.oldMap);
            if (Trigger.isDelete)
            	afterDelete((List<Case>) Trigger.old, (Map<id,Case>) Trigger.oldMap);
            if (Trigger.isUndelete)
            	afterUnDelete((List<Case>) Trigger.new, (Map<id,Case>) Trigger.newMap);
        }
    }
    
    /**
    * This method is responsible for performing all before insert operations.
    */
    private static void beforeInsert(List<Case> newCaseList) { 
        caseAccContAutoPopulationForEmailToCase(newCaseList);
        updateCSAcccountNoteOnCase(newCaseList,'INSERT',null, null);
        captureCase(newCaseList);
        populateContactRequestDetailsOnCase(newCaseList,HAE_ApexUtil.INSERT_ACTION, NULL, NULL);
        
        setCaseGroupForNARegion(newCaseList);
    }
    
    /**
    * This method is responsible for performing all before update operations.
    */
    private static void beforeUpdate(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap) {        
        updateCSAcccountNoteOnCase(newCaseList,'UPDATE', newCaseMap, oldCaseMap);  
        populateContactRequestDetailsOnCase(newCaseList,HAE_ApexUtil.UPDATE_ACTION, newCaseMap, oldCaseMap);        
        caseClosingBasedOnInternalTeamSelectionForNA(newCaseList, oldCaseList);
        resetReopen(newCaseList, oldCaseList);
        reopenCaseStatusChange(newCaseList, oldCaseList);        
        
    }
    
    /**
    * This method is responsible for performing all before delete operations.
    */
    private static void beforeDelete(List<Case> oldCaseList, Map<id,Case> oldCaseMap) {
        
    }
    
    /**
    * This method is responsible for performing all after insert operations.
    */
    private static void afterInsert(List<Case> newCaseList, Map<id,Case> newCaseMap) {
        //modifyRecordTypeBasedOnBusiness(newCaseList);      
        assignBussinessHourToCase(newCaseList,newCaseMap);
        //HAE_SkillsBasedRouting.routeUsingSkills(newCaseList);
        
    }
        
    /**
    * This method is responsible for performing all after update operations.
    */
    private static void afterUpdate(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap) {
        assignBussinessHourToCase(newCaseList,newCaseMap);
        caseTransferBasedOnInternalTeamSelectionForNA(newCaseList, oldCaseList);
        
        
    }
    
    /**
    * This method is responsible for performing all after delete operations.
    */
    private static void afterDelete(List<Case> oldCaseList, Map<id,Case> oldCaseMap) {
        
    }
        
    /**
    * This method is responsible for performing all after undelete operations.
    */
    private static void afterUnDelete(List<Case> newCaseList, Map<id,Case> newCaseMap) {
    }
    
    
    /**
    * ALL BUSINESS LOGIC ARE PERFORMED BY BELOW MENTIONED METHODS AND THEY ARE CALLED FROM ABOVE TEMPLATE.
    */
    
    /**
     * @name: caseAccContAutoPopulationForEmailToCase
     * @param(s): newCaseList : List of new instance of Cases.
     * @description: [REF: W-000025 > AC-009] : This method is checked if there is only one Related Account Contact for
     * 				 the contact of sender email address, then the bill to and ship to account and operation unit of that
     * 				 related account will be auto populated. 
     * 
     * 				 [REF: W-000026 > AC-009] : Set prioroty high if Account is VIP Customer.
     * 
     * @Note: 1. NO BULKIFICATION IS REQUIRED HERE AS IT IS PART OF EMAIL TO CASE.
     * 		  2. Case Account and Contact auto update based on sender email varification is OOB functionality. 
     * 			 No customization is required here.
     * @date: 10 Nov, 2019
     **/
    private static void caseAccContAutoPopulationForEmailToCase(List<Case> newCaseList) {
        if(newCaseList != null && !newCaseList.isEmpty() && newCaseList[0].SuppliedEmail != null 
           			&& newCaseList[0].Origin == System.Label.HAE_Case_Origin_Email_Type && newCaseList[0].ContactId != null){
            
            List<HAE_Related_Account_Contact__c> lstOfRAC = [select Id, HAE_Account__c, HAE_Account__r.Bill_To_Ship_To_SFDC__c, HAE_Account__r.HAE_Operating_Unit__c, HAE_Account__r.HAE_VIP_Customer__c,
                                                             	HAE_Account__r.HAE_Account_Note__c, HAE_Account__r.RecordType.DeveloperName from HAE_Related_Account_Contact__c where HAE_Contact__c = :newCaseList[0].ContactId];
            if(lstOfRAC != null && lstOfRAC.size() == 1){ 
                if(lstOfRAC[0].HAE_Account__r.RecordType.DeveloperName == HAE_ApexUtil.TRANSACTIONAL_ACCOUNT_RECORD_TYPE_DEVELOPER_NAME){
                    if(lstOfRAC[0].HAE_Account__r.HAE_VIP_Customer__c)
                        newCaseList[0].Priority = System.Label.HAE_CASE_PRIORITY_HIGH;
                    if(lstOfRAC[0].HAE_Account__r.Bill_To_Ship_To_SFDC__c == HAE_ApexUtil.SHIP_TO_ACCOUNT_TYPE){
                        newCaseList[0].HAE_Ship_To_Account__c = lstOfRAC[0].HAE_Account__c;
                        newCaseList[0].HAE_Operating_Unit__c = lstOfRAC[0].HAE_Account__r.HAE_Operating_Unit__c;
                    } else if(lstOfRAC[0].HAE_Account__r.Bill_To_Ship_To_SFDC__c == HAE_ApexUtil.BILL_TO_ACCOUNT_TYPE){
                        newCaseList[0].HAE_Bill_To_Account__c = lstOfRAC[0].HAE_Account__c;
                        newCaseList[0].HAE_Operating_Unit__c = lstOfRAC[0].HAE_Account__r.HAE_Operating_Unit__c;
                    }
                }                
            }
        }	
    }

    /*
        @name: captureCase
        @param(s): List<Case> newCaseList
        @description: to maintain the closed child case operation when sender will be the Web Methods
        @ref: [REF: W-000035 > AC-001]
        @date: 27thNov, 19
    */
    private static void captureCase(List<Case> newCaseList){

        String caseSubject;
        String poNumber;
        Boolean closedChildCase =  false;
        List<Case> matchingCaseList = new List<Case>();
        List<Case> updateParentCaseList = new List<Case>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Group> ghxQueueList = new List<Group>();
        Set<Id> ghxQueueIdSet = new Set<Id>();

        if(newCaseList <> NULL && !newCaseList.isEmpty()){
            for(Case cs : newCaseList){
                cs.HAE_Case_RecordType_Developer_Name__c = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.RecordTypeId).getDeveloperName();
            }
        }        

        accountList = [SELECT Id FROM Account WHERE Name =: HAE_ApexUtil.GX_Account_Name  LIMIT 1];
        contactList = [SELECT Id FROM Contact WHERE Name =: HAE_ApexUtil.GX_Contact_Name LIMIT 1];
        ghxQueueList = [SELECT Id FROM Group WHERE Type='queue' AND DeveloperName LIKE 'HAE_CS_GHX%'];

        if(ghxQueueList <> null && !ghxQueueList.isEmpty()){
            for(Group gr: ghxQueueList){
                ghxQueueIdSet.add(gr.Id);
            }
        }        
        
        if(newCaseList <> null && newCaseList.size() > 0 && newCaseList[0].SuppliedEmail <> null){
            caseSubject = newCaseList[0].Subject; 
            List<String> webserverAddressList = new List<String>();
            webserverAddressList = HAE_ApexUtil.GX_INTEGRATION_SERVER_EMAIL.split(',');
            if(webserverAddressList <> NULL && !webserverAddressList.isEmpty() && webserverAddressList.contains(newCaseList[0].SuppliedEmail) && caseSubject <> null){ //GX_INTEGRATION_SERVER_EMAIL=>'Integration-Server@HAEWEBMMT101.haemo.net
                poNumber = fetchPONumber(caseSubject);
                newCaseList[0].Debug_Field__c = newCaseList[0].SuppliedEmail + '---'+poNumber;
                if(poNumber <> null ){ ////RECEIVED_CASE: Received
                    matchingCaseList = [SELECT Id, 
                                               Status 
                                               FROM Case 
                                               WHERE HAE_PO_Number__c =: poNumber 
                                               AND RecordType.DeveloperName =: HAE_ORDER_RECORD_TYPE_DEVELOPER_NAME];
                                              

                    if(matchingCaseList <> null && !matchingCaseList.isEmpty()){
                        if(caseSubject.contains(HAE_ApexUtil.RECEIVED_CASE))
                            newCaseList[0].Status = HAE_ApexUtil.CASE_CLOSED_STATUS; //CASE_CLOSED_STATUS: Closed                         
                        
                            if(matchingCaseList<>null && !matchingCaseList.isEmpty() && caseSubject.contains(HAE_ApexUtil.RECEIVED_CASE)){
                                for(case matchedCaseObj : matchingCaseList){
                                    matchedCaseObj.Status = HAE_ApexUtil.CASE_CLOSED_STATUS;
                                    updateParentCaseList.add(matchedCaseObj);
                                } 
                            }                           

                            try{
                                if(updateParentCaseList <> NULL && !updateParentCaseList.isEmpty()) {
                                     update updateParentCaseList;                                      
                                }  
                                if(matchingCaseList<>null && !matchingCaseList.isEmpty()){
                                    for(case matchedCaseObj : matchingCaseList){
                                        newCaseList[0].ParentId = matchedCaseObj.Id;
                                    }
                                }                            
                            }catch(DMLException ex){
                                System.debug('DML Exception --->'+ex.getMessage());
                            }catch(Exception ex){
                                System.debug('System Exception --->'+ex.getMessage());
                            }                           
                    }

                    if(accountList <> NULL && !accountList.isEmpty())
                        newCaseList[0].AccountId = accountList[0].Id; 
                    if(contactList <> NULL && !contactList.isEmpty())
                        newCaseList[0].ContactId = contactList[0].Id;                               
                    newCaseList[0].Priority = HAE_ApexUtil.CASE_PRIORITY_HIGH; //CASE_PRIORITY_HIGH: High
                    newCaseList[0].HAE_PO_Number__c = poNumber;
                    if(caseSubject.contains(HAE_ApexUtil.RECEIVED_CASE) && newCaseList[0].Status <> HAE_ApexUtil.CASE_CLOSED_STATUS)
                        newCaseList[0].Status = HAE_ApexUtil.CASE_CLOSED_STATUS; 
                }
            }
        }
    }
    
    /*
        @name: fetchPONumber
        @param(s): String caseSubject
        @description: to fetch PO Number from the Subject line of the Case
        @ref: [REF: W-000035 > AC-001]
        @date: 27thNov, 19
    */
    private Static String fetchPONumber(String caseSubject){
        String poNumber;
        String trimSubject = '';
        
        trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT1); //PO_NUMBER_FORMAT1=>PO #
        if(trimSubject == '')
            trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT2);//PO_NUMBER_FORMAT2=>PO#
        if(trimSubject == '')
            trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT3);//PO_NUMBER_FORMAT3=>PO Number
        if(trimSubject == '')
            trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT4);//PO_NUMBER_FORMAT4=>PO Number:
        if(trimSubject == '')
            trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT5);//PO_NUMBER_FORMAT5=>PO Number :
        if(trimSubject == '')
            trimSubject = caseSubject.subStringAfter(HAE_ApexUtil.PO_NUMBER_FORMAT6);//PO_NUMBER_FORMAT6=>PO:
        
        
        if(trimSubject != ''){
            trimSubject = trimSubject.trim();
            return trimSubject.subStringBefore(' ');
        }        
             
        return null;       
    }
    
    /**
    * Case due date calculation based on the Case priority. 
    * Below is the matrix for Priority and Due date.
    * Priority High--> Due Date is 4 hrs from the case creation
    * Priority Low--> Due Date is 12 hrs from the case creation
    * Priority Medium --> Due Date is 12 hrs from the case creation
    * 
    * Also the Due date calculation should take into consideration the business hours for the specific zone. 
    * Business Hours is 8:30 AM to 5:30 PM for all Regions. So if a case comes at 4:30 pm on a friday , the due date 
    * should be 11:30 Am the following Monday considering the business hours and holidays into consideration.
    */
    private static void assignBussinessHourToCase(List<Case> newCaseList, Map<id,Case> newCaseMap){
        if(HAE_ApexUtil.flag){
            Set<Id> caseIds = new Set<Id>();
            List<Case> caseToUpdate = new List<Case>();
            List<Case> caseOwnerUser = new List<Case>();
            List<Case> caseOwnerQueue = new List<Case>();
            Map<ID,String> casesIDQueueMap = new Map<ID,String>();
            MAP<String,String> regionToBHMap = new Map<String,String>();
            Map<String,String> caseToRegionMap = new Map<String,String>();
            Map<String,String> businessHourNameIDMap = new  Map<String,String>();
            Map<String,String> queueNameBusinessHourMap = new Map<String,String>();
 
            for(Case caseRec : newCaseList){
                caseIds.add(caseRec.Id);   
            }
            if(!caseIds.isEmpty()){
                List<Case> caseList = [SELECT Id, BusinessHoursId, Owner.Name, Owner.Type, Priority, Due_Date__c, CreatedDate, HAE_Region2__c FROM Case WHERE Id IN :caseIds];
                for(Case caseRec : caseList){
                    if(caseRec.Owner.Type == HAE_ApexUtil.CASE_OWNER_TYPE){
                        caseOwnerQueue.add(caseRec);    
                    }
                    else{
                        caseOwnerUser.add(caseRec);
                        if(caseRec.HAE_Region2__c != null){  
                            caseToRegionMap.put(caseRec.Id,caseRec.HAE_Region2__c);
                        }
                    }
                } 
                if(!caseOwnerQueue.isEmpty()){                    
                    for(Case caseRec : caseOwnerQueue){
                        casesIDQueueMap.put(caseRec.Id,caseRec.Owner.Name);
                    }
                    if(!casesIDQueueMap.isEmpty()){
                        for(HAE_Case_Queue_Business_Hour_Mapping__mdt caseBusinessHoursMdt : [SELECT ID, Business_Hour_Name__c, Queue_Name__c FROM HAE_Case_Queue_Business_Hour_Mapping__mdt WHERE Active__c = true AND Queue_Name__c IN : casesIDQueueMap.values()]){
                            queueNameBusinessHourMap.put(caseBusinessHoursMdt.Queue_Name__c, caseBusinessHoursMdt.Business_Hour_Name__c);
                        }   
                    }
                    if(!queueNameBusinessHourMap.isEmpty()){
                        for(BusinessHours businessHr : [SELECT ID,Name FROM BusinessHours WHERE Name IN :queueNameBusinessHourMap.values()]){
                            businessHourNameIDMap.put(businessHr.Name,businessHr.ID);
                        }
                    }
                    for(Case caseRec : caseOwnerQueue ){
                        if(casesIDQueueMap.containsKey(caseRec.Id)){
                            String queueName = casesIDQueueMap.get(caseRec.Id);  
                            if(!String.isBlank(queueName)){
                                if(queueNameBusinessHourMap.containsKey(queueName)){
                                    String businessHrName = queueNameBusinessHourMap.get(queueName);
                                    if(!String.isBlank(businessHrName)){
                                        if(businessHourNameIDMap.containsKey(businessHrName)){
                                            caseRec.BusinessHoursId = businessHourNameIDMap.get(businessHrName);
                                            caseToUpdate.add(caseRec);
                                            if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_HIGH)
                                                caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 4);
                                            else if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_MEDIUM)
                                                caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 8);
                                            else if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_LOW)
                                                caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 12);
                                        } 
                                    }
                                }
                            }
                        }
                    }   
                }
                if(!caseOwnerUser.isEmpty()){
                    if(!caseToRegionMap.isEmpty()){
                        for(HAE_Region_To_Business_Hour_Mapping__mdt regionBusinessHoursMdt : [SELECT ID, HAE_Region_Name__c, HAE_Business_Hour_Name__c, HAE_Active__c FROM HAE_Region_To_Business_Hour_Mapping__mdt WHERE HAE_Active__c = true AND HAE_Region_Name__c IN : caseToRegionMap.values()]){
                            regionToBHMap.put(regionBusinessHoursMdt.HAE_Region_Name__c, regionBusinessHoursMdt.HAE_Business_Hour_Name__c);
                        }   
                    }
                    
                    if(!regionToBHMap.isEmpty()){
                        for(BusinessHours businessHr : [SELECT ID,Name FROM BusinessHours WHERE Name IN :regionToBHMap.values()]){
                            businessHourNameIDMap.put(businessHr.Name,businessHr.ID);
                        }    
                    }
                    for(Case caseRec : caseOwnerUser){
                        if(caseToRegionMap.containsKey(caseRec.Id)){    
                            String regionName = caseToRegionMap.get(caseRec.Id);
                            if(!String.isBlank(regionName)){                                
                                if(regionToBHMap.containsKey(regionName)){
                                    String bhName = regionToBHMap.get(regionName);  
                                    if(!String.isBlank(bhName)){
                                        caseRec.BusinessHoursId = businessHourNameIDMap.get(bhName); 
                                        if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_HIGH)
                                            caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 4);
                                        else if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_MEDIUM)
                                            caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 8);
                                        else if(caseRec.Priority == HAE_ApexUtil.CASE_PRIORITY_LOW)
                                            caseRec.Due_Date__c = calculateDueDateBasedOnBusinessHr(caseRec.BusinessHoursId, caseRec.CreatedDate, 12);
                                        caseToUpdate.add(caseRec);
                                    }
                                }
                            }
                        }
                    }
                }
                if(!caseToUpdate.isEmpty()){
                    try{  
                        HAE_ApexUtil.flag = false;   
                        update caseToUpdate;                            
                    }
                    catch(Exception ex){
                        system.debug('Exception while Business Hour setup : '+ex);
                    }
                }
                
            }
        }
    }
    
    /**
	* Updating CS Account Note field on Case From Bill To account.
	*/
    private static void updateCSAcccountNoteOnCase(List<Case> newCaseList, String actionType, Map<id,Case> newCaseMap, Map<id,Case> oldCaseMap){
        Map<Id,Account> accMap;
        Set<Id> accIds = new Set<Id>(); 
        for(Case caseRec : newCaseList){
            if(actionType == HAE_ApexUtil.INSERT_ACTION){
                if(caseRec.HAE_Bill_To_Account__c != NULL){
                	accIds.add(caseRec.HAE_Bill_To_Account__c);
                }
            }
            else if(actionType == HAE_ApexUtil.UPDATE_ACTION){
                if(newCaseMap != NULL && oldCaseMap != NULL){
                    if(newCaseMap.get(caseRec.Id) != null && oldCaseMap.get(caseRec.Id) != null){
                        if(newCaseMap.get(caseRec.Id).HAE_Bill_To_Account__c != oldCaseMap.get(caseRec.Id).HAE_Bill_To_Account__c){
                            if(caseRec.HAE_Bill_To_Account__c != NULL){
                                accIds.add(caseRec.HAE_Bill_To_Account__c);
                            }
                        }
                    }
                }
            }
        }   
        if(!accIds.isEmpty()){
            accMap = new Map<Id,Account>([SELECT Id, HAE_Account_Note__c FROM Account WHERE Id IN :accIds]);    
        }
        if(accMap!= NULL){
            if(!accMap.isEmpty()){
                for(Case caseRec : newCaseList){
                    if(caseRec.HAE_Bill_To_Account__c != NULL){
                        if(accMap.containsKey(caseRec.HAE_Bill_To_Account__c)){
                            caseRec.HAE_Account_Notes__c = accMap.get(caseRec.HAE_Bill_To_Account__c).HAE_Account_Note__c;
                        }    
                    }    
                }
            }
        }
    }

    /**
	* Updating Contact Request details on case.
	*/
    private static void populateContactRequestDetailsOnCase(List<Case> newCaseList, String actionType, Map<id,Case> newCaseMap, Map<id,Case> oldCaseMap) {
        Set<Id> contactRequestIdSet = new Set<Id>();
        Map<Id,Contract_Request__c> contactRequestMap;
        if(actionType == HAE_ApexUtil.INSERT_ACTION){
            for(Case caseRec : newCaseList){
                if(caseRec.HAE_Contract_Request__c != NULL){
                    contactRequestIdSet.add(caseRec.HAE_Contract_Request__c);                    
                }    
            } 
        }   
        else if(actionType == HAE_ApexUtil.UPDATE_ACTION){
            for(Case caseRec : newCaseList){
                if(caseRec.HAE_Contract_Request__c != NULL){
                    if(newCaseMap.get(caseRec.Id).HAE_Contract_Request__c != oldCaseMap.get(caseRec.Id).HAE_Contract_Request__c){
                        contactRequestIdSet.add(caseRec.HAE_Contract_Request__c);      
                    }
                }    
            }    
        }
        if(!contactRequestIdSet.isEmpty()){
            contactRequestMap = new Map<Id,Contract_Request__c>([SELECT Id, Sales_Order_Number__c, Upon_Execution_Notes__c, Required_Delivery_Date__c, Customer_Number__c,Account_Address_Shipto__c FROM Contract_Request__c WHERE Id IN :contactRequestIdSet]);    
        }
        if(contactRequestMap != NULL){
            for(Case caseRec : newCaseList){
                if(caseRec.HAE_Contract_Request__c != NULL){
                    Id contactRequestId = caseRec.HAE_Contract_Request__c;
                    if(contactRequestMap.containsKey(contactRequestId)){
                        Contract_Request__c contactRequest = contactRequestMap.get(contactRequestId);	    
                        if(contactRequest.Sales_Order_Number__c != NULL){
                            caseRec.HAE_Sales_Order_Number__c = contactRequest.Sales_Order_Number__c;    
                        }
                        if(contactRequest.Upon_Execution_Notes__c != NULL){
                            caseRec.HAE_Notes_to_Customer_Service__c = contactRequest.Upon_Execution_Notes__c;    
                        }
                        if(contactRequest.Required_Delivery_Date__c != NULL){
                            caseRec.HAE_Required_Delivery_Date__c = contactRequest.Required_Delivery_Date__c;    
                        }
                        if(contactRequest.Customer_Number__c != NULL){
                            caseRec.HAE_Contract_Request_Customer_Number__c = contactRequest.Customer_Number__c;    
                        }
                        if(contactRequest.Account_Address_Shipto__c != NULL){
                            caseRec.HAE_Contract_Request_Account_Address__c = contactRequest.Account_Address_Shipto__c;    
                        }                    
                    }	    
                }    
            }
        }
    }
        
    /**
     * @name: resetReopen
     * @param(s): newCaseList : List of new instance of Cases.
     * 			  oldCaseList : List of old instance of Cases.
     * @description: This is method is responsible to reset Reopen check box as false when status change from 
     * 				 reopen status(In Progresss || Response Received) to any other status.
     * @date: 10 Nov, 2019
     **/
    private static void resetReopen(List<Case> newCaseList, List<Case> oldCaseList){
        if(newCaseList != null && !newCaseList.isEmpty() && oldCaseList != null && !oldCaseList.isEmpty()){
            Map<Id, String> oldCaseMapWithStatus = new Map<Id, String>();
            
            for(Case oldCaseIns : oldCaseList){
            	oldCaseMapWithStatus.put(oldCaseIns.Id, oldCaseIns.Status);
            }            
            
            for(Case newCaseIns : newCaseList){
                if(newCaseIns.Status != System.Label.HAE_In_Progress_Case_Status && newCaseIns.Status != System.Label.HAE_Response_Received_Case_Status){
                    String previousStatus = oldCaseMapWithStatus.get(newCaseIns.Id);
                    if(previousStatus == System.Label.HAE_In_Progress_Case_Status || previousStatus == System.Label.HAE_Response_Received_Case_Status){
                        newCaseIns.HAE_Reopen__c = false;
                    }                        
                }
            }
        }
    }
	
	/**
     * @name: reopenCaseStatusChange
     * @param(s): newCaseList : List of new instance of Cases.
     * 			  oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to allow user to reopen a case within 10 business days of closure manually.
     * 				 When the case is reopened, the default status will be 'In Progress' and the Reopened flag will be set 
     * 				 to True on the case details page. 
	 * 				 Also responsible to throw message if Reopen reason is not provied before saving the record - (This is handled by validation rule).
     * @date: 10 Nov, 2019
     **/
    private static void reopenCaseStatusChange(List<Case> newCaseList, List<Case> oldCaseList){
        if(newCaseList != null && newCaseList.size() > 0 && oldCaseList != null && oldCaseList.size() > 0){
            Map<Id, Boolean> oldCaseMapWithReopenValue = new Map<Id, Boolean>();
            Map<Id, String> oldCaseMapWithStatusValue = new Map<Id, String>();            
			final Integer BEFORE_TEN_DAYS_COUNT = -10;
            
            for(Case oldCaseIns : oldCaseList){
            	oldCaseMapWithReopenValue.put(oldCaseIns.Id, oldCaseIns.HAE_Reopen__c);
                oldCaseMapWithStatusValue.put(oldCaseIns.Id, oldCaseIns.Status);
            }            
            
            for(Case newCaseIns : newCaseList){
            	Boolean reopenPriorValue = oldCaseMapWithReopenValue.get(newCaseIns.Id);
                // Check user checked Reopen Checked box.
                if(newCaseIns != null && newCaseIns.HAE_Reopen__c == true && reopenPriorValue == false){
                    String statusPriorValue = oldCaseMapWithStatusValue.get(newCaseIns.Id);
                    // If status is in Closed status, then reopen is allowed.
                    if(statusPriorValue != null && statusPriorValue == System.Label.HAE_Closed_Case_Status) {
                        // 1. Check Case is update manually. For auto update Last Modidfied User shoud be System.
                        String lastModifiedUserName = newCaseIns.LastModifiedBy.Name;
                        
                        if(lastModifiedUserName != HAE_ApexUtil.SYSTEM_USER){
                            // 2. Find out closed date.
                            DateTime closedDtTm = newCaseIns.ClosedDate;
                            // 3. If Business hour available then calculate 10 days based on BH or calculate it with simple 10 days.
                            DateTime dtBeforeTenDays = calculateDueDateBasedOnBusinessHr(newCaseIns.BusinessHoursId, Datetime.now(), BEFORE_TEN_DAYS_COUNT*24);
                            if(dtBeforeTenDays == null)
                                dtBeforeTenDays = Date.today().addDays(BEFORE_TEN_DAYS_COUNT*24);
                            
                            // 4. If close date is not cross 10 days form now, then reopen is possible else shown error.
                            if(newCaseIns.ClosedDate < dtBeforeTenDays) { // Closed date cross 10 days, so reopen status change is not accepted.
                                newCaseIns.addError(System.Label.HAE_Case_Reopen_On_Closed_Status_Message);
                            } else{
                                if(newCaseIns.Status != System.Label.HAE_Response_Received_Case_Status) //This condition is used only to controll status overrid issue controlled from EmailMessage Trigger.
                                    newCaseIns.Status = System.Label.HAE_In_Progress_Case_Status;
                                
                            }
                        }
                    } else{
                        newCaseIns.addError(System.Label.HAE_case_reopen_possible_on_closed_status);
                    }
                }
            }
        }
    }
         
    /**
     * @name: caseClosingBasedOnInternalTeamSelectionForNA
     * @param(s): newCaseList : List of new instance of Cases.
     * 			  oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to fetch list of cases to be closed by help of lstOfCloseAndTransferCaseBasedOnInternalTeamSelection() method
     * 				 and then closed all cases.
     * @date: 10 Nov, 2019
     **/
    private static void caseClosingBasedOnInternalTeamSelectionForNA(List<Case> newCaseList, List<Case> oldCaseList) {
    	List<Case> lstOfCaseToBeClosed = new List<Case>();
        lstOfCaseToBeClosed = lstOfCloseAndTransferCaseBasedOnInternalTeamSelection(newCaseList, oldCaseList);
        
        //Update case status to Closed.
        if(lstOfCaseToBeClosed != null && !lstOfCaseToBeClosed.isEmpty()){
            for(Case caseIns : lstOfCaseToBeClosed){
                caseIns.Status = System.Label.HAE_Closed_Case_Status;
                caseIns.HAE_Reopen__c = false;
                caseIns.HAE_Is_Case_Transferred_From_Here__c = true;
            }
        }
    }    
         
    /**
     * @name: caseTransferBasedOnInternalTeamSelectionForNA
     * @param(s): newCaseList : List of new instance of Cases.
     * 			  oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to fetch list of transfered cases by calling lstOfCloseAndTransferCaseBasedOnInternalTeamSelection() method
     * 				 and then create transfered case by help of createChildCase() method.
     * @date: 10 Nov, 2019
     **/
    private static void caseTransferBasedOnInternalTeamSelectionForNA(List<Case> newCaseList, List<Case> oldCaseList) {
        List<Case> lstOfCaseToBeTransfered = new List<Case>();
        lstOfCaseToBeTransfered = lstOfCloseAndTransferCaseBasedOnInternalTeamSelection(newCaseList, oldCaseList);
        
        //Method call to create child case from parent.
        if(lstOfCaseToBeTransfered != null && !lstOfCaseToBeTransfered.isEmpty()){
            createChildCase(lstOfCaseToBeTransfered);
        }
    }
    
    /**
     * @name: lstOfCloseAndTransferCaseBasedOnInternalTeamSelection
     * @param(s): newCaseList : List of new instance of Cases.
     * 			  oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to return lsit of case to be closed or transfered based on 
     * 				 internal team (Software Support / Product Support / Contracts) selection.
     * @date: 10 Nov, 2019
     **/
    private static List<Case> lstOfCloseAndTransferCaseBasedOnInternalTeamSelection(List<Case> newCaseList, List<Case> oldCaseList){
        List<Case> lstOfCaseToBeClosedAndTransfered = new List<Case>();
        Map<Id, String> oldCaseMapWithTeamValue = new Map<Id, String>();
        for(Case oldCaseIns : oldCaseList){
            oldCaseMapWithTeamValue.put(oldCaseIns.Id, oldCaseIns.HAE_Team__c);
        }            
            
        for(Case newCaseIns : newCaseList) {
            if(newCaseIns != null && newCaseIns.HAE_Region2__c == System.Label.HAE_Region_NA
               && (newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Software_Support 
               		|| newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Product_Support 
               		|| newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Contracts)) {
                String teamPriorValue = oldCaseMapWithTeamValue.get(newCaseIns.Id);
                if(teamPriorValue == null || (teamPriorValue != null && teamPriorValue != newCaseIns.HAE_Team__c)){
                	// List of case to be transfered.
            		lstOfCaseToBeClosedAndTransfered.add(newCaseIns);
                }
            }
        }
        return lstOfCaseToBeClosedAndTransfered;
    }
    
    /**
     * @name: createChildCase
     * @param(s): llstOfCaseToBeTransfered : List of Cases.
     * @description: This method is responsible to create child case from parent.
	 * 				Record type selection for child case is as follows,
	 * 				1. For Contract team selection Child case Record Type will be 'Customer Service: Contract Request'.
	 * 				2. For Software Support team selection Child case Record Type will be 'Software Support';
	 * 				3. For Product Support team selection Child case Record Type will be 'Phone Fix';
     * @date: 10 Nov, 2019
     **/
    private static void createChildCase(List<Case> llstOfCaseToBeTransfered){
        if(llstOfCaseToBeTransfered != null && !llstOfCaseToBeTransfered.isEmpty()){
            List<Case> listOfChildCaseToBeCreated = new List<Case>();
        
            for(Case caseIns : llstOfCaseToBeTransfered) {
                if(caseIns != null && caseIns.HAE_Team__c != null && caseIns.HAE_Team__c == System.Label.HAE_Case_Team_Software_Support){                
                    Case childCaseIns = getNewCaseInstance(caseIns, System.Label.HAE_Case_Group_Software_Support, HAE_ApexUtil.CASE_RECORD_TYPE_DEVELOPER_NAME_SOFTWARE_SUPPORT);
                    if(childCaseIns != null)
                        listOfChildCaseToBeCreated.add(childCaseIns);
                } else if(caseIns != null && caseIns.HAE_Team__c != null && caseIns.HAE_Team__c == System.Label.HAE_Case_Team_Product_Support){
                    Case childCaseIns = getNewCaseInstance(caseIns, System.Label.HAE_Case_Group_Product_Support, HAE_ApexUtil.CASE_RECORD_TYPE_DEVELOPER_NAME_PHONE_FIX);
                    if(childCaseIns != null)
                        listOfChildCaseToBeCreated.add(childCaseIns);
                } else if(caseIns != null && caseIns.HAE_Team__c != null && caseIns.HAE_Team__c == System.Label.HAE_Case_Team_Contracts){
                    Case childCaseIns = getNewCaseInstance(caseIns, System.Label.HAE_Case_Group_Contracts, HAE_ApexUtil.CASE_RECORD_TYPE_DEVELOPER_NAME_CONTRACTS);
                    if(childCaseIns != null)
                        listOfChildCaseToBeCreated.add(childCaseIns);
                }
            }
            if(listOfChildCaseToBeCreated != null && listOfChildCaseToBeCreated.size() > 0){
                try{
                    insert listOfChildCaseToBeCreated;                    
                } catch(Exception e){
                    System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
                }
            }
        }        
    }
    
    /**
     * @name: getNewCaseInstance
     * @param(s): caseIns : Case instance to be cloned.
     * 			  caseGroup : Assigned group name of new case instance.
     * 			  changeRecordTypeDeveloerName : Record Type developer name of new case instance.
     * @description: This method is responsible to return child case instance by cloning the parent one provide by method parameter
     * 				 and then update record type and few fields of new case instance and finally return the new instance.
     * @date: 06 Dec, 2019
     **/
    private static Case getNewCaseInstance(Case caseIns, String caseGroup, String changeRecordTypeDeveloerName){
        try{
            Case childCaseIns = caseIns.clone(false, false, false, false);
            childCaseIns.Status = System.Label.HAE_New_Case_Status;
            childCaseIns.HAE_Is_Transferred_Case__c = true;
            childCaseIns.ParentId = caseIns.Id;        
            childCaseIns.HAE_Case_Group__c = caseGroup;
            Id recordTypeIdOfSoftwareSupport = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(changeRecordTypeDeveloerName).getRecordTypeId();
            if(recordTypeIdOfSoftwareSupport != null)
                childCaseIns.RecordTypeId = recordTypeIdOfSoftwareSupport;
            
            return childCaseIns;
        } catch(Exception e){
            System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
        }
        
        return null;
    }
       
    /**
     * @name: calculateDueDateBasedOnBusinessHr
     * @param(s): businessHrId : Id of the Business Hour base on which return date will be calculated.
	 *			   startDateTime : Date time from where calculation will be done.
	 *			   intervalHour : Interval count in hour.
     * @description: This method is responsible to return next or previous date based on business hour, interval hour 
     * 				and start date.
     * @date: 10 Nov, 2019
     **/
    private static DateTime calculateDueDateBasedOnBusinessHr(Id businessHrId, DateTime startDateTime, Integer intervalHour){
        if(businessHrId != NULL && startDateTime != NULL){
            return BusinessHours.addGmt(businessHrId, startDateTime, intervalHour * 60 * 60 * 1000L);
        }
        return null;
    }
    
    /**
	 * This method is responsible to set the default case group for 'NA' region, of type 'Customer Service: Contract Request' to 'CS NA' group.
	 * */
    private static void setCaseGroupForNARegion(List<Case> newCaseList){
        Map<Id,Schema.RecordTypeInfo> recordtype_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Case caseRec : newCaseList){
            if(caseRec.recordTypeId != NULL){
                if(recordtype_Map.containsKey(caseRec.recordTypeId)){
                    if(recordtype_Map.get(caseRec.recordTypeId).getName() == HAE_ApexUtil.HAE_CONTRACT_REQUEST_RECORD_TYPE_NAME){
                        if(caseRec.HAE_Region2__c == HAE_ApexUtil.HAE_REGION_NA &&  caseRec.HAE_Case_Group__c == NULL){
                            caseRec.HAE_Case_Group__c = HAE_ApexUtil.HAE_DEFAULT_CASE_GROUP_NA;    
                        }    
                    }
                }
            }
        }        
    }
}