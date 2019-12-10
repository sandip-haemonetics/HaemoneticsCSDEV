/**
    Name: HAE_UserOperatingUnitTrigger
    Description: This User Operating Unit trigger control Operating Unit Sharing & Account Sharing
    Date: 11/12
**/

trigger HAE_UserOperatingUnitTrigger on HAE_User_Operating_Unit__c (after insert,after update, before delete) {
    switch on Trigger.OperationType{
        when AFTER_INSERT 
            {
                HAE_UserOperatingUnitTriggerHandler.maintainOperatingUnitSharing(Trigger.new, HAE_ApexUtil.OPERATION_INSERT);                
            }
        when AFTER_UPDATE
            {
                HAE_UserOperatingUnitTriggerHandler.maintainOperatingUnitSharing(Trigger.newMap , Trigger.oldMap, HAE_ApexUtil.OPERATION_UPDATE);                
            }
        when BEFORE_DELETE
            {
                HAE_UserOperatingUnitTriggerHandler.deleteOperatingUnitSharing(Trigger.old, HAE_ApexUtil.OPERATION_DELETE);
            }
    }
}