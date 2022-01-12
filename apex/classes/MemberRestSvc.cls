@RestResource(urlMapping='/v.9/member/*/results/*') 
global with sharing class MemberRestSvc {
 
  @HttpGet 
  global static ReturnClass doGet() {
  
    String[] uriKeys = RestContext.request.requestURI.split('/');
    // get the member name from the uri
    String memberName = uriKeys.get(uriKeys.size()-3);

    // do awesome programming stuff here & catch any exceptions
    try {
  
      List<Contact> contacts = [Select Id From Contact where member_name__c = :memberName];
      return new ReturnClass('true', 'Query executed successfully.', contacts);
    
    } catch (Exception e) {
      return new ReturnClass('false', e.getMessage(), null);
    }

  }

  global class ReturnClass {
    
    global String success;
    global String message;
    global List<Contact> records;
    
    global ReturnClass(String success, String message, List<Contact> records) {
      this.success = success;
      this.message = message;
      this.records = records;
    }
    
  }
    
}