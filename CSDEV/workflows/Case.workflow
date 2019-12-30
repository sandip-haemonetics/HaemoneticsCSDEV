<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_does_not_meet_SLA</fullName>
        <description>Case does not meet SLA</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforcetest@haemonetics.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Software_Support/Software_Support_case_update</template>
    </alerts>
    <alerts>
        <fullName>Customer_Service_Case_Closed_Omega</fullName>
        <description>Customer Service Case Closed Omega</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Customer_Service_Response_Omega</template>
    </alerts>
    <alerts>
        <fullName>Customer_Service_Case_OPEN</fullName>
        <description>Customer Service Case OPEN</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Customer_Service_Response_Case_Open</template>
    </alerts>
    <alerts>
        <fullName>Email_Customer_Closed_Case</fullName>
        <description>Email Customer Closed Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/Case_Closed_Notification</template>
    </alerts>
    <alerts>
        <fullName>HAE_Automated_Case_Closed_Notification_To_Contact_Email_Alert</fullName>
        <description>HAE Automated Case Closed Notification To Contact Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Automated_Case_Closed_Notification_To_Contact</template>
    </alerts>
    <alerts>
        <fullName>HAE_Automated_Case_Closed_Notification_To_Web_Email_Email_Alert</fullName>
        <description>HAE Automated Case Closed Notification To Web Email Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Automated_Case_Closed_Notification_To_Web_Email</template>
    </alerts>
    <alerts>
        <fullName>HAE_Case_Status_Change_From_New_To_InProgress_Notification_To_Contact_Email_Aler</fullName>
        <description>HAE Case Status Change From New To InProgress Notification To Contact Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Case_Status_Change_From_New_To_InProgress_Notification_To_Contact</template>
    </alerts>
    <alerts>
        <fullName>HAE_Case_Status_Change_From_New_To_InProgress_Notification_To_Web_Email_Alert</fullName>
        <description>HAE Case Status Change From New To InProgress Notification To Web Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Case_Status_Change_From_New_To_InProgress_Notification_To_Web_Email</template>
    </alerts>
    <alerts>
        <fullName>HAE_Manual_Case_Closed_Notification_To_Contact_Email_Alert</fullName>
        <description>HAE Manual Case Closed Notification To Contact Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Manual_Case_Closed_Notification_To_Contact</template>
    </alerts>
    <alerts>
        <fullName>HAE_Manual_Case_Closed_Notification_To_Web_Email_Email_Alert</fullName>
        <description>HAE Manual Case Closed Notification To Web Email Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Manual_Case_Closed_Notification_To_Web_Email</template>
    </alerts>
    <alerts>
        <fullName>HAE_New_Auto_Case_Email_Alert</fullName>
        <description>HAE New Auto Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_New_Auto_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>HAE_New_Case_Transfer_Notification_To_Contact_Email_Alert</fullName>
        <description>HAE New Case Transfer Notification To Contact Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_New_Case_Transfer_Notification_To_Contact</template>
    </alerts>
    <alerts>
        <fullName>HAE_New_Case_Transfer_Notification_To_Web_Email_Alert</fullName>
        <description>HAE New Case Transfer Notification To Web Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_New_Case_Transfer_Notification_To_Web_Email</template>
    </alerts>
    <alerts>
        <fullName>HAE_New_Manual_Case_Email_Alert</fullName>
        <description>HAE New Manual Case Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_New_Manual_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>HAE_Potential_SLA_Breach_Email_Alert</fullName>
        <description>HAE Potential SLA Breach Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HAE_Email_Templates/HAE_Potential_SLA_Breach</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Notification_BloodTrack</fullName>
        <description>New Case Notification BloodTrack</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/New_Case_Notification_BloodTrack</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Notification_Hemasphere</fullName>
        <description>New Case Notification Hemasphere</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/New_Case_Notification_Hemasphere</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Notification_Plasma</fullName>
        <ccEmails>SSDSFRelated@haemonetics.com</ccEmails>
        <description>New Case Notification Plasma</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>ssdedsupport@haemonetics.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Software_Support/New_Case_Notification_Plasma</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Notification_Surround_Symphony</fullName>
        <description>New Case Notification  Surround Symphony</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/New_Case_Notification_Surround_Symphony</template>
    </alerts>
    <alerts>
        <fullName>Notifies_Case_Owner_that_a_case_is_Open_Longer_than_2_days</fullName>
        <description>Notifies Case Owner that a case is Open Longer than 2 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>hwhite@haemonetics.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Open_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Notifies_Crystal_Bunch_that_a_new_case_is_created</fullName>
        <description>Notifies PAS - MG1 that a new case is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>ksalemme@haemonetics.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mesagendorph@haemonetics.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Donor_Division_Templates/A_NEW_CASE_ASSIGNED</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_Change</fullName>
        <description>Notify Case Owner Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Software_Support/Case_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Plasma_Case_Closure</fullName>
        <ccEmails>SSDSFRelated@haemonetics.com</ccEmails>
        <description>Plasma Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>ssdedsupport@haemonetics.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Software_Support/Case_Closed_Notification_Plasma</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Case_Owner_Jira_Ticket_Approved</fullName>
        <description>Send Email To Case Owner Jira Ticket Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/CR_Jira_Ticket_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Case_Owner_Jira_Ticket_Denied</fullName>
        <description>Send Email To Case Owner Jira Ticket Denied</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/CR_Jira_Ticket_Denied</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Manager_for_Jira_Approval</fullName>
        <description>Send Email To Manager for Jira Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/CR_Jira_Ticket_Approval</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Unknown_Contact</fullName>
        <description>Send Email To Unknown Contact</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/New_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Unknown_Plasma_Contact</fullName>
        <ccEmails>SSDSFRelated@haemonetics.com</ccEmails>
        <description>Send Email To Unknown Plasma Contact</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>ssdedsupport@haemonetics.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Software_Support/New_Case_Notification_Plasma_No_Contact</template>
    </alerts>
    <alerts>
        <fullName>Send_case_owner_of_new_comment</fullName>
        <description>Send case owner of new comment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Software_Support/Case_Comment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Additional_Complaint_Investigation</fullName>
        <field>TimeStamp_Complaint_Investigation__c</field>
        <formula>NOW()</formula>
        <name>Additional Complaint Investigation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Awaiting_PCRC_TimeStamp</fullName>
        <field>TimeStamp_PCCB_Action__c</field>
        <formula>NOW()</formula>
        <name>Awaiting PCRC TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Unit_Blood</fullName>
        <field>Business_Unit__c</field>
        <literalValue>Blood</literalValue>
        <name>Business Unit -Blood</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Unit_Hospital</fullName>
        <field>Business_Unit__c</field>
        <literalValue>Hospital</literalValue>
        <name>Business Unit - Hospital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Unit_Plasma</fullName>
        <field>Business_Unit__c</field>
        <literalValue>Plasma</literalValue>
        <name>Business Unit - Plasma</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Flag_for_Send_Email</fullName>
        <description>Change Flag in Case, calling Send Email for Owner</description>
        <field>Send_Email_If_Status_Completed__c</field>
        <literalValue>1</literalValue>
        <name>Change Flag for Send Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clean_Subject_Line</fullName>
        <field>Subject</field>
        <formula>SUBSTITUTE(Subject  , &quot;&lt;EXTERNAL SENDER&gt;&quot;, &quot;&quot;)</formula>
        <name>Clean Subject Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_On_Hold_Group</fullName>
        <description>Clears the On Hold Group once a complaint case leaves the On Hold status.</description>
        <field>On_Hold_Group__c</field>
        <name>Clear On Hold Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Investigation</fullName>
        <field>TimeStamp_Complaint_Investigation__c</field>
        <formula>NOW()</formula>
        <name>Complaint Investigation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Complaint_Documentation</fullName>
        <field>Days_in_Complete_Complaint_Documentatio__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_Complete_Complaint_Documentatio__c )),0,PRIORVALUE( Days_in_Complete_Complaint_Documentatio__c ))+ (NOW() -  Timestamp_Complete_Complaint_Documentati__c )</formula>
        <name>Complete Complaint Documentation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Days_Additional_Complaint_Investigation</fullName>
        <field>Days_Additional_Complaint_Investigation__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_Additional_Complaint_Investigation__c )),0,PRIORVALUE(Days_Additional_Complaint_Investigation__c ))+ (NOW() -  TimeStamp_Additional_Complaint_Investiga__c )</formula>
        <name>Days Additional Complaint Investigation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Days_in_Jira_Submission</fullName>
        <field>Days_in_Jira_Submission__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_Jira_Submission__c )),0,PRIORVALUE(Days_in_Jira_Submission__c ))+ (NOW() -  TimeStamp_Jira_Submission__c )</formula>
        <name>Days in Jira Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Due_date_is_blank</fullName>
        <field>Due_Date__c</field>
        <name>Due date is blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Case_Description_pre_population</fullName>
        <description>*Used in Service:  Prepopulate the Description on the Case if Center Tech Parts &amp; Repair.</description>
        <field>Description</field>
        <formula>IF 
( 
NOT(ISBLANK(Problem_Description__c)), 
Problem_Description__c, 
RecordType.Name + &quot; for Account: &quot; + Account.Name 
)</formula>
        <name>FSL Case Description pre-population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Case_Subject_pre_population</fullName>
        <description>*Used in Service - pre-populates the Subject when a particular Record Type is chosen</description>
        <field>Subject</field>
        <formula>IF 
(
NOT(ISBLANK(Problem_Description__c)),
    LEFT(Problem_Description__c, 200),
RecordType.Name + &quot; for Account: &quot; + Account.Name 
)</formula>
        <name>FSL Case Subject pre-population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HAE_Update_ERF_Case_Owner</fullName>
        <description>HAE: It will update the ERF Case owner to CS ERF.</description>
        <field>OwnerId</field>
        <lookupValue>HAE_CS_ERF</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update ERF Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Jira_Submission</fullName>
        <field>TimeStamp_Jira_Submission__c</field>
        <formula>NOW()</formula>
        <name>Jira Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Hold_Group</fullName>
        <field>On_Hold_Group__c</field>
        <name>On Hold Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Open_Days_Update</fullName>
        <field>Days_In_Open_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_In_Open_Status__c  )),0,PRIORVALUE(Days_In_Open_Status__c  ))+  (NOW() -  TimeStamp_Open__c   )</formula>
        <name>Open Days Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCCB_Action</fullName>
        <field>Status</field>
        <literalValue>Awaiting PCRC</literalValue>
        <name>PCCB Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Due_Date</fullName>
        <description>Reset the due date when a case priority changes from High to either Low or Medium</description>
        <field>Due_Date__c</field>
        <name>Reset Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Jira_Approved</fullName>
        <field>CR_Approved__c</field>
        <name>Reset Jira Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Approved_Date_Time</fullName>
        <field>CR_Approved_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set CR Approved Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Denied</fullName>
        <field>CR_Approved__c</field>
        <literalValue>No</literalValue>
        <name>Set CR Denied</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Owner_To_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Software_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner To Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Complaint_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Software_Support_Complaint</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Complaint Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Due_Date_Plus_2_hours</fullName>
        <field>Due_Date__c</field>
        <formula>CreatedDate + 2/24</formula>
        <name>Set Due Date Plus 2 hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Due_Date_for_24_hours</fullName>
        <field>Due_Date__c</field>
        <formula>CreatedDate + 1</formula>
        <name>Set Due Date for 24 hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Due_Date_for_72_hours</fullName>
        <field>Due_Date__c</field>
        <formula>CreatedDate + 3</formula>
        <name>Set Due Date for 72 hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Due_Date_for_7_days</fullName>
        <field>Due_Date__c</field>
        <formula>CreatedDate + 7</formula>
        <name>Set Due Date for 7 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Jira_Approved</fullName>
        <field>CR_Approved__c</field>
        <literalValue>Yes</literalValue>
        <name>Set Jira Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Jira_DateTime</fullName>
        <field>CR_Approved_Date_Time__c</field>
        <formula>now()</formula>
        <name>Set Jira DateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Jira_Defect</fullName>
        <field>CR_Type__c</field>
        <literalValue>Defect</literalValue>
        <name>Set Jira Defect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Jira_to_Enhancement</fullName>
        <field>CR_Type__c</field>
        <literalValue>Enhancement</literalValue>
        <name>Set Jira to Enhancement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_to_New_CR</fullName>
        <field>Status</field>
        <literalValue>New CR</literalValue>
        <name>Set to New CR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Timestamp_Evaluate</fullName>
        <field>TimeStamp_Evaluate__c</field>
        <formula>NOW()</formula>
        <name>Timestamp Evaluate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CS_Case_Subject</fullName>
        <description>Left (10) Account Name, Case Reason, Case Detailed Reason</description>
        <field>Subject</field>
        <formula>TEXT( Reason )&amp;&quot; &quot;&amp;TEXT( Case_Detailed_Reason__c )&amp; &quot;-&quot;&amp;LEFT( Account.Name ,10)</formula>
        <name>Update CS Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_SubjectPAS</fullName>
        <field>Subject</field>
        <formula>SuppliedCompany &amp;&quot; &quot;&amp; text(Type_of_Services__c )&amp;&quot; &quot;&amp; Text(Service_Start_Date__c )</formula>
        <name>PAS Update Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed_in_Salesforce_Days</fullName>
        <field>Days_in_Completed_in_Salesforce_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_Completed_in_Salesforce_Status__c )),0,PRIORVALUE(Days_in_Completed_in_Salesforce_Status__c ))+ (NOW() - TimeStamp_Completed_In_Salesforce__c)</formula>
        <name>Update Completed in Salesforce Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed_in_Salesforce_TimeStamp</fullName>
        <field>TimeStamp_Completed_In_Salesforce__c</field>
        <formula>NOW()</formula>
        <name>Update Completed in Salesforce TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Days_New_Status</fullName>
        <field>Days_in_New_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE( Days_in_New_Status__c )),0,PRIORVALUE(Days_in_New_Status__c ))+ (NOW() - TimeStamp_New__c )</formula>
        <name>Update Days in New Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Days_in_Escalated</fullName>
        <field>Days_in_Escalated_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE( Days_in_Escalated_Status__c )),0,PRIORVALUE(Days_in_Escalated_Status__c ))+ (NOW() - TimeStamp_Escalated__c )</formula>
        <name>Update Days in Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Days_in_New_CR</fullName>
        <field>Days_in_Complaint_Investigation__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_Complaint_Investigation__c )),0,PRIORVALUE(Days_in_Complaint_Investigation__c ))+ (NOW() -  TimeStamp_Complaint_Investigation__c )</formula>
        <name>Update Days in New CR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalated_TimeStamp</fullName>
        <field>TimeStamp_Escalated__c</field>
        <formula>NOW()</formula>
        <name>Update Escalated TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Evaluate_Days</fullName>
        <field>Days_in_Evaluate_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE( Days_in_Evaluate_Status__c )),0,PRIORVALUE(Days_in_Evaluate_Status__c ))+ (NOW() - TimeStamp_Evaluate__c )</formula>
        <name>Update Evaluate Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Finalize_Documentation</fullName>
        <field>Timestamp_Complete_Complaint_Documentati__c</field>
        <formula>NOW()</formula>
        <name>Update Finalize Documentation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Progress_Days</fullName>
        <field>Days_In_In_Progress_Status__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE( Days_In_In_Progress_Status__c )),0,PRIORVALUE( Days_In_In_Progress_Status__c ))+ (NOW() -  TimeStamp_In_Progress__c )</formula>
        <name>Update In Progress Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Progress_TimeStamp</fullName>
        <field>TimeStamp_In_Progress__c</field>
        <formula>NOW()</formula>
        <name>Update In Progress TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_New_TimeStamp</fullName>
        <field>TimeStamp_New__c</field>
        <formula>NOW()</formula>
        <name>Update New TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_On_Hold_TimeStamp</fullName>
        <field>TimeStamp_On_Hold__c</field>
        <formula>NOW()</formula>
        <name>Update On Hold TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Open_TimeStamp</fullName>
        <field>TimeStamp_Open__c</field>
        <formula>NOW()</formula>
        <name>Update Open TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PCCB_Days</fullName>
        <field>Days_in_PCCB_Action__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE( Days_in_PCCB_Action__c )),0,PRIORVALUE( Days_in_PCCB_Action__c ))+ (NOW() -  TimeStamp_PCCB_Action__c  )</formula>
        <name>Update PCCB Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Region</fullName>
        <description>Update Region with Region 2</description>
        <field>HAE_Region__c</field>
        <name>Update Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reopened_Days</fullName>
        <field>Days_in_Reopened__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_Reopened__c )),0,PRIORVALUE( Days_in_Reopened__c ))+ (NOW() -  TimeStamp_Reopened__c )</formula>
        <name>Update Reopened Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reopened_TimeStamp</fullName>
        <field>TimeStamp_Reopened__c</field>
        <formula>NOW()</formula>
        <name>Update Reopened TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_on_hold_days</fullName>
        <field>Days_in_On_Hold__c</field>
        <formula>IF( ISBLANK ( PRIORVALUE(  Days_in_On_Hold__c )),0,PRIORVALUE(Days_in_On_Hold__c ))+ (NOW() -  TimeStamp_On_Hold__c )</formula>
        <name>Update on hold days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>%C2%A0Hemasphere New Case Notification</fullName>
        <actions>
            <name>New_Case_Notification_Hemasphere</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value> Hemasphere Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Software Support new case notification for  Hemasphere</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>%C2%A0Surround Symphony New Case Notification</fullName>
        <actions>
            <name>New_Case_Notification_Surround_Symphony</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value> Surround Symphony Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Software Support new case notification for  Surround Symphony</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BloodTrack New Case Notification</fullName>
        <actions>
            <name>New_Case_Notification_BloodTrack</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>BloodTrack Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Software Support new case notification for BloodTrack</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Business Unit - Blood</fullName>
        <actions>
            <name>Business_Unit_Blood</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>BloodTrack Queue,Hemasphere Queue,Surround Symphony Queue</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Business Unit - Hospital</fullName>
        <actions>
            <name>Business_Unit_Hospital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Business Unit - Plasma</fullName>
        <actions>
            <name>Business_Unit_Plasma</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Plasma Queue</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CASE OPEN</fullName>
        <actions>
            <name>Customer_Service_Case_OPEN</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Service Inquiry,Customer Service Orders,Customer Service Transfer to RxCrossroads</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CASE OPEN PAS</fullName>
        <actions>
            <name>Notifies_Crystal_Bunch_that_a_new_case_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PAS Inquiries</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CR Link Approval</fullName>
        <actions>
            <name>Set_Jira_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Jira_DateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Review CR Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Approved__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.JIRA_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Is_Complaint__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Software Support - Link an existing Jira ticket to a complaint case</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed Omega</fullName>
        <actions>
            <name>Customer_Service_Case_Closed_Omega</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Send_Omega_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Software Support,Software Support - Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Open Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Service Inquiry,Customer Service Orders,Customer Service Transfer to RxCrossroads</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notifies_Case_Owner_that_a_case_is_Open_Longer_than_2_days</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Status Update</fullName>
        <actions>
            <name>On_Hold_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>RecordType.DeveloperName= &apos;Software_Support&apos; &amp;&amp; ( IF(ISPICKVAL(PRIORVALUE(Status),&apos;On Hold&apos;) ,TRUE,FALSE) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case_Closed_Notification_Rule</fullName>
        <actions>
            <name>Email_Customer_Closed_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Checks if a case is closed.</description>
        <formula>AND(IsChanged(IsClosed),IsClosed = true , TEXT(PRIORVALUE(Status)) &lt;&gt; &quot;Reopened&quot;, TEXT(Software_Product__r.Software_Product_Family__c) != &apos;Plasma&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case_Closed_Notification_Rule_Plasma</fullName>
        <actions>
            <name>Plasma_Case_Closure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Checks if a case is closed. PLASMA only</description>
        <formula>AND(IsChanged(IsClosed),IsClosed = true , TEXT(PRIORVALUE(Status)) &lt;&gt; &quot;Reopened&quot;, TEXT(Software_Product__r.Software_Product_Family__c) = &apos;Plasma&apos;,  RecordType.Name = &apos;Software Support&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clean Subject</fullName>
        <actions>
            <name>Clean_Subject_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>&lt;EXTERNAL SENDER&gt;</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FSL Receive notification if part has been sent to Center but no repair has been done</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Order Completed in Salesforce</value>
        </criteriaItems>
        <description>Cons 164 &amp; Cons 170-Receive notification if part has been sent to Center but no repair has been done</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_Flag_for_Send_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HAE%3A Update Region picklist with Region formula</fullName>
        <actions>
            <name>Update_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Used to update picklist with formula to drive dependency</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Is Complaint Record Type</fullName>
        <actions>
            <name>Set_Complaint_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_to_New_CR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Is_Complaint__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Software Support - Change record type to Complaint if Complaint = Yes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Link Enhancement Jira</fullName>
        <actions>
            <name>Set_Jira_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Jira_DateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Is_Complaint__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Complaint_Reasoning__c</field>
            <operation>equals</operation>
            <value>Enhancement Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Approved__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.JIRA_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Description__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Software Support - Link an enhancement Jira ticket to a case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Case Notification %E2%80%93 Plasma No Contact</fullName>
        <actions>
            <name>Send_Email_To_Unknown_Plasma_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support,Software Support - Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Plasma Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Enhancement Jira</fullName>
        <actions>
            <name>Set_Jira_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Jira_DateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Is_Complaint__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Complaint_Reasoning__c</field>
            <operation>equals</operation>
            <value>Enhancement Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Approved__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.JIRA_Id__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Software Support - Create a new enhancement Jira ticket and link it to a case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify_Case_Owner_Of_New_Comment</fullName>
        <actions>
            <name>Send_case_owner_of_new_comment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Is_Owned_By_Queue__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifies the case owner of a new comment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify_Case_Owner_Of_New_Ownership</fullName>
        <active>true</active>
        <description>Notify the case owner if a new case is assigned to them. Do not notify the queue if the case owner goes from user to queue.</description>
        <formula>ISCHANGED(OwnerId) &amp;&amp; LEFT(PRIORVALUE(OwnerId), 3) = &apos;005&apos;  &amp;&amp;  LEFT(OwnerId, 3) = &apos;005&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Past Due SLA Priority Critical</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Hold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_does_not_meet_SLA</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Past Due SLA Priority High</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Hold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_does_not_meet_SLA</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Past Due SLA Priority Low</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Hold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_does_not_meet_SLA</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Past Due SLA Priority Medium</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Reopened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Customer_Hold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_does_not_meet_SLA</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Plasma New Case Notification</fullName>
        <actions>
            <name>New_Case_Notification_Plasma</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Plasma Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Software Support new case notification for Plasma</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Reset Due Date On Cases High Priority Change</fullName>
        <actions>
            <name>Reset_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support - Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <description>Check if the Priority changes to a lesser priority.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Priority Critical</fullName>
        <actions>
            <name>Set_Due_Date_Plus_2_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR ( 
AND(
 Owner:Queue.QueueName = &quot;Plasma Queue&quot; ,
 ISPICKVAL(Priority , &quot;Critical&quot;)  ),  
AND (      ISPICKVAL(Software_Product__r.Software_Product_Family__c , &quot;Plasma&quot; ),      ISPICKVAL(Priority , &quot;Critical&quot;)      )
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Priority High</fullName>
        <actions>
            <name>Set_Due_Date_for_24_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR ( 
AND( 
Owner:Queue.QueueName = &quot;Plasma Queue&quot; , 
ISPICKVAL(Priority , &quot;High&quot;) ), 
AND ( ISPICKVAL(Software_Product__r.Software_Product_Family__c , &quot;Plasma&quot; ), ISPICKVAL(Priority , &quot;High&quot;) ) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Priority Low</fullName>
        <actions>
            <name>Set_Due_Date_for_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR ( 
AND( 
Owner:Queue.QueueName = &quot;Plasma Queue&quot; , 
ISPICKVAL(Priority , &quot;Low&quot;) ), 
AND ( ISPICKVAL(Software_Product__r.Software_Product_Family__c , &quot;Plasma&quot; ), ISPICKVAL(Priority , &quot;Low&quot;) ) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Priority Medium</fullName>
        <actions>
            <name>Set_Due_Date_for_72_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR ( 
AND( 
Owner:Queue.QueueName = &quot;Plasma Queue&quot; , 
ISPICKVAL(Priority , &quot;Medium&quot;) ), 
AND ( ISPICKVAL(Software_Product__r.Software_Product_Family__c , &quot;Plasma&quot; ), ISPICKVAL(Priority , &quot;Medium&quot;) ) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Unknown Customer Case Notification - Software Support</fullName>
        <actions>
            <name>Send_Email_To_Unknown_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support,Software Support - Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Software Support,BloodTrack Queue,Hemasphere Queue,Surround Symphony Queue</value>
        </criteriaItems>
        <description>Send an email to the user if their email does not match a known contact in salesforce.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Due Date On High Priority Cases</fullName>
        <actions>
            <name>Set_Due_Date_for_24_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Jira Type - Defect</fullName>
        <actions>
            <name>Set_Jira_Defect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support - Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Jira Type -Enhancement</fullName>
        <actions>
            <name>Set_Jira_to_Enhancement</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set PCCB Action</fullName>
        <actions>
            <name>PCCB_Action</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support - Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Approved__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <description>Software Support - Set Status to PCCB Action when a Jira ticket is successfully linked to a complaint case or a new Jira ticket has been created and linked to a complaint case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Software Support Clear On Hold Group</fullName>
        <actions>
            <name>Clear_On_Hold_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggered once a software support case leaves the on hold status.</description>
        <formula>RecordType.DeveloperName= &apos;Software_Support_Complaint&apos; &amp;&amp; ( IF(ISPICKVAL(PRIORVALUE(Status),&apos;On Hold&apos;) ,TRUE,FALSE) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Software Support Complaint Clear On Hold Group</fullName>
        <actions>
            <name>Clear_On_Hold_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggered once a software support complaint case leaves the on hold status.</description>
        <formula>RecordType.DeveloperName= &apos;Software_Support_Complaint&apos; &amp;&amp; ( IF(ISPICKVAL(PRIORVALUE(Status),&apos;On Hold&apos;) ,TRUE,FALSE) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Software Support Default Community Case</fullName>
        <actions>
            <name>Set_Case_Owner_To_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>CONTAINS($Profile.Name, &quot;Customer Community&quot;) &amp;&amp; CONTAINS($Profile.Name,&quot;Software Support&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Time Specific Checkbox Enabled</fullName>
        <actions>
            <name>Due_date_is_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Time_Specific__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Software Support,Software Support - Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Additional Complaint Investigation TimeStamp</fullName>
        <actions>
            <name>Additional_Complaint_Investigation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Investigate</value>
        </criteriaItems>
        <description>When case reaches status Additional Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Awaiting PCRC Days</fullName>
        <actions>
            <name>Update_PCCB_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Awaiting PCRC&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update CS Case Subject</fullName>
        <actions>
            <name>Update_CS_Case_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Service Inquiry,Customer Service Orders</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Complaint Investigation Days</fullName>
        <actions>
            <name>Update_Days_in_New_CR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status In Progress change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;New CR&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Complaint Investigation TimeStamp</fullName>
        <actions>
            <name>Complaint_Investigation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New CR</value>
        </criteriaItems>
        <description>When case reaches status Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Complete Complaint Documentation TimeStamp</fullName>
        <actions>
            <name>Update_Finalize_Documentation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Finalize Documentation</value>
        </criteriaItems>
        <description>When case reaches status Additional Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Completed in Salesforce Days</fullName>
        <actions>
            <name>Update_Completed_in_Salesforce_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status Completed in Salesforce change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Order Completed in Salesforce&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Completed in Salesforce TimeStamp</fullName>
        <actions>
            <name>Update_Completed_in_Salesforce_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Order Completed in Salesforce</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Escalated Days</fullName>
        <actions>
            <name>Update_Days_in_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status Escalated change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Escalated&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Escalated TimeStamp</fullName>
        <actions>
            <name>Update_Escalated_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Evaluate Days</fullName>
        <actions>
            <name>Update_Evaluate_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status Evaluate change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Evaluate&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Evaluate TimeStamp</fullName>
        <actions>
            <name>Timestamp_Evaluate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Evaluate</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Finalize Documentation Days</fullName>
        <actions>
            <name>Complete_Complaint_Documentation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Finalize Documentation	&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update In Progress Days</fullName>
        <actions>
            <name>Update_In_Progress_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status In Progress change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;In Progress&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update In Progress TimeStamp</fullName>
        <actions>
            <name>Update_In_Progress_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Investigate Days</fullName>
        <actions>
            <name>Days_Additional_Complaint_Investigation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Investigate&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Jira Submission Days</fullName>
        <actions>
            <name>Days_in_Jira_Submission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Review CR Submission&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Jira Submission TimeStamp</fullName>
        <actions>
            <name>Jira_Submission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Review CR Submission</value>
        </criteriaItems>
        <description>When case reaches status Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update New Days</fullName>
        <actions>
            <name>Update_Days_New_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status New change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;New&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update New TimeStamp</fullName>
        <actions>
            <name>Update_New_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update On Hold Days</fullName>
        <actions>
            <name>Update_on_hold_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;On Hold&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update On Hold TimeStamp</fullName>
        <actions>
            <name>Update_On_Hold_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>When case reaches status Additional Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Open Hours</fullName>
        <actions>
            <name>Open_Days_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status Open change timestamp to now</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Open&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Open TimeStamp</fullName>
        <actions>
            <name>Update_Open_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>When case reaches status Open change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update PAS Case Subject</fullName>
        <actions>
            <name>Update_Case_SubjectPAS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>HaemoNet</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update PCCB TimeStamp</fullName>
        <actions>
            <name>Awaiting_PCRC_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting PCRC</value>
        </criteriaItems>
        <description>When case reaches status Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Reopened Days</fullName>
        <actions>
            <name>Update_Reopened_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case reaches status  Jira Submission update days for status</description>
        <formula>AND ( ISCHANGED (Status), ISPICKVAL( PRIORVALUE (Status), &apos;Reopened&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Reopened TimeStamp</fullName>
        <actions>
            <name>Update_Reopened_TimeStamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Reopened</value>
        </criteriaItems>
        <description>When case reaches status Additional Complaint Investigation change timestamp to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>reset Jira Approval</fullName>
        <actions>
            <name>Reset_Jira_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CR_Approved__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CR_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
