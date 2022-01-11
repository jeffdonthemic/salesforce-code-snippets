static testMethod void TestQuoteApp() { 
   // To begin, the sample application first creates the necessary records 
   // to test OpportunityLineItems: Pricebook2, Product2, and PricebookEntry 
   // First it creates a product with a standard price 
   Product2 p = new product2(name='x', color__c='c'); 
   insert p; 
   Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1]; 
   insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id, 
                             unitprice=1.0, isActive=true); 
   // Next, it creates a new pricebook with an entry for this product 
   Pricebook2 pb = new pricebook2(name='test'); 
   insert pb; 
   PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id, 
                                           unitprice=1.0, isActive=true); 
   insert pbe;     
   // To test the first example from the sample application, the test 
   // method creates an opportunity line item using the pricebook entry, 
   // and then asserts that the Color field was correctly copied from the 
   // product after record insertion. 
   Opportunity o = new Opportunity(name='test', pricebook2id=pb.id, 
                                   stageName='Open', 
                                   CloseDate=Date.newInstance(2006,10,10)); 
   insert o; 
   OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, 
                                     pricebookentryid=pbe.id, unitprice=1.5, 
                                     quantity=2); 
   insert oli; 
   System.assertEquals('c', [select color__c from opportunitylineitem 
                             where id = :oli.id].color__c); 
   // To test the fifth example from the sample application, the test method 
   // creates a primary quote and then asserts that its Primary field cannot 
   // be deselected. The code uses the try...catch testing idiom to assert 
   // that the error message is correct. 
   Quote__c q = new Quote__c(opportunity__c = o.id, primary__c = true); 
   insert q; 
   // Can't mark it non-primary 
   q.primary__c = false; 
   try { 
       update q; 
   } catch (DmlException e) { 
       System.assert(e.getMessage().contains('first error: 
                     FIELD_CUSTOM_VALIDATION_EXCEPTION, 
                     Primary quote cannot be marked non-primary: [Primary__c]'), 
                     e.getMessage());
       System.assertEquals('Primary quote cannot be marked non-primary', 
                           e.getDmlMessage(0));
       System.assertEquals('Primary__c', e.getDmlFields(0)[0]);
   }       
   // To test the second and third examples from the sample application, the 
   // test method asserts that the inserted quote has the proper quote line 
   // data copied from the opportunity line item, and that the quote's total 
   // value is properly calculated. 
   System.assertEquals(1, [select count() from quoteline__c 
                           where quote__c = :q.id]); 
   // Total on the quote should be correct 
   System.assertEquals(3.0, [select total__c from quote__c 
                             where id = :q.id].total__c); 
   // To test the fourth example from the sample application, the test 
   // method asserts that the opportunity and quote cannot be deleted 
   // since the quote is primary 
   try { 
       delete o; 
       System.assert(false); 
   } catch (DmlException e) { 
       System.assert(e.getDmlMessage(0).indexOf('Cannot delete 
                     opportunity with a quote') > -1); 
   } 
   try { 
       delete q; 
       System.assert(false); 
   } catch (DmlException e) { 
       System.assert(e.getDmlMessage(0).indexOf('Primary 
                     quote cannot be deleted') > -1); 
   } 
   // The test method now creates a second quote, marks it primary, and 
   // verifies that the first quote is no longer primary. 
   Quote__c q2 = new Quote__c(opportunity__c = o.id, primary__c = true); 
   insert q2; 
   System.assert(![select primary__c from quote__c 
                   where id = :q.id].primary__c); 
   // Finally, the test method performs DML operations on quote line 
   // items to assert that the quote line item values are properly 
   // recalculated when associated values change. 
   QuoteLine__c qLine = new QuoteLine__c(quote__c = q.id, product__c = p.id, 
                                         unitprice__c = 2.0, quantity__c = 2); 
   insert qLine; 
   System.assertEquals(7.0, [select total__c from quote__c 
                             where id = :q.id].total__c); 
   qLine.unitprice__c = 3.0; 
   update qLine; 
   System.assertEquals(9.0, [select total__c from quote__c 
                             where id = :q.id].total__c); 
   delete qLine; 
   System.assertEquals(3.0, [select total__c from quote__c 
                             where id = :q.id].total__c); 

   // Try a bulk line item operation
   insert new QuoteLine__C[]{qLine1, qLine1.clone()};
   System.assertEquals(11.0, [select total__c from quote__c 
                              where id = :q.id].total__c);

   // Test that updating the product master color and then updating the 
   // quote colors works	    
   p.color__c = 'c2';
   update p;
   updateColors(q.id);
   for (QuoteLine__c line : [select color__c from quoteLine__c 
                             where quote__c = :q.id]) {
      System.assertEquals('c2', line.color__c);
   }
}
