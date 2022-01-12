trigger AccountRegionTrigger on Account_Region__c (after delete, after insert, after update) {
      
  // fires after both insert and update
  if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
    
    // find the ids of all accounts that were affected
    Set<Id> accountIds = new Set<Id>();
    for (Account_Region__c ar : [select Id, Account__c from Account_Region__c 
      where Id IN :Trigger.newMap.keySet()])
      accountIds.add(ar.Account__c);
        
    // process the accounts  
    AccountRegionTriggerHandler.ProcessRegionsAsync(accountIds);
    

  // fires when records are deleted. may want to do undelete also?
  } else if(Trigger.isDelete && Trigger.isAfter){
    
    // find the ids of all accounts that were affected
    Set<Id> accountIds = new Set<Id>();
    for (ID id : Trigger.oldMap.keySet())
      accountIds.add(Trigger.oldMap.get(id).Account__c);
    
    // process the accounts
    AccountRegionTriggerHandler.ProcessRegionsAsync(accountIds);

  }

}