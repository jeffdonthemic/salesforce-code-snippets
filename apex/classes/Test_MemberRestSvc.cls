@isTest
private class Test_MemberRestSvc {
  
  static {
    // setup test data  
  }
  
  static testMethod void testDoGet() {
        
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    // pass the req and resp objects to the method     
    req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
    req.httpMethod = 'GET';

    MemberRestSvc.ReturnClass results = MemberRestSvc.doGet(req,res);
    
    System.assertEquals('true', results.success);
    System.assertEquals(10, results.records.size());
    System.assertEquals('Query executed successfully.', results.message);
 
  }
  
}