@isTest
private class UnitTests {
   
    // tests AccountDisplayController
    public static testmethod void testController() {
 	  
 	   /* fetch an account to */
 	   Account acct = [Select a.Id, a.Name From Account a Limit 1];
 	  
 	   /* setup a reference to the page the controller is expecting with the parameters */
 	   PageReference pref = Page.Account_Display;
        pref.getParameters().put('id',acct.id);
        Test.setCurrentPage(pref);

        /* Construct the standard controller for an account. */
        ApexPages.StandardController con = new ApexPages.StandardController(acct);

        /* Switch to runtime context */
        Test.startTest();

        /* Construct the controller class */
        AccountDisplayController ext = new AccountDisplayController(con);

        /* Call the methods on the ext controller */
        //PageReference result = ext.save();
        Account_Service_Group__c[] groups = ext.getGroups();
        Account_Service_Category__c[] categories = ext.getCategories();
        Account_Service_Subcategory__c[] tasks = ext.getTasks();

        /* Switch back to test context */
        Test.stopTest();

    }   
   
    // tests SendTaskResonseEmail trigger
    private static testMethod void testSendTaskResponseEmail() {
 	  
        // create a new contact
        Contact c = new Contact();
        c.LastName = 'Test Contact';
        c.Username__c = 'MyTestUsername12345';
        c.Email = 'test@jeffdouglas.com';
        insert c;
       
        // create the new location for the contact with the target zip code
        Contact_Location__c location = new Contact_Location__c();
        location.Zip__c = '34231';
        location.Contact__c = c.Id;
        insert location;
       
        // create a new list
        HoneyDo_List__c taskList = new HoneyDo_List__c();
        taskList.Name = 'Test List';
        taskList.Contact__c = c.Id;
        insert taskList;
       
        // create the group
        Service_Group__c hGroup = new Service_Group__c();
        hGroup.Name = 'Test Group';
        hGroup.Grp_ID__c = '111';
        insert hGroup;
       
        //create the category
        Service_Category__c hCat = new Service_Category__c();
        hCat.Name = 'Test Category';
        hCat.Cat_ID__c = '222';
        hCat.Service_Group__c = hGroup.Id;
        insert hCat;
       
        // inert the subcategory
        // Select s.Service_Category__c, s.Name From Service_Subcategory__c s
        Service_Subcategory__c hTask = new Service_Subcategory__c();
        hTask.Name = 'Test Task';
        hTask.Task_ID__c = '333';
        hTask.Service_Category__c = hCat.Id;
        insert hTask;
       
        /** create the account and set it up for matching **/
        /** START ACCOUNT #1 **/
        // create  a new account that will match this task request
        Account a1 = new Account();
        a1.Name = 'Test Account 1';
        a1.Company_Email__c = 'jeff@jeffdouglas.com';
        a1.Zip_Codes_Serviced__c = '34233,34231,34236';
        insert a1;
       
        Account_Service_Subcategory__c ascat1 = new Account_Service_Subcategory__c();
        ascat1.Service_Subcategory__c = hTask.Id;
        ascat1.Account__c = a1.Id;
        insert ascat1;     
       
        // create the task
        HoneyDo_Task__c task = new HoneyDo_Task__c();
        task.Task_Type__c = 'Do It For Me';
        task.Name = 'My Test Task';
        task.Description__c = 'This is my task description';
        task.Service_Subcategory__c = hTask.Id;
        task.HoneyDo_List__c = taskList.Id;
        task.Contact_Location__c = location.Id;
        task.Preferred_Start_Date__c = Date.newInstance(2010, 01, 01);
        task.Preferred_Finish_Date__c = Date.newInstance(2010, 01, 01);
       
 	   System.debug('>>>>>>>>>> TEST -- testNewTaskRequestWithMatch-- TEST');
       
        Insert task;
       
        List<HoneyDo_Task_Response__c> responses = [select id, name, Status__c from HoneyDo_Task_Response__c where Account__c = :a1.id limit 1];
       
        // make sure we found at leaast 1 response
        System.assertEquals(responses.size(),1);
       
        HoneyDo_Task_Response__c response = responses[0];
        // make some changes to the taskresponse
        response.Status__c = 'Responded';

        Update response;
       
     		  
 	  
    }
   
    // tests ProcessNewAccount trigger
    public static testMethod void testAccountUpdate() {
 	  
 	   List<Account> accs = new List<Account>();
 	  
 	   for (Integer i=0; i<200; i++) {
       
 	       Account a = new Account();
 	      
 	       a.Name = 'Jeff Test ' + i;
 	       a.Reviews__c = 0;
 	       a.Rating__c = 0;
 	    
 	       //Test.startTest();
 	      
 	       accs.add(a);
 	
 		   System.assertEquals(a.Name,'Jeff Test ' + i);
 		  
 		   //Test.stopTest();
 		  
 	   }
 	  
 	   insert accs;
    
    }	  
   
    // tests CalculateAverageRating trigger
    public static testMethod void testCalculateAvgRatings() {
       
        Rating_Review__c r = new Rating_Review__c();
       
        r.Review__c = '';
        r.Account__c = [Select Id from Account Limit 1].Id;
        r.Contact__c = [Select Id from Contact Limit 1].Id;
        r.Overall_Experience__c = 1;
        r.Price__c = 1;
        r.Professionalism__c = 1;
        r.Quality__c = 1;
        r.Work_With_Again__c = true;
        r.Work_With_Again_Why__c = 'cool';
        r.Responsiveness__c = 1;
       
        System.debug('----------------------> Inserting new rating');
        insert r;
        System.debug('----------------------> deleting new rating');
        delete r;
       
    }   
   
    // tests DifmTaskMatching trigger with a matching request
    public static testMethod void testNewTaskRequestWithMatch() {
       
        // create a new contact
        Contact c = new Contact();
        c.LastName = 'Test Contact';
        insert c;
       
        // create the new location for the contact with the target zip code
        Contact_Location__c location = new Contact_Location__c();
        location.Zip__c = '34231';
        location.Contact__c = c.Id;
        insert location;
       
        // create a new list
        HoneyDo_List__c taskList = new HoneyDo_List__c();
        taskList.Name = 'Test List';
        taskList.Contact__c = c.Id;
        insert taskList;
       
        // create the group
        Service_Group__c hGroup = new Service_Group__c();
        hGroup.Name = 'Test Group';
        hGroup.Grp_ID__c = '111';
        insert hGroup;
       
        //create the category
        Service_Category__c hCat = new Service_Category__c();
        hCat.Name = 'Test Category';
        hCat.Cat_ID__c = '222';
        hCat.Service_Group__c = hGroup.Id;
        insert hCat;
       
        // inert the subcategory
        // Select s.Service_Category__c, s.Name From Service_Subcategory__c s
        Service_Subcategory__c hTask = new Service_Subcategory__c();
        hTask.Name = 'Test Task';
        hTask.Task_ID__c = '333';
        hTask.Service_Category__c = hCat.Id;
        insert hTask;
       
        /** create the account and set it up for matching **/
        /** START ACCOUNT #1 **/
        // create  a new account that will match this task request
        Account a1 = new Account();
        a1.Name = 'Test Account 1';
        a1.Company_Email__c = 'jeff@jeffdouglas.com';
        a1.Zip_Codes_Serviced__c = '34233,34231,34236';
        insert a1;
       
        Account_Service_Subcategory__c ascat1 = new Account_Service_Subcategory__c();
        ascat1.Service_Subcategory__c = hTask.Id;
        ascat1.Account__c = a1.Id;
        insert ascat1;     
       
        /** END ACCOUNT #1 **/     
       
        /** START ACCOUNT #2 **/
       
         /** create the account and set it up for matching **/
        // create  a new account that will match this task request
        Account a2 = new Account();
        a2.Name = 'Test Account 2';
        a2.Company_Email__c = 'jeff@bluemethod.com';
        a2.Zip_Codes_Serviced__c = '34231';
        insert a2;
       
        Account_Service_Subcategory__c ascat2 = new Account_Service_Subcategory__c();
        ascat2.Service_Subcategory__c = hTask.Id;
        ascat2.Account__c = a2.Id;
        insert ascat2;  
       
        /** END ACCOUNT #2 **/   
       
        // create the task
        HoneyDo_Task__c task = new HoneyDo_Task__c();
        task.Task_Type__c = 'Do It For Me';
        task.Service_Subcategory__c = hTask.Id;
        task.HoneyDo_List__c = taskList.Id;
        task.Contact_Location__c = location.Id;
        task.Preferred_Start_Date__c = Date.newInstance(2010, 01, 01);
        task.Preferred_Finish_Date__c = Date.newInstance(2010, 01, 01);
       
 	      System.debug('>>>>>>>>>> TEST -- testNewTaskRequestWithMatch-- TEST');
       
        Insert task;
 	   /**       
        List<Account_Service_Subcategory__c> matches = [Select a.Id, a.Account__c, a.Account__r.Company_Email__c, a.Account__r.Name From Account_Service_Subcategory__c a Where Service_Subcategory__c = :task.Service_Subcategory__c And a.Account__r.Zip_Codes_Serviced__c LIKE '%:task.Zip__c%'];
        Integer responses = [Select count() From HoneyDo_Task_Response__c a Where HoneyDo_Task__c = :task.Id];
       
       
        System.debug('===============> Matching Accounts: '+matches.size());
        System.debug('===============> Responses Created: '+responses);
       
        System.assertEquals(responses,matches.size());
        System.assertEquals(task.Task_Type__c,'Do It For Me');
       
        **/

    
    }  
   
    // tests DifmTaskMatching trigger with NO match
    public static testMethod void testNewTaskRequestWithNoMatch() {
       
        // create a new contact
        Contact c = new Contact();
        c.LastName = 'Test Contact';
        insert c;
       
        // create the new location for the contact with the target zip code
        Contact_Location__c location = new Contact_Location__c();
        location.Zip__c = '34231';
        location.Contact__c = c.Id;
        insert location;
       
        // create a new list
        HoneyDo_List__c taskList = new HoneyDo_List__c();
        taskList.Name = 'Test List';
        taskList.Contact__c = c.Id;
        insert taskList;
       
        // create the group
        Service_Group__c hGroup = new Service_Group__c();
        hGroup.Name = 'Test Group';
        hGroup.Grp_ID__c = '111';
        insert hGroup;
       
        //create the category
        Service_Category__c hCat = new Service_Category__c();
        hCat.Name = 'Test Category';
        hCat.Cat_ID__c = '222';
        hCat.Service_Group__c = hGroup.Id;
        insert hCat;
       
        // inert the subcategory
        // Select s.Service_Category__c, s.Name From Service_Subcategory__c s
        Service_Subcategory__c hTask = new Service_Subcategory__c();
        hTask.Name = 'Test Task';
        hTask.Task_ID__c = '333';
        hTask.Service_Category__c = hCat.Id;
        insert hTask;
       
        /** create the account and set it up for matching **/
        // create  a new account that will match this task request
        Account a = new Account();
        a.Name = 'Test Account';
        // CREATE ZIP CODES THAT DO NOT MATCH
        a.Zip_Codes_Serviced__c = '00000';
        insert a;
       
        Account_Service_Subcategory__c ascat = new Account_Service_Subcategory__c();
        ascat.Service_Subcategory__c = hTask.Id;
        ascat.Account__c = a.Id;
        insert ascat;
       
        // create the task
        HoneyDo_Task__c task = new HoneyDo_Task__c();
        task.Task_Type__c = 'Do It For Me';
        task.Service_Subcategory__c = hTask.Id;
        task.HoneyDo_List__c = taskList.Id;
        task.Contact_Location__c = location.Id;
        task.Preferred_Start_Date__c = Date.newInstance(2010, 01, 01);
        task.Preferred_Finish_Date__c = Date.newInstance(2010, 01, 01);
       
 	      System.debug('>>>>>>>>>> TEST -- testNewTaskRequestWithNoMatch-- TEST');
       
        Insert task;
    
    }          

}
