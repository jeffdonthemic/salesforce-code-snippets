@isTest
private class Test_AccountRegionTriggerHandler {
  
  static List<Region__c> regions = new List<Region__c>();
  
  static {
  
    // insert some regions
    Region__c r1 = new Region__c(name='Region 1');
    Region__c r2 = new Region__c(name='Region 2');
    Region__c r3 = new Region__c(name='Region 3');
    Region__c r4 = new Region__c(name='Region 4');
    regions.add(r1);
    regions.add(r2);
    regions.add(r3);
    regions.add(r4);
    insert regions;
    
  }
  
  private static void testInsertRecords() {
    
    List<Account> accounts = new List<Account>();
    List<Account_Region__c> accountRegions = new List<Account_Region__c>();
    
    // insert some accounts
    Account a1 = new Account(name='Account 1');
    Account a2 = new Account(name='Account 2');
    accounts.add(a1);
    accounts.add(a2);
    insert accounts;
    
    Test.startTest();
    
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(0).Id));
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(1).Id));
      accountRegions.add(new Account_Region__c(Account__c=a2.Id, Region__c=regions.get(2).Id));
      accountRegions.add(new Account_Region__c(Account__c=a2.Id, Region__c=regions.get(3).Id));
      
      insert accountRegions;
    
    Test.stopTest();
    
    // since async, check for the accounts AFTER tests stop
    List<Account> updatedAccounts = [select id, name, regions__c from account where id IN :accounts];
    System.assertEquals('Region 1, Region 3',updatedAccounts.get(0).Regions__c);
    System.assertEquals('Region 2, Region 4',updatedAccounts.get(1).Regions__c);
    
  }
  
  private static void testDeleteRecords() {
    
    List<Account> accounts = new List<Account>();
    List<Account_Region__c> accountRegions = new List<Account_Region__c>();
    
    // insert an account
    Account a1 = new Account(name='Account 1');
    accounts.add(a1);
    insert accounts;
    
    Test.startTest();
    
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(0).Id)); 
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(1).Id));
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(2).Id));
      accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(3).Id));
      
      insert accountRegions;
    
      // now delete a record
      delete accountRegions.get(3);
    
    Test.stopTest();
    
    List<Account> updatedAccounts = [select id, name, regions__c from account where id IN :accounts];
    System.assertEquals('Region 1, Region 2, Region 3',updatedAccounts.get(0).Regions__c);
    
  }
  
}