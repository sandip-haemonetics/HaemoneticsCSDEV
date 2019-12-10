/*
    @name: HAE_CaseQueueMemberSelectionController
    @description: to get the group members based on logged in user
    @ref: [REF: W-000040]
    @date: 25thNov, 19
*/
public with sharing class HAE_CaseQueueMemberSelectionController {
    
    /*
        @name: getGroupMembers
        @param(s): Id recordId, Id loggedinUserId
        @description: to get the group members based on logged in user
        @ref: [REF: W-000040]
        @date: 25thNov, 19
    */
    @AuraEnabled(cacheable=true)
    public Static List <Map<String, String>> getGroupMembers(Id recordId, Id loggedinUserId){

        List<Group> groupList = new List<Group>();
        List<GroupMember> checkGroupMemberList = new List<GroupMember>();
        List<GroupMember> groupMemberList = new List<GroupMember>();
        List<User> userList = new List<User>();
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> totalGroupIdSet = new Set<Id>();
        Set<Id> validGroupIdSet = new Set<Id>();

        List <Map<String, String>> options = new List <Map<String, String>>();     
        
        checkGroupMemberList = [SELECT Id, GroupId FROM GroupMember WHERE UserOrGroupId =: loggedinUserId];

        if(checkGroupMemberList <> NULL &&  !checkGroupMemberList.isEmpty()){
            for(GroupMember grm : checkGroupMemberList){
                totalGroupIdSet.add(grm.GroupId);
            }
        }

        if(totalGroupIdSet <> NULL &&  !totalGroupIdSet.isEmpty()){
            groupList = [SELECT Id FROM Group WHERE Type='Regular' AND Id IN: totalGroupIdSet];
        }

        if(groupList <> NULL &&  !groupList.isEmpty()){
            for(Group gr : groupList){
                validGroupIdSet.add(gr.Id);
            }
        }
       
        if(validGroupIdSet <> NULL &&  !validGroupIdSet.isEmpty())
            groupMemberList = [SELECT Id, UserOrGroupId FROM GroupMember WHERE GroupId IN: validGroupIdSet];
       
       if(groupMemberList<> null && !groupMemberList.isEmpty()){ 
           for(GroupMember grm : groupMemberList){
               if(grm.UserOrGroupId <> loggedinUserId)
                userIdSet.add(grm.UserOrGroupId);
           }

            if(userIdSet <> null && !userIdSet.isEmpty()){
                userList = [SELECT Id, Name FROM User Where Id IN: userIdSet];
            }

            if(userList <> null && !userList.isEmpty()){
                for(User userObj : userList){
                    Map <String,String > userValues = new Map <String,String> {
                        'label' => userObj.Name,
                        'value' => userObj.Id
                    };
                    options.add(userValues);
                }
            }   

            System.debug('userList--->'+userList+'--'+options);
            return options;
       }
       return null;      
    }
}