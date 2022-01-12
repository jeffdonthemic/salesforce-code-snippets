@isTest
private class TestPurchaseOrderCloneWithController {

    static testMethod void testPOCloneController() {

       // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.PurchaseOrderClone;
        Test.setCurrentPage(pref);

        // setup a ship to account
        Account shipTo = new Account();
        shipTo.Name = 'PSAV 6FOO';
        shipTo.Type = 'Supplier';
        insert shipTo;

        // create new po record
        Purchase_Order__c po = new Purchase_Order__c();
        po.Date_Needed__c = Date.newInstance(2020,01,01);
        po.Ship_To__c = shipTo.id;
        insert po;

        // create a line item for the po
        Purchased_Item__c pi1 = new Purchased_Item__c();
        pi1.Description__c = 'My item';
        pi1.Purchase_Order__c = po.id;
        pi1.Quantity__c = 1;
        pi1.Unit_Price__c = 10;
        insert pi1;

        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(po);

        // create the controller
        PurchaseOrderCloneWithItemsController ext = new PurchaseOrderCloneWithItemsController(con);

        // Switch to test context
        Test.startTest();

        // call the cloneWithItems method
        PageReference ref = ext.cloneWithItems();
        // create the matching page reference
        PageReference redir = new PageReference('/'+ext.newRecordId+'/e?retURL=%2F'+ext.newRecordId);

        // make sure the user is sent to the correct url
        System.assertEquals(ref.getUrl(),redir.getUrl());

        // check that the new po was created successfully
        Purchase_Order__c newPO = [select id from Purchase_Order__c where id = :ext.newRecordId];
        System.assertNotEquals(newPO, null);
        // check that the line item was created
        List<Purchased_Item__c> newItems = [Select p.Id From Purchased_Item__c p where Purchase_Order__c = :newPO.id];
        System.assertEquals(newItems.size(),1);

        // Switch back to runtime context
        Test.stopTest();

    }

}