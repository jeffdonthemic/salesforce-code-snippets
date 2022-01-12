/******************************************************************
 Name : ChallengePlatformTriggerHandler
 Created By : Jeff Douglas (jeff@appirio.com)
 Created Date : June 27, 2013
 Description : Updates the challenge with a csv list of
 related platform records.
********************************************************************/
public with sharing class ChallengePlatformTriggerHandler {
  
  @future
  public static void RollupNamesToList(Set<ID> challengeIds) {
    
    // the collection of challenges to eventually update
    List<Challenge__c> challengesToUpdate = new List<Challenge__c>();
    
    // create a map of the affected challenges so we can access them by id
    Map<ID, Challenge__c> challenges = new Map<ID, Challenge__c>([select id, 
      (select name__c from challenge_platforms__r order by name__c) 
      from challenge__c where Id IN :challengeIds]);

    // iterate through the map by id
    for (Id challengeId : challenges.keySet()) {
      
      // process the current challenge record from the map
      Challenge__c challenge = challenges.get(challengeId);
      // returns an object array (of strings) with values from 'name__c' field
      // this will return an object array like: ['Heroku','Salesforce.com']
      List<Object> pluckedNames = 
        ArrayUtils.pluck(challenge.challenge_platforms__r, 'name__c');
      
      if (!pluckedNames.isEmpty()) {
        // update the challenge with the new list of items
        challengesToUpdate.add(new Challenge__c(id=challengeId, 
         platforms__c=Utils.ListToCSVString(pluckedNames)));
      } else {
        // if we deleted all item, then set the field as null
        challengesToUpdate.add(new Challenge__c(id=challengeId, 
         platforms__c=null));
      }
      
    }
    update challengesToUpdate;  
  }
}