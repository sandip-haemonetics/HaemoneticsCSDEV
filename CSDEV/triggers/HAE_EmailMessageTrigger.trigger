/** Created By : Cognizant
  * Date : 21 Nov, 2019
  * Description : 
  *        This trigger is responsible to handled email message back end logic. All the EmailMessage trigger logic for 
  *        Customer Service will be handled by HAE_EmailMessageTriggerHandler apex class.         
**/
trigger HAE_EmailMessageTrigger on EmailMessage (after insert, before insert, before update, after update, before delete) {
    HAE_EmailMessageTriggerHandler.executeTrigger(); 
}