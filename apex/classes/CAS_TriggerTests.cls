@isTest
private class CAS_TriggerTests {

    // tests CAS_UpdateOpportunityStudents trigger
    public static testMethod void testUpdateOpportunityStudentsTrigger() {
 	  
 	   Pricebook2 s = [select id from Pricebook2 where IsStandard = true]; 	  
 			  
 	   Product2 p1 = new Product2(
 		   name='Test Product 1',
 		   ISBN__c='1234',
 		   IsActive=true,
 		   Description='My Product',
 		   RecordTypeId='01260000000DTeK',
 		   ProductCode='12345'
 	   );
 	   insert p1; 	  
 	  
 	   // create the pricebookentry
 	   PricebookEntry pbe1 = new PricebookEntry(
 		   Pricebook2Id=s.id,
 		   Product2Id=p1.id,
 		   UnitPrice=0.00,
 		   IsActive=true,
 		   UseStandardPrice=false
 	   );
 	   insert pbe1;   
 	  
 	   // create the opportunity
 	   Opportunity opp1 = new Opportunity(
 		   name='Test Opp 1',
 		   recordtypeid='01260000000DXrWAAW',
 		   Number_of_Students__c=5,
 		   StageName = 'Identify',
 		   CloseDate = Date.newInstance(2009,01,01)  		  
 	   );
 	   insert opp1;
 	  
 	   // add the line item
 	   OpportunityLineItem oli = new OpportunityLineItem();
 	   oli.Quantity = 9;
 	   oli.TotalPrice = 7;
 	   oli.PricebookEntryId = pbe1.id;
 	   oli.OpportunityId = opp1.id;    
 	   insert oli;   
 	  
 	   // update the opportunity with a different
 	   opp1.Number_of_Students__c = 11;
 	   update opp1;
 	  
    }
   
    // tests CAS_UpdateProductPublisher trigger
    public static testMethod void testUpdateProductPublisherNoCompetitor() {
 		  
 	   // will NOT update Publisher__c
 	   Product2 p1 = new Product2(
 		   name='My Test Product2',
 		   recordtypeid='01260000000DXsEAAW'
 	   );
 	  
 	   List<Product2> products = new List<Product2>();
 	   products.add(p1);
 	  
 	   insert products;
 	  
    }
   
    // tests CAS_UpdateProductPublisher trigger
    public static testMethod void testUpdateProductPublisher() {
 	  
 	   // will update Publisher__c
 	   Product2 p1 = new Product2(
 		   name='My Test Product1',
 		   recordtypeid='01260000000DXsEAAW',
 		   Competitor_Publisher__c='Arnold'
 	   );
 	  
 	   List<Product2> products = new List<Product2>();
 	   products.add(p1);
 	  
 	   insert products;
 	  
    }   
   
    // tests CAS_CreateOppLineItem trigger
    // this test uses an existing opportunity with an opportunity line item and matching ISBN number.
    /**
    public static testMethod void testCreateOppLineItemTrigger() {
 	  
 	   Opportunity opp = [Select id,name from Opportunity where id = '006R0000002e18WIAQ'];
 	   List<OpportunityLineItem> olis = [Select id,PricebookEntryId from OpportunityLineItem where opportunityId = :opp.id];
 	  
 	   List<OpportunityLineItem> lineitems = new List<OpportunityLineItem>();
 	  
 	   // create the line item
 	   OpportunityLineItem oli1 = new OpportunityLineItem();
 	   oli1.Quantity = 13;
 	   oli1.TotalPrice = 10;
 	   oli1.PricebookEntryId = olis[0].PricebookEntryId;
 	   oli1.OpportunityId = opp.id;    
 	   lineitems.add(oli1);
 	  
 	   insert lineitems;
 	  
    }   
    **/

    public static testMethod void testCreateOppLineItemTrigger() {
 	  
 	   Pricebook2 s = [select id from Pricebook2 where IsStandard = true]; 	  
 			  
 	   Product2 p1 = new Product2(
 		   name='Test Product 1',
 		   ISBN__c='1234',
 		   IsActive=true,
 		   Description='My Product',
 		   RecordTypeId='01260000000DTeK',
 		   ProductCode='12345'
 	   );
 	   insert p1;
 	  
 	   // create the pricebookentry
 	   PricebookEntry pbe1 = new PricebookEntry(
 		   Pricebook2Id=s.id,
 		   Product2Id=p1.id,
 		   UnitPrice=0.00,
 		   IsActive=true,
 		   UseStandardPrice=false
 	   );
 	   insert pbe1; 		  
 	  
 	   // create the product with the SAME ISBN
 	   Product2 p2 = new Product2(
 		   name='Test Product 1',
 		   ISBN__c='1234',
 		   IsActive=true,
 		   Description='My Product',
 		   RecordTypeId='01260000000DTeK',
 		   ProductCode='12345'
 	   );
 	   insert p2;
 	  
 	   // create the pricebookentry
 	   PricebookEntry pbe2 = new PricebookEntry(
 		   Pricebook2Id=s.id,
 		   Product2Id=p2.id,
 		   UnitPrice=0.00,
 		   IsActive=true,
 		   UseStandardPrice=false
 	   );
 	   insert pbe2; 		  
 	  
 	   // create a new opportunity for CAS
 	   Opportunity opp = new Opportunity();
 	   opp.RecordTypeId = '01260000000DXs4';
 	   opp.Number_of_Students__c = 11;
 	   opp.Name = 'Test Opportunity';
 	   opp.StageName = 'Identify';
 	   opp.CloseDate = Date.newInstance(2009,01,01);
 	   insert opp;
 	  
 	   List<OpportunityLineItem> lineitems = new List<OpportunityLineItem>();
 	  
 	   //for (Integer i = 0;i < 175; i++) {
 		  
 		   // create the line item
 		   OpportunityLineItem oli1 = new OpportunityLineItem();
 		   oli1.Quantity = 13;
 		   oli1.TotalPrice = 10;
 		   oli1.PricebookEntryId = pbe1.id;
 		   oli1.OpportunityId = opp.id;    
 		   lineitems.add(oli1);   
 	  
 	   //}
 	  
 	   // create the line item
 	   OpportunityLineItem oli2 = new OpportunityLineItem();
 	   oli2.Quantity = 9;
 	   oli2.TotalPrice = 7;
 	   oli2.PricebookEntryId = pbe2.id;
 	   oli2.OpportunityId = opp.id;    
 	   lineitems.add(oli2); 		  
 	  
 	   // create another opportunity for CAS
 	   Opportunity opp2 = new Opportunity();
 	   opp2.RecordTypeId = '01260000000DXs4';
 	   opp2.Number_of_Students__c = 3;
 	   opp2.Name = 'Test Opportunity 2';
 	   opp2.StageName = 'Identify';
 	   opp2.CloseDate = Date.newInstance(2009,01,01);
 	   insert opp2;
 	  
 	   // create the line item
 	   OpportunityLineItem oli3 = new OpportunityLineItem();
 	   oli3.Quantity = 7;
 	   oli3.TotalPrice = 8;
 	   oli3.PricebookEntryId = pbe1.id;
 	   oli3.OpportunityId = opp2.id;    
 	   lineitems.add(oli3); 				  
 	  
 	  
 	   // insert all of the line items
 	   insert lineitems;
 		  

    }

}
