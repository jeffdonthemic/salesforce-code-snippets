/**
<apex:page standardController="Purchase_Order__c"
     extensions="PurchaseOrderCloneWithItemsController"
     action="{!cloneWithItems}">
     <apex:pageMessages />
</apex:page>
 */

public class PurchaseOrderCloneWithItemsController {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private Purchase_Order__c po {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public PurchaseOrderCloneWithItemsController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        po = (Purchase_Order__c)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithItems() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Purchase_Order__c newPO;

         try {

              //copy the purchase order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             po = [select Id, Name, Ship_To__c, PO_Number__c, Supplier__c, Supplier_Contact__c, Date_Needed__c, Status__c, Type_of_Purchase__c, Terms__c, Shipping__c, Discount__c from Purchase_Order__c where id = :po.id];
             newPO = po.clone(false);
             insert newPO;

             // set the id of the new po created for testing
               newRecordId = newPO.id;

             // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<Purchased_Item__c> items = new List<Purchased_Item__c>();
             for (Purchased_Item__c pi : [Select p.Id, p.Unit_Price__c, p.Quantity__c, p.Memo__c, p.Description__c From Purchased_Item__c p where Purchase_Order__c = :po.id]) {
                  Purchased_Item__c newPI = pi.clone(false);
                  newPI.Purchase_Order__c = newPO.id;
                  items.add(newPI);
             }
             insert items;

         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }

        return new PageReference('/'+newPO.id+'/e?retURL=%2F'+newPO.id);
    }

}