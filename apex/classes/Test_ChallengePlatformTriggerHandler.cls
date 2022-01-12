public with sharing class Test_ChallengePlatformTriggerHandler {
  
  static {
    // load our static platform data
    Test.loadData(Platform__c.sObjectType, 'platforms'); 
  } 

  static testMethod void testAddPlatforms() {
    
    // helper method to create a new challenge
    Challenge__c c = TestUtils.createChallenge();
    List<Platform__c> allPlatforms = [select id, name from platform__c];
    List<Challenge_Platform__c> platformsToInsert = new List<Challenge_Platform__c>();
    
    Challenge_Platform__c cp1 = new Challenge_Platform__c();
    cp1.Challenge__c = c.id;
    cp1.Platform__c = allPlatforms.get(1).id;
    platformsToInsert.add(cp1);
    
    Challenge_Platform__c cp2 = new Challenge_Platform__c();
    cp2.Challenge__c = c.id;
    cp2.Platform__c = allPlatforms.get(2).id;
    platformsToInsert.add(cp2);
    
    Test.startTest();
    insert platformsToInsert; 
    Test.stopTest();
    
    System.assertEquals(allPlatforms.get(1).name + ', ' + allPlatforms.get(2).name, 
     [select Platforms__c from challenge__c where id = :c.id].Platforms__c);
    
  }
  
  static testMethod void testDeletePlatforms() {
    
    Challenge__c c = TestSetup_Challenge.createChallenge();
    List<Platform__c> allPlatforms = [select id from platform__c];
    List<Challenge_Platform__c> platformsToInsert = new List<Challenge_Platform__c>();
    
    Challenge_Platform__c cp1 = new Challenge_Platform__c();
    cp1.Challenge__c = c.id;
    cp1.Platform__c = allPlatforms.get(1).id;
    platformsToInsert.add(cp1);
    
    Test.startTest();
    insert platformsToInsert;
    delete [select id from challenge_platform__c where challenge__c = :c.id and 
      platform__c = :allPlatforms.get(1).id];
    Test.stopTest();
    
    System.assertEquals(null, [select Platforms__c from challenge__c where id = :c.id].Platforms__c);
    
  }  
}