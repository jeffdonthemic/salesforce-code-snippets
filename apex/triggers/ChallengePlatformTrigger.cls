/******************************************************************
 Name : ChallengePlatformTrigger
 Created By : Jeff Douglas (jeff@appirio.com)
 Created Date : June 27, 2013
 Description : Trigger to operate for Challenge Platforms. Delegates
 functionality to ChallengePlatformTriggerHandler.
********************************************************************/
trigger ChallengePlatformTrigger on Challenge_Platform__c (after delete, 
  after insert) {
        
  if (Trigger.isInsert && Trigger.isAfter) {
    
    Set<ID> challengeIds = new Set<ID>();
    for (Challenge_Platform__c cp : [select challenge__c from Challenge_Platform__c 
      where id IN :Trigger.newMap.keySet()]) { challengeIds.add(cp.challenge__c); }   
    ChallengePlatformTriggerHandler.RollupNamesToList(challengeIds);
    
  } else if(Trigger.isDelete && Trigger.isAfter) {
    
    Set<ID> challengeIds = new Set<ID>();
    for (Id challengePlatformId : Trigger.oldMap.keySet())
      challengeIds.add(Trigger.oldMap.get(challengePlatformId).Challenge__c);
    ChallengePlatformTriggerHandler.RollupNamesToList(challengeIds);
    
  }
}