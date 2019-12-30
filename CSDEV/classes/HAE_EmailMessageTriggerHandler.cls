/** Created By : Cognizant
* Date : 21 Nov, 2019
* Description : 
*        This class is responsible to handle all Email Message trigger logic related to Customer Service Module.         
**/
public with sharing class HAE_EmailMessageTriggerHandler {
    public static final Integer BEFORE_TEN_DAYS_COUNT = -10;
    
	/**
    * This method is calling from trigger and from this method all template methods are called.
    */
    public static void executeTrigger() {        
        if (Trigger.isBefore){ // Before Trigger operation
            if (Trigger.isInsert)
            	beforeInsert((List<EmailMessage>) Trigger.new);
            if (Trigger.isUpdate)
            	beforeUpdate((List<EmailMessage>) Trigger.new, (Map<id,EmailMessage>) Trigger.newMap, (List<EmailMessage>) Trigger.old, (Map<id,EmailMessage>) Trigger.oldMap);
            if (Trigger.isDelete)
            	beforeDelete((List<EmailMessage>) Trigger.old, (Map<id,EmailMessage>) Trigger.oldMap);
        } else { // Before Trigger operation
            if (Trigger.isInsert)
            	afterInsert((List<EmailMessage>) Trigger.new, (Map<id,EmailMessage>) Trigger.newMap);
            if (Trigger.isUpdate)
            	afterUpdate((List<EmailMessage>) Trigger.new, (Map<id,EmailMessage>) Trigger.newMap, (List<EmailMessage>) Trigger.old, (Map<id,EmailMessage>) Trigger.oldMap);
            if (Trigger.isDelete)
            	afterDelete((List<EmailMessage>) Trigger.old, (Map<id,EmailMessage>) Trigger.oldMap);
            if (Trigger.isUndelete)
            	afterUnDelete((List<EmailMessage>) Trigger.new, (Map<id,EmailMessage>) Trigger.newMap);
        }
    }
    
    
    /**
    * This method is responsible for performing all before insert operations.
    */
    private static void beforeInsert(List<EmailMessage> newEmailMessageList) {
        caseClosePostActivity(newEmailMessageList);
        checkForSensitiveInformationAndMask(newEmailMessageList);
         preventDuplicateCaseCreation(newEmailMessageList);
    }
    
    /**
    * This method is responsible for performing all before update operations.
    */
    private static void beforeUpdate(List<EmailMessage> newEmailMessageList, Map<id,EmailMessage> newEmailMessageMap, List<EmailMessage> oldEmailMessageList, Map<id,EmailMessage> oldEmailMessageMap) {        
    	
    }
    
    /**
    * This method is responsible for performing all before delete operations.
    */
    private static void beforeDelete(List<EmailMessage> oldEmailMessageList, Map<id,EmailMessage> oldEmailMessageMap) {
        
    }
    
    /**
    * This method is responsible for performing all after insert operations.
    */
    private static void afterInsert(List<EmailMessage> newEmailMessageList, Map<id,EmailMessage> newEmailMessageMap) {          
        caseStatusChangedBasedOnEmailMessageSendOrRecieved(newEmailMessageList);   
       
    }
        
    /**
    * This method is responsible for performing all after update operations.
    */
    private static void afterUpdate(List<EmailMessage> newEmailMessageList, Map<id,EmailMessage> newEmailMessageMap, List<EmailMessage> oldEmailMessageList, Map<id,EmailMessage> oldEmailMessageMap) {
        
    }
    
    /**
    * This method is responsible for performing all after delete operations.
    */
    private static void afterDelete(List<EmailMessage> oldEmailMessageList, Map<id,EmailMessage> oldEmailMessageMap) {
        
    }
        
    /**
    * This method is responsible for performing all after undelete operations.
    */
    private static void afterUnDelete(List<EmailMessage> newEmailMessageList, Map<id,EmailMessage> newEmailMessageMap) {
    }
    
    /**
    * ALL BUSINESS LOGIC ARE PERFORMED BY BELOW MENTIONED METHODS AND THEY ARE CALLED FROM ABOVE TEMPLATE.
    */
     
    /**
     * @name: caseStatusChangedBasedOnEmailMessageSendOrRecieved
     * @param(s): newEmailMessageList : List of EmailMessage.
     * @description: Case Status change based on email send or received.
     * 				1. The system should automatically change the status to Pending Customer when an email is sent to Customer 
     * 				requesting some information on the case.
     * 				2. The system should change the status to Response Received, whenever a customer email or an internal team 
     * 				communication is received and the current status of the case is Pending Customer or Pending Internal
     * 				3. The system should be able to update the status to Response received when an undelivered email is 
     * 				there in response to an email.
     * 
     * @date: 21 Nov, 2019
     **/
    private static void caseStatusChangedBasedOnEmailMessageSendOrRecieved(List<EmailMessage> newEmailMessageList){
        /* No bulkification is required here, becasue we are handaling only email-to-case message 
         * and no bulk load will be done here for this type of email sending operation.
         */
        try{
            if(newEmailMessageList != null && !newEmailMessageList.isEmpty()){
                EmailMessage emailMsg = newEmailMessageList[0];
                Id caseId = emailMsg.ParentId;
                
                List<EmailMessage> lstEmailMsg = new List<EmailMessage>();
                lstEmailMsg = [Select Id, Status From EmailMessage Where ParentId =: caseId];
                if(lstEmailMsg != null && lstEmailMsg.size() > 1){ // Checking that message is not generate on case creation time.
                    String messageStatus = emailMsg.Status;
                    if(messageStatus != null){
                        Case emlToCaseIns = [select Id, Status from Case where Id = :caseId];
                        
                        if(emlToCaseIns != null){
                            if(messageStatus == HAE_ApexUtil.EMIAL_MESSAGE_NEW_STATUS && (emlToCaseIns.Status == System.Label.HAE_Pending_Customer_Case_Status || emlToCaseIns.Status == System.Label.HAE_Pending_Internal_Case_Status)) // Check response from customer.
                                emlToCaseIns.Status = System.Label.HAE_Response_Received_Case_Status;
                            else if(messageStatus == HAE_ApexUtil.EMIAL_MESSAGE_SENT_STATUS || messageStatus == HAE_ApexUtil.EMIAL_MESSAGE_FORWARDED_STATUS) // Check reply or forwarded message to customer.
                                emlToCaseIns.Status = System.Label.HAE_Pending_Customer_Case_Status;
                        }
                		update emlToCaseIns;
                    }
                }
            }
        }catch(Exception e){
            System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
        }
    }
        
    /**
     * @name: caseClosePostActivity
     * @param(s): newEmailMessageList : List of EmailMessage.
     * @description: If status is closed but ClosedDate is not more than 10 business days then customer response should 
     * 				 be allowed else new case will be created. Based on cusgtomer response with in 10 days of close date
     * 				 case status will be update.
     * @date: 21 Nov, 2019
     **/
    private static void caseClosePostActivity(List<EmailMessage> newEmailMessageList) {
        /* No bulkification is required here, becasue we are handaling only email-to-case message 
         * and no bulk load will be done here for this type of email sending operation.
         */
        try{
            if(newEmailMessageList != null && !newEmailMessageList.isEmpty()){
                EmailMessage emailMsg = newEmailMessageList[0];
                Id caseId = emailMsg.ParentId;
                String caseCloseStatus = System.Label.HAE_Closed_Case_Status;               
                            
                List<Case> lstOfExistingClosedCaseIns = [select Id, OwnerId, ContactId, HAE_Bill_To_Account__c, ContactEmail, Status, HAE_Case_Group__c, 
                                                                recordTypeID, ClosedDate, BusinessHoursId, Subject, Description, Origin, SuppliedEmail from Case where 
                                                                Id = :caseId and
                                                                Status = :caseCloseStatus];
                if(lstOfExistingClosedCaseIns != null && !lstOfExistingClosedCaseIns.isEmpty()) {
                    //Business day calculation for 10 days.
                    DateTime dtBeforeTenDays = calculateDateBasedOnBusinessHr(lstOfExistingClosedCaseIns[0].BusinessHoursId, Datetime.now(), BEFORE_TEN_DAYS_COUNT);
                    if(dtBeforeTenDays == null)
                        dtBeforeTenDays = Date.today().addDays(BEFORE_TEN_DAYS_COUNT);
                    
                    if(lstOfExistingClosedCaseIns[0].ClosedDate < dtBeforeTenDays) { // Closed date cross 10 days
                        Case newCaseIns = new Case();                        
                        newCaseIns.recordTypeID = lstOfExistingClosedCaseIns[0].recordTypeID;
                        newCaseIns.OwnerId = lstOfExistingClosedCaseIns[0].OwnerId;
                        newCaseIns.HAE_Case_Group__c = lstOfExistingClosedCaseIns[0].HAE_Case_Group__c;
                        newCaseIns.ContactId = lstOfExistingClosedCaseIns[0].ContactId;
                        newCaseIns.Status = System.Label.HAE_New_Case_Status;
                        newCaseIns.BusinessHoursId = lstOfExistingClosedCaseIns[0].BusinessHoursId;
                        newCaseIns.Subject = lstOfExistingClosedCaseIns[0].Subject;
                        newCaseIns.Description = lstOfExistingClosedCaseIns[0].Description;
						newCaseIns.Origin = lstOfExistingClosedCaseIns[0].Origin;
                        newCaseIns.SuppliedEmail = lstOfExistingClosedCaseIns[0].SuppliedEmail;
                        
                        insert newCaseIns;
                        
                        emailMsg.ParentId = newCaseIns.Id;
                    } else{
                        /*If the customer sends an reply email within 10 business days to a case that is closed, the status on the case is 
						  changed to 'Response Received' and the Reopened flag is set to True. 
						  The Reopen Reason field is defaulted with reason text as 'Response received from customer'.*/
                            
                        List<EmailMessage> lstOfEM = [select ParentId from EmailMessage where ParentId =: caseId Limit 3];
                        
                        //Count check is required to check that the mail is coming is a reply mail but not new mail. (Scenario covere for auto closing child GHX case).
                        if(lstOfExistingClosedCaseIns[0] != null && emailMsg.Status == HAE_ApexUtil.EMIAL_MESSAGE_NEW_STATUS && (lstOfEM != null && lstOfEM.size() > 1)){
                            lstOfExistingClosedCaseIns[0].Status = System.Label.HAE_Response_Received_Case_Status;
                            lstOfExistingClosedCaseIns[0].HAE_Reopen__c = true;
                            lstOfExistingClosedCaseIns[0].HAE_Reopen_Reason__c = System.Label.HAE_Case_Reopen_Reason_System_Message;
                            
                            update lstOfExistingClosedCaseIns[0];
                        }
                    }                    
                }
            }
        } catch(exception e){
            System.debug(System.Label.HAE_Common_Exception_Message + e.getMessage());
        }
    }
	
    /**
     * @name: calculateDateBasedOnBusinessHr
     * @param(s): businessHrId : Id of the Business Hour base on which return date will be calculated.
	 *			   startDateTime : Date time from where calculation will be done.
	 *			   intervalDay : Interval count in day.
     * @description: This method is responsible to return next or previous date based on business hour, interval day 
     * 				and start date.
     * @date: 21 Nov, 2019
     **/
	private static DateTime calculateDateBasedOnBusinessHr(Id businessHrId, DateTime startDateTime, Integer intervalDay){
        if(businessHrId != NULL && startDateTime != NULL){
            return BusinessHours.addGmt(businessHrId, startDateTime, intervalDay * 24 * 60 * 60 * 1000L);
        }
        return null;
    } 
    /**
    * @name: checkForSensitiveInformationAndMask
    * @param(s):	newEmailMessageList	:	List of new version of Email Messages.  	
    * @description: This method is responsible to check and mask sensitive information in case description.
    * @date: 10 Dec, 2019
    **/
    private static void checkForSensitiveInformationAndMask(List<EmailMessage> newEmailMessageList){
        List<String> regexList = new List<String>();        
        String encryptionPattern = System.Label.HAE_Encryption_Pattern;
        Integer encryptionPatternLength = Integer.valueof(System.Label.HAE_Encryption_Length);
        for(HAE_Credit_Card_Regex__mdt regex : [SELECT HAE_Regex__c, HAE_Active__c FROM HAE_Credit_Card_Regex__mdt WHERE HAE_Active__c = true] ){
            regexList.add(regex.HAE_Regex__c);
        }
        if(!regexList.isEmpty()){
            for(EmailMessage message : newEmailMessageList){
                if (message.TextBody != null) {
                    message.TextBody = HAE_EncodingUtils.maskString(message.TextBody, regexList, encryptionPattern, encryptionPatternLength);
                    message.HTMLBody = HAE_EncodingUtils.maskString(message.HTMLBody, regexList, encryptionPattern, encryptionPatternLength);
                }
            }
        }
    }
    /**
    * @name: preventDuplicateCaseCreation
    * @param(s):	newEmailMessageList	:	List of new version of Email Messages.  	
    * @description: This method is responsible to prevent duplicate case creation when a CC recipient responds to the initial email from a customer.
    * @date: 17 Dec, 2019
    **/
    private static void preventDuplicateCaseCreation(List<EmailMessage> newEmailMessageList){
        
        List<String> emailSubjectsList = new List<String>();
        List<String> emailRESubjectsList = new List<String>();
        List<Case> duplicateCases =  new List<Case>();
        final String RE1 = System.Label.HAE_EmailMessage_RE_1;//RE:
        final String RE2 = System.Label.HAE_EmailMessage_RE_2;//Re:
        final String REF1 = System.Label.HAE_EmailMessage_REF_1;//ref:
        final String REF2 = System.Label.HAE_EmailMessage_REF_2;//:ref

        if(newEmailMessageList <> null && !newEmailMessageList.isEmpty()){
            for(EmailMessage message : newEmailMessageList){
                if(message.Subject <> null && ((message.Subject).startsWith(RE1) ||(message.Subject).startsWith(RE2))  && !(message.Subject).contains(REF1) && !(message.Subject).contains(REF2)){
                    emailRESubjectsList.add(message.Subject);
                    if((message.Subject).startsWith(RE1))
                        emailSubjectsList.add((message.Subject).removeStart(RE1).trim());
                    else if((message.Subject).startsWith(RE2)){
                        emailSubjectsList.add((message.Subject).removeStart(RE2).trim());
                    }
                }
                else if(message.Subject <> null && !(message.Subject).startsWith(RE1) && !(message.Subject).startsWith(RE2) && !(message.Subject).contains(REF1) && !(message.Subject).contains(REF2)){
                    emailSubjectsList.add(message.Subject); 
                }                  
            }   

            if(!emailRESubjectsList.isEmpty()){
                if(!emailRESubjectsList.isEmpty()){
                    for(Case caseRec : [SELECT Id, Subject, HAE_Duplicate__c, ParentId FROM Case WHERE Subject IN :emailRESubjectsList]){
                        if(caseRec.HAE_Duplicate__c){
                            duplicateCases.add(caseRec);    
                        }    
                    }    
                }
            }
            
            if(!emailSubjectsList.isEmpty()){
                for(Case caseRec : [SELECT Id, Subject, HAE_Duplicate__c, ParentId FROM Case WHERE Subject IN :emailSubjectsList]){
                    if(caseRec.HAE_Duplicate__c)
                        duplicateCases.add(caseRec);                
                }
            }

            for(EmailMessage message : newEmailMessageList){
                for(Case caseRec : duplicateCases){
                    if(caseRec.Subject.equals(message.Subject) && caseRec.ParentId <> null){
                        message.ParentId = caseRec.ParentId;
                    }
                }

            }
        
            if(duplicateCases <> null && !duplicateCases.isEmpty()){
                try{
                    delete duplicateCases;
                }
                catch(Exception ex){
                    System.debug('Exception on Duplicate Case--->'+ex.getMessage());
                }
            }
        }
    }   
}