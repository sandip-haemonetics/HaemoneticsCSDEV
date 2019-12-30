/**
    @name:HAE_ShowAccountTeamMembers 
    @description:This is responsible to select Sales Rep based on Shipped to Account	
    @date:11/7/2019
*/
public with sharing class HAE_ShowAccountTeamMembers {
    
    @AuraEnabled(cacheable = true)
    public static List <Map<String, String>> getSalesReps(Id recordId){

        List <Map<String, String>> options = new List <Map<String, String>>();

        Case caseObj = [SELECT Id, HAE_Ship_To_Account__c FROM Case WHERE Id =: recordId];

        List<AccountTeamMember> accountTeamMemberList = new List<AccountTeamMember>();

        accountTeamMemberList = [SELECT Id, User.Name, TeamMemberRole FROM AccountTeamMember WHERE AccountId =: caseObj.HAE_Ship_To_Account__c AND TeamMemberRole LIKE '% Sales Rep'];

        if(accountTeamMemberList <> null && !accountTeamMemberList.isEmpty()){
                for(AccountTeamMember atm : accountTeamMemberList){
                    Map <String,String > atmValues = new Map <String,String> {
                        'label' => atm.user.name + ' > '+ atm.TeamMemberRole,
                        'value' => atm.UserId
                    };
                    options.add(atmValues);
            }
        }   

        return options;

    }
}