//
//This trigger calls some background jobs for Account
//
//Author: CERVELLO INC - Alexandr Kurevlev (24-07-2017)
trigger HFSL_Account on Account (before update, before delete, after insert, after update) {
    if (!HFSL_CustomSettings.triggersEnabled()) {
        System.debug(LoggingLevel.INFO, '\'HFSL_Account\' trigger is disabled!');
        return;
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        HFSL_AccountUtils.onAccountBeforeUpdate(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isDelete) {
        HFSL_AccountUtils.onAccountBeforeDelete(Trigger.old);
    }else if (Trigger.isAfter && Trigger.isInsert) {
        HAE_AccountTriggerHandler.maintainAccountSharing(Trigger.new);
    }else if (Trigger.isAfter && Trigger.isUpdate) {
        HAE_AccountTriggerHandler.maintainAccountSharing(Trigger.old, Trigger.new);
    }
}