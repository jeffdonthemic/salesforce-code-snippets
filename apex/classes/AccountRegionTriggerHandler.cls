public with sharing class AccountRegionTriggerHandler {
  
  @future 
  public static void ProcessRegionsAsync(Set<ID> accountIds){
    
    // holds a map of the account id and comma separated regions to build
    Map<Id, String> accountRegionMap = new Map<Id, String>();
      
    // get ALL of the regions for all affected accounts so we can build
    List<Account_Region__c> accountRegions = [select id, Account__c, 
      Region__r.Name from Account_Region__c 
      where Account__c IN :accountIds order by Region__r.Name];
      
    for (Account_Region__c ar : accountRegions) {
      if (!accountRegionMap.containsKey(ar.Account__c)) {
        // if the key (account) doesn't exist, add it with region name
        accountRegionMap.put(ar.Account__c,ar.Region__r.Name);
      } else {
        // if the key (account) already exist, add ", region-name"
        accountRegionMap.put(ar.Account__c,accountRegionMap.get(ar.Account__c) + 
          ', ' + ar.Region__r.Name);
      }
    }
    
    // get the account that were affected
    List<Account> accounts = [select id from Account where Id IN :accountIds];
    
    // add the comma separated list of regions
    for (Account a : accounts)
      a.Regions__c = accountRegionMap.get(a.id);
    
    // update the accounts
    update accounts;
    
  }  
  
}