public class TestRunAs2 {

   public static testMethod void test2() { 

         Profile p = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'newUser', email='newuser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='newuser@testorg.com');

         System.runAs(u2) {
         // The following code runs as user u2. 
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId()); 

            // The following code runs as user u3. 

            User u3 = [select id from user where username='newuser@testorg.com'];
               System.runAs(u3) {
               System.debug('Current User: ' + UserInfo.getUserName());
               System.debug('Current Profile: ' + UserInfo.getProfileId()); 
           }

         // Any additional code here would run as user u2.

        }
   }
}
