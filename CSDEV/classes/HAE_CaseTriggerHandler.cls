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
        contractsCaseTypeValidation(newCaseList);
        duplicatePreventionofCase(newCaseList);
        caseAccContAutoPopulationForEmailToCase(newCaseList);
        updateRegion(newCaseList);

        //updateCSAcccountNoteOnCase(newCaseList,'INSERT',null, null);
        captureCase(newCaseList);
        updateContactRequestDetailsOnAutoCreate(newCaseList);
        populateContactRequestDetailsOnCase(newCaseList,HAE_ApexUtil.INSERT_ACTION, NULL, NULL);        
        setCaseGroupForNARegion(newCaseList);
        updateCaseCategoryOnAutoCreate(newCaseList);
        checkForSensitiveInformationAndMask(newCaseList);
        assignCaseGroupForExtUser(newCaseList); 
        caseDetailsUpdateOnAutoCreate(newCaseList);             //Default Case Group and Region Assignment On Auto-Creation of case.
    }
    
    /**
    * This method is responsible for performing all before update operations.
    */
    private static void beforeUpdate(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap) {        
        //updateCSAcccountNoteOnCase(newCaseList,'UPDATE', newCaseMap, oldCaseMap);  
        populateContactRequestDetailsOnCase(newCaseList,HAE_ApexUtil.UPDATE_ACTION, newCaseMap, oldCaseMap);        
        caseClosingBasedOnInternalTeamSelectionForNA(newCaseList, oldCaseList);
        resetReopen(newCaseList, oldCaseList);
        reopenCaseStatusChange(newCaseList, oldCaseList);        
        checkCaseGroupForContracts(newCaseList,newCaseMap, oldCaseList, oldCaseMap);
        checkForSensitiveInformationAndMask(newCaseList); 
        updateRegion(newCaseList);               
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
        taskForCaseOwner(newCaseList);
        //modifyRecordTypeBasedOnBusiness(newCaseList);      
        assignBussinessHourToCase(newCaseList,newCaseMap);
        //HAE_SkillsBasedRouting.routeUsingSkills(newCaseList);
         //caseTransferBasedOnInternalTeamSelectionForNA(newCaseList, null);  
         
    }
        
    /**
    * This method is responsible for performing all after update operations.
    */
    private static void afterUpdate(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap) {
        taskForCaseOwner(newCaseList);
        assignBussinessHourToCase(newCaseList,newCaseMap);
        caseTransferBasedOnInternalTeamSelectionForNA(newCaseList, oldCaseList);
        validContactRelationship(newCaseList);  
        autoForwardPOToGHX(newCaseList,newCaseMap,oldCaseList,oldCaseMap);
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
     *               the contact of sender email address, then the bill to and ship to account and operation unit of that
     *               related account will be auto populated. 
     * 
     *               [REF: W-000026 > AC-009] : Set prioroty high if Account is VIP Customer.
     * 
     * @Note: 1. NO BULKIFICATION IS REQUIRED HERE AS IT IS PART OF EMAIL TO CASE.
     *        2. Case Account and Contact auto update based on sender email varification is OOB functionality. 
     *           No customization is required here.
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
        List<HAE_CS_Case_Auto_Archive_Rules__mdt>autoArchivalRulesList = new List<HAE_CS_Case_Auto_Archive_Rules__mdt>();
        
        autoArchivalRulesList = [SELECT Id, HAE_From_Email_Address__c, HAE_Subject__c, HAE_Case_Group__c, HAE_Auto_Archive__c FROM HAE_CS_Case_Auto_Archive_Rules__mdt WHERE HAE_Active__c = true];

        if(newCaseList <> NULL && !newCaseList.isEmpty()){
            for(Case cs : newCaseList){
                cs.HAE_Case_RecordType_Developer_Name__c = Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.RecordTypeId).getDeveloperName();

                if(autoArchivalRulesList <> null && !autoArchivalRulesList.isEmpty()){
                    for(HAE_CS_Case_Auto_Archive_Rules__mdt archivalRule : autoArchivalRulesList){
                        if(cs.SuppliedEmail <> NULL && archivalRule.HAE_From_Email_Address__c <> NULL){
                            if((archivalRule.HAE_From_Email_Address__c <> NULL && cs.Subject <> NULL && archivalRule.HAE_Subject__c <> NULL && cs.HAE_Initial_Case_Owner_Group__c <> NULL && archivalRule.HAE_Case_Group__c <> NULL && cs.SuppliedEmail.toLowerCase() == archivalRule.HAE_From_Email_Address__c.toLowerCase() && cs.Subject.toLowerCase().contains(archivalRule.HAE_Subject__c.toLowerCase())
                            && cs.HAE_Initial_Case_Owner_Group__c == archivalRule.HAE_Case_Group__c) ||(cs.SuppliedEmail.toLowerCase() == archivalRule.HAE_From_Email_Address__c.toLowerCase() && archivalRule.HAE_Auto_Archive__c))
                                cs.Status = HAE_ApexUtil.CASE_CLOSED_STATUS;
                        }

                    }
                }
            
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
            List<String> orderwebserverAddressList = new List<String>();
            List<String> gxwebserverAddressList = new List<String>();
            String webEmail;
            String gxwebserveremailaddress = HAE_ApexUtil.GX_INTEGRATION_SERVER_EMAIL;
            String orderwebserveremailaddress = HAE_ApexUtil.ORDER_INTEGRATION_SERVER_EMAIL.toLowerCase();
            gxwebserverAddressList = gxwebserveremailaddress.toLowerCase().split(',');
            orderwebserverAddressList = orderwebserveremailaddress.toLowerCase().split(',');


            webEmail = newCaseList[0].SuppliedEmail.toLowerCase();

            Boolean validfromEmail = false;

            if((gxwebserverAddressList <> NULL && !gxwebserverAddressList.isEmpty() && gxwebserverAddressList.contains(webEmail))
            ||(orderwebserverAddressList <> NULL && !orderwebserverAddressList.isEmpty() && orderwebserverAddressList.contains(webEmail)))
            
                validfromEmail = true;   
                if(validfromEmail && caseSubject <> NULL){
                poNumber = fetchPONumber(caseSubject);
                //newCaseList[0].Debug_Field__c = newCaseList[0].SuppliedEmail + '---'+poNumber;
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

                    /*if(accountList <> NULL && !accountList.isEmpty())
                        newCaseList[0].HAE_Bill_To_Account__c = accountList[0].Id; 
                    if(contactList <> NULL && !contactList.isEmpty())
                        newCaseList[0].contactId = contactList[0].Id;*/                               
                    newCaseList[0].Priority = HAE_ApexUtil.CASE_PRIORITY_HIGH; //CASE_PRIORITY_HIGH: High
                    newCaseList[0].HAE_PO_Number__c = poNumber;
                    if(caseSubject.contains(HAE_ApexUtil.RECEIVED_CASE) && newCaseList[0].Status <> HAE_ApexUtil.CASE_CLOSED_STATUS)
                        newCaseList[0].Status = HAE_ApexUtil.CASE_CLOSED_STATUS; 
                }
            }
        }
    }

    /*
        @name: updateRegion
        @param(s): List<Case> newCaseList
        @description: to update Region based on Operating Unit
        @date: 12thDec, 19
    */
    private static void updateRegion(List<Case> newCaseList){
        
        if(newCaseList <> NULL && !newCaseList.isEmpty()){
            for(Case cs : newCaseList){
                //caseIdSet.add(cs.Id);
                //Contract Request-111
                if(cs.HAE_Region2__c != NULL){                  
                    cs.HAE_Region__c = cs.HAE_Region2__c;
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
                                            if(caseRec.Due_Date__c != NULL){                                                
                                                if(caseRec.Due_Date__c > caseRec.CreatedDate){
                                                   updateSLABreachDate(caseRec);
                                                }                      
                                            }
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
                                        if(caseRec.Due_Date__c != NULL){                                                
                                            if(caseRec.Due_Date__c > caseRec.CreatedDate){
                                                updateSLABreachDate(caseRec);
                                            }                      
                                        }
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
                            caseRec.HAE_SO_Number__c = contactRequest.Sales_Order_Number__c;    
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
     *            oldCaseList : List of old instance of Cases.
     * @description: This is method is responsible to reset Reopen check box as false when status change from 
     *               reopen status(In Progresss || Response Received) to any other status.
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
     *            oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to allow user to reopen a case within 10 business days of closure manually.
     *               When the case is reopened, the default status will be 'In Progress' and the Reopened flag will be set 
     *               to True on the case details page. 
     *               Also responsible to throw message if Reopen reason is not provied before saving the record - (This is handled by validation rule).
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
     *            oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to fetch list of cases to be closed by help of lstOfCloseAndTransferCaseBasedOnInternalTeamSelection() method
     *               and then closed all cases.
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
     *            oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to fetch list of transfered cases by calling lstOfCloseAndTransferCaseBasedOnInternalTeamSelection() method
     *               and then create transfered case by help of createChildCase() method.
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
     *            oldCaseList : List of old instance of Cases.
     * @description: This method is responsible to return lsit of case to be closed or transfered based on 
     *               internal team (Software Support / Product Support / Contracts) selection.
     * @date: 10 Nov, 2019
     **/
    private static List<Case> lstOfCloseAndTransferCaseBasedOnInternalTeamSelection(List<Case> newCaseList, List<Case> oldCaseList){
        List<Case> lstOfCaseToBeClosedAndTransfered = new List<Case>();
        String teamPriorValue = null;
        Map<Id, String> oldCaseMapWithTeamValue = new Map<Id, String>();
        if(oldCaseList <> NULL && !oldCaseList.isEmpty()){
            for(Case oldCaseIns : oldCaseList){
                oldCaseMapWithTeamValue.put(oldCaseIns.Id, oldCaseIns.HAE_Team__c);
            }   
        }         
            
        for(Case newCaseIns : newCaseList) {
            if(newCaseIns != null && newCaseIns.HAE_Region2__c == System.Label.HAE_Region_NA
               && (newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Software_Support 
                    || newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Product_Support 
                    || newCaseIns.HAE_Team__c == System.Label.HAE_Case_Team_Contracts)) {
                if(oldCaseMapWithTeamValue <> NULL && !oldCaseMapWithTeamValue.isEmpty())
                    teamPriorValue = oldCaseMapWithTeamValue.get(newCaseIns.Id);
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
     *              Record type selection for child case is as follows,
     *              1. For Contract team selection Child case Record Type will be 'Customer Service: Contract Request'.
     *              2. For Software Support team selection Child case Record Type will be 'Software Support';
     *              3. For Product Support team selection Child case Record Type will be 'Phone Fix';
     * @date: 10 Nov, 2019
     **/
    private static void createChildCase(List<Case> llstOfCaseToBeTransfered){
    
        System.debug('llstOfCaseToBeTransfered size ---->'+llstOfCaseToBeTransfered.size());
        if(llstOfCaseToBeTransfered != null && !llstOfCaseToBeTransfered.isEmpty()){
            List<Case> listOfChildCaseToBeCreated = new List<Case>();
        
            for(Case caseIns : llstOfCaseToBeTransfered) {
                if(caseIns.Category__c == System.Label.HAE_Category_Transfer){ //HAE_Category_Transfer: Transfer
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
            }
            if(listOfChildCaseToBeCreated != null && listOfChildCaseToBeCreated.size() > 0){
                try{
                    if(HAE_ApexUtil.flagForChildCase){
                        HAE_ApexUtil.flagForChildCase = false;
                        insert listOfChildCaseToBeCreated; 
                    }
                } catch(Exception e){
                    System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
                }
            }
        }        
    }
    
    /**
     * @name: getNewCaseInstance
     * @param(s): caseIns : Case instance to be cloned.
     *            caseGroup : Assigned group name of new case instance.
     *            changeRecordTypeDeveloerName : Record Type developer name of new case instance.
     * @description: This method is responsible to return child case instance by cloning the parent one provide by method parameter
     *               and then update record type and few fields of new case instance and finally return the new instance.
     * @date: 06 Dec, 2019
     **/
    private static Case getNewCaseInstance(Case caseIns, String caseGroup, String changeRecordTypeDeveloerName){
        try{
            Case childCaseIns = caseIns.clone(false, false, false, false);
            childCaseIns.Status = System.Label.HAE_New_Case_Status;
            childCaseIns.HAE_Is_Transferred_Case__c = true;
            childCaseIns.ParentId = caseIns.Id;        
            childCaseIns.HAE_Case_Group__c = caseGroup;
            childCaseIns.Subject = childCaseIns.Subject;
            Id recordTypeIdOfSoftwareSupport = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(changeRecordTypeDeveloerName).getRecordTypeId();
            if(recordTypeIdOfSoftwareSupport != null)
                childCaseIns.RecordTypeId = recordTypeIdOfSoftwareSupport;
            if(changeRecordTypeDeveloerName == HAE_ApexUtil.CASE_RECORD_TYPE_DEVELOPER_NAME_CONTRACTS){
                childCaseIns.HAE_Transfer_Contracts__c = true;
            }
            
            return childCaseIns;
        } catch(Exception e){
            System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
        }
        
        return null;
    }
       
    /**
     * @name: calculateDueDateBasedOnBusinessHr
     * @param(s): businessHrId : Id of the Business Hour base on which return date will be calculated.
     *             startDateTime : Date time from where calculation will be done.
     *             intervalHour : Interval count in hour.
     * @description: This method is responsible to return next or previous date based on business hour, interval hour 
     *              and start date.
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
    /**
    * @name: checkCaseGroupForContracts
    * @param(s):    newCaseList :   List of new version of cases.   
    *               newCaseMap  :   Map of Id to new version of cases.
    *               oldCaseList :   List of old version of cases.
    *               oldCaseMap  :   Map of Id to old version of cases.  
    * @description: This method is responsible to calculate the number of business hours, since the Case Group was changed to Contracts.
    * @date: 10 Dec, 2019
    **/
    private static void checkCaseGroupForContracts(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap){
        Long hours = 0;
        for(Case newCase : newCaseList){
            Case oldCase = oldCaseMap.get(newCase.id);
            if(newCase.HAE_Case_Group__c != NULL){
                if((newCase.HAE_Case_Group__c != oldCase.HAE_Case_Group__c && newCase.HAE_Case_Group__c == System.Label.HAE_Case_Group_For_Contract_Hours ) && newCase.BusinessHoursId != NULL){
                    newCase.HAE_Contracts_Initiated_On__c = system.now();  
                }
                if(((newCase.HAE_Case_Group__c != oldCase.HAE_Case_Group__c && oldCase.HAE_Case_Group__c == System.Label.HAE_Case_Group_For_Contract_Hours ) ||  newCase.Status == HAE_ApexUtil.HAE_CASE_CATEGORY_STATUS_CONTRACT_HOURS ) && newCase.BusinessHoursId != NULL){
                    if(newCase.HAE_Contracts_Initiated_On__c != NULL){
                        hours = Math.abs(BusinessHours.diff(newCase.businessHoursId,newCase.HAE_Contracts_Initiated_On__c,system.now())/1000/60/60);
                        if(newCase.HAE_Contract_Hours__c != NULL){
                            newCase.HAE_Contract_Hours__c = newCase.HAE_Contract_Hours__c + hours;    
                        }
                        else{
                            newCase.HAE_Contract_Hours__c = hours;
                        }
                    }                   
                }
            }
        }    
    }
    /**
    * @name: updateCaseCategoryOnAutoCreate
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to create cases based on the email subject.
    * @date: 10 Dec, 2019
    **/
    private static void updateCaseCategoryOnAutoCreate(List<Case> newCaseList){
        Set<Id> operatingUnitIdSet = new Set<Id>();
        Map<String, HAE_Case_Creation_Settings__mdt> caseSettingsMap = new Map<String, HAE_Case_Creation_Settings__mdt>();
        Map<String,String> mapofCaseRecordTypeNameandId = new Map<String,String>();
        Map<String,String> mapofCaseRecordTypeIdandName = new Map<String,String>();
        Set<String> queueNames = new Set<String>();
        Map<String,String> queueNameToIdMap = new Map<String,String>(); 
        Map<String,String> operatingUnitToRegionMap = new Map<String,String>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(HAE_ApexUtil.HAE_CASE).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();        
        for(HAE_Case_Creation_Settings__mdt cs : [SELECT Id, HAE_Search_Key__c, HAE_Case_Record_Type__c, HAE_Case_Priority__c, HAE_Case_Owner__c, HAE_Case_Group__c, HAE_Case_Category_Value__c, HAE_Active__c FROM HAE_Case_Creation_Settings__mdt WHERE HAE_Active__c = true ORDER BY HAE_Search_Key__c]){
            caseSettingsMap.put(cs.HAE_Search_Key__c, cs);
            queueNames.add(cs.HAE_Case_Owner__c);
        }
        if(!queueNames.isEmpty()){
            for(Group groupRec : [SELECT Id, Name FROM GROUP WHERE TYPE = 'Queue' AND Name IN :queueNames]){
                queueNameToIdMap.put(groupRec.Name, groupRec.Id);    
            }
        }
        for(Case caseRec: newCaseList){
            if(caseRec.HAE_Operating_Unit__c != NULL){
                operatingUnitIdSet.add(caseRec.HAE_Operating_Unit__c);
            }
        }
        if(!operatingUnitIdSet.isEmpty()){
            for(HAE_Operating_Unit__c opRec : [SELECT Id, Region__c FROM HAE_Operating_Unit__c WHERE Id IN :operatingUnitIdSet]){
                operatingUnitToRegionMap.put(opRec.Id, opRec.Region__c);    
            }    
        }
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            mapofCaseRecordTypeNameandId.put(info.getName(),info.getRecordTypeId());
            mapofCaseRecordTypeIdandName.put(info.getRecordTypeId(),info.getName());
        }
        for(Case caseRec : newCaseList){
            if((mapofCaseRecordTypeIdandName.get(caseRec.RecordTypeId)).equals(HAE_ApexUtil.HAE_Customer_Service_Inquiry) && caseRec.SuppliedEmail != NULL){
                for(String key : caseSettingsMap.keySet()){
                    if((caseRec.Subject).containsIgnoreCase(key)){
                        HAE_Case_Creation_Settings__mdt caseSetting = caseSettingsMap.get(key);
                        if(caseSetting != NULL){
                            caseRec.RecordTypeId = mapofCaseRecordTypeNameandId.get(caseSetting.HAE_Case_Record_Type__c);
                            //--Need to check this Category assignment--------------
                            /*if(caseRec.HAE_Region__c != NULL){
                                if(caseSetting.HAE_Case_Category_Value__c != NULL){
                                    caseRec.Category__c = caseSetting.HAE_Case_Category_Value__c;
                                }
                            }*/                            
                            if(caseRec.HAE_Operating_Unit__c != NULL){
                                if(operatingUnitToRegionMap.containsKey(caseRec.HAE_Operating_Unit__c)){
                                    caseRec.HAE_Region__c =  operatingUnitToRegionMap.get(caseRec.HAE_Operating_Unit__c); 
                                    if(caseSetting.HAE_Case_Category_Value__c != NULL){
                                        caseRec.Category__c = caseSetting.HAE_Case_Category_Value__c;
                                    }
                                }
                            }
                            //------------------------------------------------------
                            if(caseSetting.HAE_Case_Priority__c != NULL){
                                caseRec.Priority = caseSetting.HAE_Case_Priority__c;
                            }
                            if(caseSetting.HAE_Case_Group__c != NULL){
                                caseRec.HAE_Case_Group__c = caseSetting.HAE_Case_Group__c;    
                            }
                            if(caseSetting.HAE_Case_Owner__c != NULL){
                                caseRec.OwnerId = queueNameToIdMap.get(caseSetting.HAE_Case_Owner__c);    
                            }
                            //caseRec.Debug_Field__c = 'Op : '+caseRec.HAE_Operating_Unit__c+'Region form : '+caseRec.HAE_Region2__c+' Region Pick :'+caseRec.HAE_Region__c;
                            break;
                        }
                    }    
                }
            }         
        }
    }
    /**
    * @name: checkForSensitiveInformationAndMask
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to check and mask sensitive information in case description.
    * @date: 10 Dec, 2019
    **/
    private static void checkForSensitiveInformationAndMask(List<Case> newCaseList){
        List<String> regexList = new List<String>();        
        String encryptionPattern = System.Label.HAE_Encryption_Pattern;
        Integer encryptionPatternLength = Integer.valueof(System.Label.HAE_Encryption_Length);
        for(HAE_Credit_Card_Regex__mdt regex : [SELECT HAE_Regex__c, HAE_Active__c FROM HAE_Credit_Card_Regex__mdt WHERE HAE_Active__c = true] ){
            regexList.add(regex.HAE_Regex__c);
        }
        if(!regexList.isEmpty()){
            for(Case caseRec : newCaseList){
                if (caseRec.Description != null) {
                    String description = HAE_EncodingUtils.maskString(caseRec.Description, regexList, encryptionPattern, encryptionPatternLength);
                    if(!description.equalsIgnoreCase(caseRec.Description)){
                        caseRec.HAE_Sensitive__c = true;
                        caseRec.Description = description;
                    }   
                }
            }
        }
    }
    private static void updateSLABreachDate(Case caseRec){
        Long caseCreatedDate = caseRec.CreatedDate.getTime();
        Long caseDueDate = caseRec.Due_Date__c.getTime();
        Long milliseconds = caseDueDate - caseCreatedDate;
        Integer breachPercentage = Integer.valueOf((milliseconds)*.8);
        Long slaBreachDateTime  = caseCreatedDate + breachPercentage;
        DateTime breachToInitiateOn = DateTime.newInstance(slaBreachDateTime);
        caseRec.HAE_SLA_Breach_Date__c = breachToInitiateOn;      
        //caseRec.HAE_SLA_Breach_Date__c = DateTime.now().addMinutes(2);                                        
    }
    /**
    * @name: taskForCaseOwner
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to create task for the case owner when case status is 'Closed' and Category is 'Credit Request'.
    * @date: 13 Dec, 2019
    **/    
    private static void taskForCaseOwner(List<Case> newCaseList){
        if(HAE_ApexUtil.flagForTask){
            HAE_ApexUtil.flagForTask = false;
            List<Task> taskList = new List<Task>();
            for(Case caseRec : newCaseList){
                if(caseRec.Status == System.Label.HAE_Case_Status_Closed  && caseRec.Category__c == System.Label.HAE_Case_Category_Credit_Request ){
                    Date notifyDate = system.today()+1;                
                    if(caseRec.BusinessHoursId != NULL){
                        if(!BusinessHours.isWithin(caseRec.BusinessHoursId, notifyDate)){                    
                            DateTime dt = BusinessHours.nextStartDate(caseRec.BusinessHoursId, notifyDate); 
                            notifyDate = date.newinstance(dT.year(), dT.month(), dT.day());
                        }
                    }
                    Task newTask = new Task();
                    newTask.WhatId = caseRec.Id;
                    newTask.Priority = System.Label.HAE_Case_Priority_For_Task ;
                    newTask.Subject = System.Label.HAE_Case_Subject_for_Task ;
                    newTask.ActivityDate = notifyDate;
                    newTask.IsReminderSet = true;
                    newTask.OwnerId = caseRec.OwnerId;
                    taskList.add(newTask);
                }    
            }
            if(!taskList.isEmpty()){
                Database.insert(taskList, false);            
            }
        }
    }


    /**
    * @name: assignCaseGroupForExtUser
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to set the default Case Group and Owner if user type is external.
    * @date: 16 Dec, 2019
    **/ 
    private static void assignCaseGroupForExtUser(List<Case> newCaseList){
        List<Group> groupList = new List<Group>();
        String userType = UserInfo.getUserType();
        for(Group groupRec : [SELECT Id, Name FROM GROUP WHERE TYPE = 'Queue' AND Name = :HAE_ApexUtil.HAE_DEFAULT_CASE_GROUP_NA LIMIT 1]){
            groupList.add(groupRec);    
        }
        for( Case caseRec : newCaseList){
            if(userType != HAE_ApexUtil.HAE_USER_TYPE_STANDARD && caseRec.SuppliedEmail == null){  
                caseRec.HAE_Case_Group__c = HAE_ApexUtil.HAE_DEFAULT_CASE_GROUP_NA; 
                if(!groupList.isEmpty()){
                    caseRec.OwnerId = groupList[0].id;     
                }
            }
        }
    }
    
    
    private static void validContactRelationship(List<case> newCaseList){
        
        Set<Id>caseBillToContactIdSet = new Set<Id>();
        Set<Id>caseBillToAccountIdSet = new Set<Id>();
        Map<Id,Case>billtoCaseMap = new Map<Id,Case>();
        Set<Id>caseShipToContactIdSet = new Set<Id>();
        Set<Id>caseShipToAccountIdSet = new Set<Id>();
        Map<Id,Case>shiptoCaseMap = new Map<Id,Case>();
        List<HAE_Related_Account_Contact__c>rltdAccountContactList  = new List<HAE_Related_Account_Contact__c>();
        Set<Id>matchedCaseIdSet = new Set<Id>();
        Boolean errorFlag = false;
        
        if(newCaseList <> NULL && !newCaseList.isEmpty()){
            for(Case caseObj : newCaseList){
                if(caseObj.ContactId <> NULL){
                    if(caseObj.HAE_Bill_To_Account__c <> NULL){
                        caseBillToContactIdSet.add(caseObj.ContactId);   
                        caseBillToAccountIdSet.add(caseObj.HAE_Bill_To_Account__c); 
                        billtoCaseMap.put(caseObj.Id, caseObj);
                    }
                    if(caseObj.HAE_Ship_To_Account__c <> NULL){
                        caseShipToContactIdSet.add(caseObj.ContactId);
                         caseShipToAccountIdSet.add(caseObj.HAE_Bill_To_Account__c);     
                        shiptoCaseMap.put(caseObj.Id, caseObj);
                    }
                }
            }
        }
        
        if(caseBillToContactIdSet<> NULL && !caseBillToContactIdSet.isEmpty() && caseBillToAccountIdSet<> NULL && !caseBillToAccountIdSet.isEmpty()){
            rltdAccountContactList = [SELECT Id, HAE_Account__c, HAE_Contact__c FROM HAE_Related_Account_Contact__c WHERE HAE_Contact__c IN: caseBillToContactIdSet AND HAE_Account__c IN: caseBillToAccountIdSet AND HAE_Active__c = true];
            
           for(Case caseObj : newCaseList){ 
               if(rltdAccountContactList.isEmpty()){
                   //Contract Request-111 
                   if(Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj.RecordTypeId).getname() != HAE_ApexUtil.HAE_CONTRACT_REQUEST_RECORD_TYPE_NAME){  
                       caseObj.addError(System.Label.HAE_No_Related_AccountContact);//HAE_No_Related_AccountContact: There is no Related Account Contact relationship for the current Contact. 
                   }
               }
               else{           
                    for(HAE_Related_Account_Contact__c racObj : rltdAccountContactList){                 
                        if(caseObj.HAE_Bill_To_Account__c <> NULL && caseObj.ContactId <> NULL){
                        
                        System.debug('TargetAccountId-->'+billtoCaseMap.get(caseObj.Id).HAE_Bill_To_Account__c+'OrgAccountId--->'+racObj.HAE_Account__c);
                            if(billtoCaseMap.get(caseObj.Id).ContactId == racObj.HAE_Contact__c && billtoCaseMap.get(caseObj.Id).HAE_Bill_To_Account__c != racObj.HAE_Account__c){
                                caseObj.addError(System.Label.HAE_No_Bill_To_Account);//HAE_No_Bill_To_Account: Respective Contact is not associated with the Bill To Account.
                                errorFlag = true; 
                            }
                        }
                    }
                }
            }            
          
        }
        
        
        /*if(caseShipToContactIdSet<> NULL && !caseShipToContactIdSet.isEmpty() && !errorFlag){
            rltdAccountContactList = [SELECT Id, HAE_Account__c, HAE_Contact__c FROM HAE_Related_Account_Contact__c WHERE HAE_Contact__c IN: caseShipToContactIdSet AND HAE_Account__c <> NULL AND HAE_Active__c = true];
            
           for(Case caseObj : newCaseList){ 
               if(rltdAccountContactList.isEmpty())
                   caseObj.addError('There is no Related Account Contact relationship for the current Contact.'); 
               else{           
                    for(HAE_Related_Account_Contact__c racObj : rltdAccountContactList){                 
                        if(caseObj.HAE_Ship_To_Account__c <> NULL && caseObj.ContactId <> NULL){
                            if(shiptoCaseMap.get(caseObj.Id).ContactId == racObj.HAE_Contact__c && shiptoCaseMap.get(caseObj.Id).HAE_Ship_To_Account__c != racObj.HAE_Account__c){
                                caseObj.addError('Respective Contact is not associated with the Ship To Account'); 
                            }
                        }
                    }
                }
            }            
          
        }*/
    }
    /**
    * @name: updateContactRequestDetailsOnAutoCreate
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to auto create Case of type Contract Request.
    * @date: 18 Dec, 2019
    * Contract Request-111
    **/   
    private static void updateContactRequestDetailsOnAutoCreate(List<case> newCaseList){
        List<String> contractRequestSubjects = new List<String>(); 
        Map<Id,Contract_Request__c> contactRequestMap;
        Map<String,String> subjectToCR = new Map<String,String>();
        String defaultContactName = System.Label.HAE_Default_Contact_For_Contact_Request_Case;
        String defaultContactId;
        if(!String.isBlank(defaultContactName)){
            List<Contact> contactList = new List<Contact>([SELECT Id, Name FROM Contact WHERE Name =:defaultContactName]);   
            if(!contactList.isEmpty()){
                defaultContactId = contactList[0].id; 
            }
        }
        for(Case caseRec : newCaseList){
            if(Schema.SObjectType.Case.getRecordTypeInfosById().get(caseRec.RecordTypeId).getname() == HAE_ApexUtil.HAE_CONTRACT_REQUEST_RECORD_TYPE_NAME && caseRec.SuppliedEmail != NULL && caseRec.Origin == 'Email'){
                caseRec.HAE_Region__c = HAE_ApexUtil.HAE_REGION_NA;
                caseRec.Status = System.Label.HAE_CS_CR_Default_Status;   
                caseRec.Category__c = System.Label.HAE_CS_CR_Default_Category;
                caseRec.Debug_Field__c = UserInfo.getUserType();
                if(!String.isBlank(defaultContactId)){
                    caseRec.ContactId = defaultContactId;
                }
                if(caseRec.Subject != NULL){                    
                    caseRec.Debug_Field__c = caseRec.Debug_Field__c + caseRec.Subject;
                    contractRequestSubjects.add(caseRec.Subject);    
                }               
            }   
        }
        if(!contractRequestSubjects.isEmpty()){
            contactRequestMap = new Map<Id,Contract_Request__c>([SELECT Id, Name FROM Contract_Request__c WHERE Name IN :contractRequestSubjects]); 
            if(!contactRequestMap.isEmpty()){
                for(Contract_Request__c crRec : contactRequestMap.values()){
                    subjectToCR.put(crRec.Name, crRec.Id);     
                } 
                for(Case caseRec : newCaseList){
                    if(Schema.SObjectType.Case.getRecordTypeInfosById().get(caseRec.RecordTypeId).getname()==HAE_ApexUtil.HAE_CONTRACT_REQUEST_RECORD_TYPE_NAME && caseRec.SuppliedEmail != NULL && caseRec.Origin == 'Email'){
                        if(subjectToCR.containsKey(caseRec.Subject)){
                            caseRec.HAE_Contract_Request__c = subjectToCR.get(caseRec.Subject); 
                        }
                    }    
                }
            }
        }
    }
    /**
    * @name                     :   autoForwardPOToGHX
    * @param(s):    newCaseList :   List of new version of case records.   
    *               newCaseMap  :   A map of IDs to the new versions of the case records
    *               oldCaseList :   List of old version of case records.
    *               oldCaseMap  :   A map of IDs to the old versions of the case records                
    * @description              :   This method is responsible to auto forward emails with PO to GHX.
    * @date: 23 Dec, 2019
    * 
    **/ 
    private static void autoForwardPOToGHX(List<Case> newCaseList, Map<id,Case> newCaseMap, List<Case> oldCaseList, Map<id,Case> oldCaseMap){
        system.debug('autoForwardPOToGHX called');
        Set<Id> caseIdSet = new Set<Id>();
        List<Case> caseList = new List<Case>();
        List<Auto_Forwarding_Email_Setting__mdt> regionNA = new List<Auto_Forwarding_Email_Setting__mdt>();
        List<Auto_Forwarding_Email_Setting__mdt> regionEMEA = new List<Auto_Forwarding_Email_Setting__mdt>();
        List<Auto_Forwarding_Email_Setting__mdt> regionANZ = new List<Auto_Forwarding_Email_Setting__mdt>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Map<Id, EmailMessage> caseIdToEmailMessageMap = new Map<Id, EmailMessage>();
        for(Case caseRec : newCaseList){
            Case caseOldVersion  = oldCaseMap.get(caseRec.id);
            if(caseRec.Category__c != caseOldVersion.Category__c && caseRec.Category__c == HAE_ApexUtil.HAE_CASE_CATEGORY_TO_GHX){
                caseList.add(caseRec); 
                caseIdSet.add(caseRec.Id);
            }    
        }  
        if(!caseIdSet.isEmpty()){
            for(Case caseRec : [SELECT Id, (SELECT Id, Headers,Subject, MessageDate, HtmlBody,BccAddress,CcAddress, TextBody FROM EmailMessages ORDER BY MessageDate DESC LIMIT 1 ) FROM Case  WHERE Id IN : caseIdSet ]){
                if(caseRec.EmailMessages != NULL && caseRec.EmailMessages.size() > 0){
                    caseIdToEmailMessageMap.put(caseRec.Id,caseRec.EmailMessages);
                }
            }
        }
        for(Auto_Forwarding_Email_Setting__mdt af : [SELECT Id, HAE_Active__c, HAE_Case_Group_Name__c,HAE_Case_Region__c, HAE_Outgoing_Mailbox__c FROM Auto_Forwarding_Email_Setting__mdt WHERE HAE_Active__c = true]){
            if(af.HAE_Case_Region__c == HAE_ApexUtil.HAE_REGION_NA){
                regionNA.add(af);   
            }
            if(af.HAE_Case_Region__c == HAE_ApexUtil.HAE_REGION_ANZ){
                regionANZ.add(af);   
            }
            if(af.HAE_Case_Region__c == HAE_ApexUtil.HAE_REGION_EMEA){
                regionEMEA.add(af);   
            }
        }
        
        for(Case caseRec : caseList){ 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {};
                if(caseIdToEmailMessageMap.containskey(caseRec.Id)){
                    EmailMessage message = caseIdToEmailMessageMap.get(caseRec.Id); 
                    String caseRegion = String.isBlank(caseRec.HAE_Region2__c) ? caseRec.HAE_Region__c : caseRec.HAE_Region2__c;
                    if(message != NULL && !String.isBlank(caseRegion) ){
                        if(caseRegion == HAE_ApexUtil.HAE_REGION_NA){
                            if(!regionNA.isEmpty()){
                                for(Auto_Forwarding_Email_Setting__mdt af_NA : regionNA){
                                    if(caseRegion == af_NA.HAE_Case_Region__c && caseRec.HAE_Case_Group__c == af_NA.HAE_Case_Group_Name__c){
                                        toAddresses.add(af_NA.HAE_Outgoing_Mailbox__c); 
                                    }
                                } 
                            }    
                        }
                        if(caseRegion == HAE_ApexUtil.HAE_REGION_EMEA){
                            if(!regionEMEA.isEmpty()){
                                for(Auto_Forwarding_Email_Setting__mdt af_EMEA : regionEMEA){
                                    if(caseRegion == af_EMEA.HAE_Case_Region__c && caseRec.HAE_Case_Group__c == af_EMEA.HAE_Case_Group_Name__c){
                                        toAddresses.add(af_EMEA.HAE_Outgoing_Mailbox__c);  
                                    }
                                } 
                            }    
                        } 
                        if(caseRegion== HAE_ApexUtil.HAE_REGION_ANZ){
                            if(!regionEMEA.isEmpty()){
                                for(Auto_Forwarding_Email_Setting__mdt af_ANZ : regionANZ){
                                    if(caseRegion == af_ANZ.HAE_Case_Region__c && caseRec.HAE_Case_Group__c == af_ANZ.HAE_Case_Group_Name__c){
                                        toAddresses.add(af_ANZ.HAE_Outgoing_Mailbox__c);  
                                    }
                                } 
                            }    
                        }
                        if(message.HtmlBody != NULL ){
                            mail.setHtmlBody(message.HtmlBody);    
                        }
                        if(message.TextBody != NULL ){
                            mail.setPlainTextBody(message.TextBody);    
                        }
                        if(message.Subject != NULL ){
                            mail.setSubject(message.Subject);    
                        }
                        if(message.BccAddress != NULL){
                            String[] bccAddress = new String[] {};
                                bccAddress.add(message.BccAddress);
                            mail.setBccAddresses(bccAddress);
                        }
                        if(message.CcAddress != NULL){
                            String[] ccAddress = new String[] {};
                                ccAddress.add(message.CcAddress);
                            mail.setCcAddresses(ccAddress);
                        }
                        if(!toAddresses.isEmpty()){
                            mail.setToAddresses(toAddresses);
                            emailList.add(mail);
                        }
                    }
                }
        }  
        if(!emailList.isEmpty()){
            try{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }
            }catch(exception e){
                system.debug('Email Error '+e);
            }
        }
    }
    /**
    * @name:        caseDetailsUpdateOnAutoCreate
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to assign default Case Group and Region On Auto-Creation of case.
    * @date: 20 Dec, 2019
    * 
    **/ 
    private static void caseDetailsUpdateOnAutoCreate(List<Case> newCaseList){
        Map<String,HAE_Case_Category_Assignment__mdt> categoryAssignmentMap = new Map<String,HAE_Case_Category_Assignment__mdt>();
        for(HAE_Case_Category_Assignment__mdt caseCategory : [SELECT HAE_Case_Record_Type__c, HAE_Default_Category__c, HAE_Default_Region__c, HAE_Active__c FROM HAE_Case_Category_Assignment__mdt WHERE HAE_Active__c = true] ){
            categoryAssignmentMap.put(caseCategory.HAE_Case_Record_Type__c,caseCategory);
        }
        for(Case caseRec :  newCaseList){
            if(caseRec.SuppliedEmail != NULL ){
                String recordType = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseRec.RecordTypeId).getname();            
                if(categoryAssignmentMap.containsKey(recordType)){
                    HAE_Case_Category_Assignment__mdt settings = categoryAssignmentMap.get(recordType);  
                    if(settings != NULL){
                        if(caseRec.HAE_Region__c == NULL){
                            if(settings.HAE_Default_Region__c != NULL){
                                caseRec.HAE_Region__c = settings.HAE_Default_Region__c;
                            }
                        }
                        if(caseRec.Category__c == NULL){
                            if(settings.HAE_Default_Category__c != NULL){
                                caseRec.Category__c = settings.HAE_Default_Category__c;   
                            }   
                        }
                    }
                }
            }
        }  
    }
    /**
    * @name:        duplicatePreventionofCase
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to identify duplicate cases based on Case subject and suppliedemail.
    * @date: 20 Dec, 2019
    * 
    **/ 
    public static void duplicatePreventionofCase(List<Case> newCaseList){       

        List<String> emailSubjectsList = new List<String>();
        List<String> emailRESubjectsList = new List<String>(); 
        List<String> emailExtractRESubjectsList = new List<String>(); 
        List<Case> caseREList = new List<Case>();
        List<Case> caseExtractREList = new List<Case>();
        List<Case> existingCaseList = new List<Case>();
        Boolean duplicateFound = false;
        final String RE1 = System.Label.HAE_EmailMessage_RE_1;//RE:
        final String RE2 = System.Label.HAE_EmailMessage_RE_2;//Re:
        final String REF1 = System.Label.HAE_EmailMessage_REF_1;//ref:
        final String REF2 = System.Label.HAE_EmailMessage_REF_2;//:ref
        
        String userType = UserInfo.getUserType();

        if(newCaseList != null && !newCaseList.isEmpty()){
            for(Case caseRec : newCaseList){
                if(caseRec.SuppliedEmail <> NULL && userType <> HAE_ApexUtil.HAE_USER_TYPE_STANDARD){
                    if(caseRec.Subject <> null && ((caseRec.Subject).startsWith(RE1) ||(caseRec.Subject).startsWith(RE2)) && !(caseRec.Subject).contains(REF1) && !(caseRec.Subject).contains(REF2)){
                        emailRESubjectsList.add(caseRec.Subject);
                        if((caseRec.Subject).startsWith(RE1))
                            emailExtractRESubjectsList.add((caseRec.Subject).removeStart(RE1).trim());
                        else if((caseRec.Subject).startsWith(RE2)){
                            emailExtractRESubjectsList.add((caseRec.Subject).removeStart(RE2).trim());
                        }
                    }
                    else if(caseRec.Subject <> null && !(caseRec.Subject).startsWith(RE1) && !(caseRec.Subject).startsWith(RE2) && !(caseRec.Subject).contains(REF1) && !(caseRec.Subject).contains(REF2)){
                        emailSubjectsList.add(caseRec.Subject); 
                    } 
                }
            }
        
        
            if(emailRESubjectsList <> null && !emailRESubjectsList.isEmpty() && !duplicateFound){
                caseREList = [SELECT Id, Subject FROM Case WHERE Subject IN :emailRESubjectsList];
                if(caseREList <> null && !caseREList.isEmpty()){
                    for(Case newCaseRec : newCaseList){
                        for(Case oldCaseRec : caseREList){
                            if(oldCaseRec.Subject.equals(newCaseRec.Subject)){
                                newCaseRec.HAE_Duplicate__c = true;
                                newCaseRec.ParentId = oldCaseRec.Id;
                                duplicateFound = true;
                            }    
                        } 
                    }   
                }
            }

            if(emailExtractRESubjectsList <> null && !emailExtractRESubjectsList.isEmpty() && !duplicateFound){
                caseExtractREList = [SELECT Id, Subject FROM Case WHERE Subject IN :emailExtractRESubjectsList];
                if(caseExtractREList <> null && !caseExtractREList.isEmpty()){
                    for(Case newCaseRec : newCaseList){                        
                        for(Case oldCaseRec : caseExtractREList){
                            if(oldCaseRec.Subject.equals(newCaseRec.Subject.removeStart(RE1).trim()) || oldCaseRec.Subject.equals(newCaseRec.Subject.removeStart(RE2).trim())){
                                newCaseRec.HAE_Duplicate__c = true;
                                newCaseRec.ParentId = oldCaseRec.Id;
                                duplicateFound = true;
                            }    
                        } 
                    }   
                }
            }

            if(emailSubjectsList <> null && !emailSubjectsList.isEmpty() && !duplicateFound){
                existingCaseList = [SELECT Id, Subject, SuppliedEmail FROM Case WHERE Subject IN :emailSubjectsList]; 
                if(existingCaseList <> null && !existingCaseList.isEmpty()){
                    for(Case newCaseRec : newCaseList){
                        for(Case oldCaseRec : existingCaseList){
                            if((oldCaseRec.Subject.equals(newCaseRec.Subject.removeStart(RE1).trim()) || oldCaseRec.Subject.equals(newCaseRec.Subject.removeStart(RE2).trim())) && oldCaseRec.SuppliedEmail == newCaseRec.SuppliedEmail)
                                newCaseRec.HAE_Duplicate__c = true; 
                                newCaseRec.ParentId = oldCaseRec.Id;
                                duplicateFound = true;
                        }
                    }
                }    
            }
        }
    }
    /**
    * @name:        contractsCaseTypeValidation
    * @param(s):    newCaseList :   List of new version of cases.   
    * @description: This method is responsible to validate case of type contracts.
    * @date: 20 Dec, 2019
    * 
    **/
    public static void contractsCaseTypeValidation(List<Case> newCaseList){  
        Map<String,String> mapofCaseRecordTypeIdandName = new Map<String,String>();
        Map<String,String> queueNameToIdMap = new Map<String,String>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(HAE_ApexUtil.HAE_CASE).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();    
        List<Group> groupList = new List<Group>([SELECT Id, Name FROM GROUP WHERE TYPE = 'Queue' AND Name ='Contracts' LIMIT 1]);
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            mapofCaseRecordTypeIdandName.put(info.getRecordTypeId(),info.getName());
        }
        for(Case newCaseRec : newCaseList){
            if((mapofCaseRecordTypeIdandName.get(newCaseRec.RecordTypeId)).equals(HAE_ApexUtil.HAE_Customer_Service_Contracts)){
                if(!newCaseRec.HAE_Transfer_Contracts__c){
                    newCaseRec.addError(System.Label.HAE_CS_ContractsCaseValidationMsg);
                }                
            }
            
        }
        
    }
               
               
}