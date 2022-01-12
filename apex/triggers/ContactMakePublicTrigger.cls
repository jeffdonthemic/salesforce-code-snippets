/**
Programmatically create sharing rules for objects with a 
private sharing model
 */

 trigger ContactMakePublicTrigger on Contact (after insert, after update) {

  // get the id for the group for everyone in the org
  ID groupId = [select id from Group where Type = 'Organization'].id;

  // inserting new records
  if (Trigger.isInsert) {

    List<ContactShare> sharesToCreate = new List<ContactShare>();

    for (Contact contact : Trigger.new) {
      if (contact.Make_Public__c == true) {

        // create the new share for group
        ContactShare cs = new ContactShare();
        cs.ContactAccessLevel = 'Edit';
        cs.ContactId = contact.Id;
        cs.UserOrGroupId =  groupId;
        sharesToCreate.add(cs);

      }
    }

    // do the DML to create shares
    if (!sharesToCreate.isEmpty())
      insert sharesToCreate;

  // updating existing records
  } else if (Trigger.isUpdate) {

    List<ContactShare> sharesToCreate = new List<ContactShare>();
    List<ID> shareIdsToDelete = new List<ID>();

    for (Contact contact : Trigger.new) {

      // if the record was public but is now private -- delete the existing share
      if (Trigger.oldMap.get(contact.id).Make_Public__c == true &amp;&amp; contact.Make_Public__c == false) {
        shareIdsToDelete.add(contact.id);

      // if the record was private but now is public -- create the new share for the group
      } else if (Trigger.oldMap.get(contact.id).Make_Public__c == false &amp;&amp; contact.Make_Public__c == true) {

        // create the new share with read/write access
        ContactShare cs = new ContactShare();
        cs.ContactAccessLevel = 'Edit';
        cs.ContactId = contact.Id;
        cs.UserOrGroupId =  groupId;
        sharesToCreate.add(cs);

      }

    }

    // do the DML to delete shares
    if (!shareIdsToDelete.isEmpty())
      delete [select id from ContactShare where ContactId IN :shareIdsToDelete and RowCause = 'Manual'];

    // do the DML to create shares
    if (!sharesToCreate.isEmpty())
      insert sharesToCreate;

  }

}