/**
    Name: HAE_AccountTriggerHandler
    Description: This class is responsible to create/update account team member records based on operating unit
    Date: 11/12
**/

public with sharing class HAE_AccountTriggerHandler {

    public static void maintainAccountSharing(List<Account> accountList){
        
        List<AccountTeamMember> accountTeamMemberList = new list<AccountTeamMember>();
        List<AccountShare> accountShareList = new list<AccountShare>();
        Map<Id, Id> operatingUnitIdMap = new Map<Id, Id>();
        Set<Id> operatingUnitIdSet = new Set<Id>();
        List<HAE_User_Operating_Unit__c> userOperatingUnitList = new List<HAE_User_Operating_Unit__c>();

        if(accountList <> NULL && !accountList.isEmpty()){
            for(Account acc : accountList){
                if(acc.HAE_Operating_Unit__c <> null){
                    operatingUnitIdSet.add(acc.HAE_Operating_Unit__c);
                    operatingUnitIdMap.put(acc.HAE_Operating_Unit__c, acc.Id);
                }
            }
        }

        if(operatingUnitIdSet <> NULL && !operatingUnitIdSet.isEmpty()){     
            userOperatingUnitList = [SELECT Id,
                                            HAE_User__c,
                                            HAE_Operating_Unit__c
                                            FROM HAE_User_Operating_Unit__c
                                            WHERE HAE_Operating_Unit__c in :operatingUnitIdSet
                                            AND HAE_User__c <> null
                                            AND HAE_Operating_Unit__c <> null];
        }
        

        if(userOperatingUnitList <> NULL && !userOperatingUnitList.isEmpty()){        
            for(HAE_User_Operating_Unit__c userOpp : userOperatingUnitList){
                if(operatingUnitIdMap.get(userOpp.HAE_Operating_Unit__c) <> null){
                    accountTeamMemberList.add(new AccountTeamMember(
                    AccountId = operatingUnitIdMap.get(userOpp.HAE_Operating_Unit__c), 
                    TeamMemberRole = HAE_ApexUtil.TEAM_MEMBER_ROLE, UserId= userOpp.HAE_User__c,                    
                        AccountAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                        ContactAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                        OpportunityAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                        CaseAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT));
                }
            }
        }

        try{
            if(accountTeamMemberList <> NULL && !accountTeamMemberList.isEmpty()){ 
                insert accountTeamMemberList;
            }
        }catch(DMLEXception ex){
            System.debug('DML Exception --->'+ex.getMessage());
        }
        catch(EXception ex){
            System.debug('System Exception --->'+ex.getMessage());
        }
    } 
       

    public static void maintainAccountSharing(List<Account> oldAccountList, List<Account> newAccountList){
    
        Set<Id> olduserIdSet = new Set<Id>();
        Map<Id, Id> oldoperatingUnitIdMap = new Map<Id, Id>();
        Set<Id> oldoperatingUnitIdSet = new Set<Id>();
        List<AccountTeamMember> oldAccountTeamMemberList = new list<AccountTeamMember>();

        Map<Id, Id> newoperatingUnitIdMap = new Map<Id, Id>();
        Set<Id> newoperatingUnitIdSet = new Set<Id>();
        List<AccountTeamMember> newAccountTeamMemberList = new list<AccountTeamMember>();
        
        if(oldAccountList <> NULL && !oldAccountList.isEmpty()){ 
            for(Account acc : oldAccountList){
                if(acc.HAE_Operating_Unit__c <> null){
                    oldoperatingUnitIdSet.add(acc.HAE_Operating_Unit__c);
                }     
            }
        }

        if(oldoperatingUnitIdSet <> NULL && !oldoperatingUnitIdSet.isEmpty()){ 
            for(HAE_User_Operating_Unit__c olduserOperatingUnit : [SELECT Id,
                                            HAE_User__c,
                                            HAE_Operating_Unit__c
                                            FROM HAE_User_Operating_Unit__c
                                            WHERE HAE_Operating_Unit__c in :oldoperatingUnitIdSet
                                            AND HAE_User__c <> null
                                            AND HAE_Operating_Unit__c <> null]){
                olduserIdSet.add(olduserOperatingUnit.HAE_User__c);   
            }
        }

        if(olduserIdSet <> NULL && !olduserIdSet.isEmpty() && oldaccountList <> NULL && !oldaccountList.isEmpty()){ 
            oldAccountTeamMemberList = [SELECT  Id,
                                                AccountId,
                                                UserId FROM AccountTeamMember 
                                                WHERE AccountId IN : oldaccountList
                                                AND UserId IN : olduserIdSet
                                                AND TeamMemberRole =: HAE_ApexUtil.TEAM_MEMBER_ROLE];
        }
		 
        try{
            if(oldAccountTeamMemberList <> NULL && !oldAccountTeamMemberList.isEmpty()){ 
                delete oldAccountTeamMemberList;
            }
        }catch(DMLEXception ex){
            System.debug('DML Exception --->'+ex.getMessage());
        }
        catch(EXception ex){
            System.debug('System Exception --->'+ex.getMessage());
        } 
       
        maintainAccountSharing(newAccountList);
    }
}