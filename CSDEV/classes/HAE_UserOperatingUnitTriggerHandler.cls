/**
    @name: HAE_UserOperatingUnitTriggerHandler
    @description: This class is responsible to create Operating Unit Share records as well as account team member records
    @date: 11/12
**/

public with sharing class HAE_UserOperatingUnitTriggerHandler {


    public static void maintainOperatingUnitSharing(List<HAE_User_Operating_Unit__c> userOperatingUnitList, String operationType){

        List<HAE_Operating_Unit__share> operatingUnitSharingList = new List<HAE_Operating_Unit__share>();

        
        if(userOperatingUnitList <> NULL && !userOperatingUnitList.isEmpty()){ 
            for(HAE_User_Operating_Unit__c uop : userOperatingUnitList){
                operatingUnitSharingList.add(new HAE_Operating_Unit__share(
                    AccessLevel = HAE_ApexUtil.ACCESS_LEVEL_READ,
                    ParentID = uop.HAE_Operating_Unit__c,
                    UserOrGroupID = uop.HAE_User__c,
                    RowCause = HAE_ApexUtil.ROW_CAUSE
                ));
            }
        }


        try{
            if(operatingUnitSharingList <> NULL && !operatingUnitSharingList.isEmpty()){ 
                insert operatingUnitSharingList;
                if(operationType == HAE_ApexUtil.OPERATION_INSERT)
                    controlAccountSharing(userOperatingUnitList, null, operationType);
            }
        }catch(DMLEXception ex){
            System.debug('DML Exception --->'+ex.getMessage());
        }
        catch(EXception ex){
            System.debug('System Exception --->'+ex.getMessage());
        }

    }

    private static void controlAccountSharing(List<HAE_User_Operating_Unit__c> userOperatingUnitList,List<HAE_User_Operating_Unit__c> olduserOperatingUnitList, String operationType){

        List<Account> accountList = new List<Account>();
        Set<Id> operatingUnitIdSet = new Set<Id>();
        Map<Id,List<AccountTeamMember>> accteamOperatingUnitMap = new Map<Id,List<AccountTeamMember>>();
        Map<Id, Id> accOperatingUnitMap = new Map<Id, Id>();
        List<AccountTeamMember> newaccountTeamMemberList = new List<AccountTeamMember>();
        List<AccountTeamMember> deletedAccountTeamMemberList = new List<AccountTeamMember>();

        if(userOperatingUnitList <> NULL && !userOperatingUnitList.isEmpty()){ 
            for(HAE_User_Operating_Unit__c uop : userOperatingUnitList){
                operatingUnitIdSet.add(uop.HAE_Operating_Unit__c);
            }
         }


        if(operatingUnitIdSet <> NULL && !operatingUnitIdSet.isEmpty()){ 
            accountList = [SELECT Id,HAE_Operating_Unit__c, (SELECT Id, AccountId, UserId FROM AccountTeamMembers WHERE TeamMemberRole =: HAE_ApexUtil.TEAM_MEMBER_ROLE) FROM Account WHERE HAE_Operating_Unit__c IN : operatingUnitIdSet];
        }

        if(accountList <> NULL && !accountList.isEmpty()){
            for(Account acc : accountList){
                accteamOperatingUnitMap.put(acc.HAE_Operating_Unit__c, acc.AccountTeamMembers);
                accOperatingUnitMap.put(acc.HAE_Operating_Unit__c, acc.Id);
               
            }
        }

        if(userOperatingUnitList <> NULL && !userOperatingUnitList.isEmpty() &&
            accteamOperatingUnitMap <> NULL && !accteamOperatingUnitMap.isEmpty() &&
            accOperatingUnitMap <> NULL && !accOperatingUnitMap.isEmpty()){ 

            for(HAE_User_Operating_Unit__c uop : userOperatingUnitList){ 
                for(Account acc : accountList){
                    if(acc.HAE_Operating_Unit__c == uop.HAE_Operating_Unit__c){
                        if(acc.AccountTeamMembers.size() == 0){
                            if(operationType <> HAE_ApexUtil.OPERATION_DELETE){
                            newaccountTeamMemberList.add(new AccountTeamMember(
                                AccountId = acc.Id, 
                                TeamMemberRole = HAE_ApexUtil.TEAM_MEMBER_ROLE, 
                                UserId= uop.HAE_User__c,                    
                                AccountAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                ContactAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                OpportunityAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                CaseAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT));  
                            } 
                           
                        }else{                           
                               for(AccountTeamMember accTeam : acc.AccountTeamMembers){
                                   if(operationType <> HAE_ApexUtil.OPERATION_DELETE){
                                        newaccountTeamMemberList.add(new AccountTeamMember(
                                            AccountId = acc.Id, 
                                            TeamMemberRole = HAE_ApexUtil.TEAM_MEMBER_ROLE, 
                                            UserId= uop.HAE_User__c,                    
                                            AccountAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                            ContactAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                            OpportunityAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT, 
                                            CaseAccessLevel = HAE_ApexUtil.ACCESS_LEVEL_EDIT));
                                    }
                                            
                                    if(operationType == HAE_ApexUtil.OPERATION_UPDATE){
                                        if(olduserOperatingUnitList <> NULL && !olduserOperatingUnitList.isEmpty()){
                                            for(HAE_User_Operating_Unit__c uopr : olduserOperatingUnitList){  
                                                if(uopr.HAE_User__c == accTeam.UserId){
                                                    deletedAccountTeamMemberList.add(accTeam); 
                                                }
                                            }
                                        }
                                    }
                                            
                                    if(operationType == HAE_ApexUtil.OPERATION_DELETE){
                                        if(uop.HAE_User__c == accTeam.UserId){
                                            deletedAccountTeamMemberList.add(accTeam); 
                                        }
                                    }
                                    
                               }
                        }
                    }
                }
            }
        }

        try{
                if(newaccountTeamMemberList <> NULL && !newaccountTeamMemberList.isEmpty()){ 
                    insert newaccountTeamMemberList;
                }
                if(deletedAccountTeamMemberList <> NULL && !deletedAccountTeamMemberList.isEmpty()){ 
                    delete deletedAccountTeamMemberList;
                }
            }catch(DMLEXception ex){
                System.debug('DML Exception --->'+ex.getMessage());
            }
            catch(EXception ex){
                System.debug('System Exception --->'+ex.getMessage());
            }
    }
    
    public static void maintainOperatingUnitSharing(Map<Id,HAE_User_Operating_Unit__c> newUserOperatingUnitMap,Map<Id,HAE_User_Operating_Unit__c> oldUserOperatingUnitMap, String operationType){
        
        Set<Id> changedUserOperatingUnitIdSet = new Set<Id>();
        List<HAE_User_Operating_Unit__c> newUserOperatingUnitList = new List<HAE_User_Operating_Unit__c>();
        List<HAE_User_Operating_Unit__c> oldUserOperatingUnitList = new List<HAE_User_Operating_Unit__c>();
        List<HAE_Operating_Unit__share> operatingUnitSharingList = new List<HAE_Operating_Unit__share>();
        Map<Id,Id> mapOfOperatingUnitUserId = new Map<Id,Id>();
        
        if(newUserOperatingUnitMap <> NULL && !newUserOperatingUnitMap.isEmpty()){
            for(Id operatingUnitId : newUserOperatingUnitMap.keySet()){
                if(newUserOperatingUnitMap.get(operatingUnitId).HAE_User__c != oldUserOperatingUnitMap.get(operatingUnitId).HAE_User__c){
                    changedUserOperatingUnitIdSet.add(newUserOperatingUnitMap.get(operatingUnitId).HAE_Operating_Unit__c);
                    newUserOperatingUnitList.add(newUserOperatingUnitMap.get(operatingUnitId));
                    oldUserOperatingUnitList.add(oldUserOperatingUnitMap.get(operatingUnitId));
                    mapOfOperatingUnitUserId.put(newUserOperatingUnitMap.get(operatingUnitId).HAE_Operating_Unit__c, newUserOperatingUnitMap.get(operatingUnitId).HAE_User__c);
                }
            }
        }
        
        if(changedUserOperatingUnitIdSet <> NULL && !changedUserOperatingUnitIdSet.isEmpty()){
            operatingUnitSharingList = [SELECT Id FROM HAE_Operating_Unit__share WHERE RowCause =: HAE_ApexUtil.ROW_CAUSE AND ParentId IN : changedUserOperatingUnitIdSet];
            controlAccountSharing(newUserOperatingUnitList, oldUserOperatingUnitList, operationType);
            
            try{
                if(operatingUnitSharingList <> NULL && !operatingUnitSharingList.isEmpty()){ 
                    delete operatingUnitSharingList;                    
                }
            }catch(DMLEXception ex){
                System.debug('DML Exception --->'+ex.getMessage());
            }
            catch(EXception ex){
                System.debug('System Exception --->'+ex.getMessage());
            }
            
            maintainOperatingUnitSharing(newUserOperatingUnitMap.values(), operationType);
        }      
    }


    public static void deleteOperatingUnitSharing(List<HAE_User_Operating_Unit__c> userOperatingUnitList, String operationType){

        
        Set<Id>operatingUnitIdSet = new Set<Id>();
        Set<Id>userIdSet = new Set<Id>();
        List<HAE_Operating_Unit__share> operatingUnitSharingList = new List<HAE_Operating_Unit__share>();

        if(userOperatingUnitList <> NULL && !userOperatingUnitList.isEmpty()){ 
            for(HAE_User_Operating_Unit__c uop : userOperatingUnitList){
                operatingUnitIdSet.add(uop.HAE_Operating_Unit__c);
                userIdSet.add(uop.HAE_User__c);
            }
        }

        if(operatingUnitIdSet <> NULL && !operatingUnitIdSet.isEmpty() && userIdSet <> NULL && !userIdSet.isEmpty()){ 
            
            operatingUnitSharingList = [SELECT Id
                                               FROM HAE_Operating_Unit__share
                                               WHERE ParentID IN : operatingUnitIdSet
                                               AND UserOrGroupID IN : userIdSet
                                               AND RowCause =: HAE_ApexUtil.ROW_CAUSE];

        }

        try{
            if(operatingUnitSharingList <> NULL && !operatingUnitSharingList.isEmpty()){ 
                delete operatingUnitSharingList;
            }
        }catch(DMLEXception ex){
            System.debug('DML Exception --->'+ex.getMessage());
        }
        catch(EXception ex){
            System.debug('System Exception --->'+ex.getMessage());
        }

        controlAccountSharing(userOperatingUnitList, null, operationType);
    }
}