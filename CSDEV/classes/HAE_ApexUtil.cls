/** Created By : Cognizant
  * Date : 13 Nov, 2019
  * Description : 
  *        This class is responsible to maintan all constant value in one place.         
**/
public class HAE_ApexUtil {
    // This flag is responsible for handling recusive trigger.
    public static boolean flag = true;
    public static boolean flagForTask = true;    
    public static boolean flagForChildCase  = true;
    public static final String GHX_CONTENT_INTELLIGENCE_SENDER_ADDRESS = System.Label.HAE_GHXContentIntelligence_Mailbox;//GHXContentIntelligence@ghx.com
    public static final String ORDER_NA_MAILBOX = System.Label.HAE_OrderSNA_Mailbox;//OrderSNA.test@haemonetics.com
    public static final String HAE_GHX_RECORD_TYPE_NAME = System.Label.HAE_GHX_Record_Type_Name;//Customer Service: GHX
    public static final String CASE_PRIORITY_HIGH = System.Label.HAE_CASE_PRIORITY_HIGH;
    public static final String CASE_PRIORITY_MEDIUM = System.Label.HAE_CASE_PRIORITY_MEDIUM;
    public static final String CASE_PRIORITY_LOW = System.Label.HAE_CASE_PRIORITY_LOW;
    public static final String INSERT_ACTION = 'INSERT';
    public static final String UPDATE_ACTION = 'UPDATE';
    public static final String CASE_CLOSED_STATUS = System.Label.HAE_Closed_Case_Status;
    public static final String CASE_NEW_STATUS = System.Label.HAE_New_Case_Status;
    public static final String HAE_CONTRACT_REQUEST_RECORD_TYPE_NAME = System.Label.HAE_CS_Contract_Request_Record_Type_Name;//Customer Service: Contract Request
    public static final String HAE_DEFAULT_CASE_GROUP_NA = System.Label.HAE_Case_Group_CS_NA;
    public static final String HAE_CASE = 'Case';
    public static final String HAE_CASE_CATEGORY_STATUS_CONTRACT_HOURS = System.Label.HAE_Case_Category_Status_For_Contract_Hours;
    public static final String HAE_Customer_Service_Inquiry = System.Label.HAE_Customer_Service_Inquiry;
    public static final String HAE_Customer_Service_Contracts = System.Label.HAE_CS_Contracts_Record_Type_Name;//Customer Service: Contracts
    public static final String HAE_USER_TYPE_STANDARD =  System.Label.HAE_Standard;//Standard
    public static final String HAE_REGION_NA =  System.Label.HAE_Region_NA;
    public static final String HAE_REGION_ANZ = 'ANZ';
    public static final String HAE_REGION_EMEA = 'EMEA';
    public static final String HAE_CASE_CATEGORY_TO_GHX = System.Label.HAE_Case_Category_Order_Submitted_to_GHX;//Order Submitted to GHX
    
    

    /** 
    Used in Classes:
            HAE_UserOperatingUnitTriggerHandler
            HAE_AccountTriggerHandler
    
    Used in Triggers:
            HAE_UserOperatingUnitTrigger
    **/

    public static final String TEAM_MEMBER_ROLE = System.Label.CS_Account_Manager;
    public static final String ROW_CAUSE = 'Manual';
    public static final String ACCESS_LEVEL_READ = 'Read';
    public static final String ACCESS_LEVEL_EDIT = 'Edit';
    public static final String OPERATION_INSERT = 'Insert';
    public static final String OPERATION_UPDATE = 'Update';
    public static final String OPERATION_DELETE = 'Delete'; 

    public static final String GX_ACCOUNT_NAME = System.Label.HAE_GX_Account_Name;
    public static final String GX_CONTACT_NAME = System.Label.HAE_GX_CONTACT_NAME;
    public static final String GX_INTEGRATION_SERVER_EMAIL = System.Label.HAE_GX_INTEGRATION_SERVER_EMAIL;
    public static final String ORDER_INTEGRATION_SERVER_EMAIL = System.Label.HAE_Order_Integration_Server_Email;
    public static final String RECEIVED_CASE = System.Label.HAE_Received_Case;

    public static final String PO_NUMBER_FORMAT1 = System.Label.HAE_PO_NUMBER_FORMAT1;
    public static final String PO_NUMBER_FORMAT2 = System.Label.HAE_PO_NUMBER_FORMAT2;
    public static final String PO_NUMBER_FORMAT3 = System.Label.HAE_PO_NUMBER_FORMAT3;
    public static final String PO_NUMBER_FORMAT4 = System.Label.HAE_PO_NUMBER_FORMAT4;
    public static final String PO_NUMBER_FORMAT5 = System.Label.HAE_PO_NUMBER_FORMAT5;
    public static final String PO_NUMBER_FORMAT6 = System.Label.HAE_PO_NUMBER_FORMAT6;


    /** Email Message Status Possible values are:
     *  0 = New
     *  1 = Read
     *  2 = Replied
     *  3 = Sent
     *  4 = Forwarded
     *  5 = Draft
     **/
    public static final String EMIAL_MESSAGE_NEW_STATUS = '0';
    public static final String EMIAL_MESSAGE_READ_STATUS = '1';
    public static final String EMIAL_MESSAGE_REPLIED_STATUS = '2';
    public static final String EMIAL_MESSAGE_SENT_STATUS = '3';
    public static final String EMIAL_MESSAGE_FORWARDED_STATUS = '4';
    public static final String EMIAL_MESSAGE_DRAFT_STATUS = '5';
        
    public static final String CASE_RECORD_TYPE_DEVELOPER_NAME_SOFTWARE_SUPPORT = System.Label.HAE_Software_Support; //Software_Support
    public static final String CASE_RECORD_TYPE_DEVELOPER_NAME_PHONE_FIX = System.Label.HAE_Phone_Fix;//Phone_Fix
    public static final String CASE_RECORD_TYPE_DEVELOPER_NAME_CONTRACTS = System.Label.HAE_Customer_Service_Contracts;//HAE_Customer_Service_Contracts
    public static final String TRANSACTIONAL_ACCOUNT_RECORD_TYPE_DEVELOPER_NAME = System.Label.HAE_Transactional_Account;//Transactional_Account
    public static final String SYSTEM_USER = System.Label.HAE_System;//System
    public static final String SHIP_TO_ACCOUNT_TYPE = System.Label.HAE_Ship_To;//Ship To
    public static final String BILL_TO_ACCOUNT_TYPE = System.Label.HAE_Bill_To;//Bill To
    public static final String CASE_OWNER_TYPE = System.Label.HAE_Queue;//Queue 
}