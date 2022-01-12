@isTest
private class TestContactMakePublicTrigger {

    // test that newly inserted records marked as pubic=true have corresponding shares created
    static testMethod void testAddShares() {

    Set<ID> ids = new Set<ID>();
    List<Contact> contacts = new List<Contact>();

    for (Integer i=0;i<50;i++)
      contacts.add(new Contact(FirstName='First ',LastName='Name '+i,
        Email='email'+i+'@email.com',Make_Public__c=true));

    insert contacts;

    // get a set of all new created ids
    for (Contact c : contacts)
      ids.add(c.id);

    // assert that 50 shares were created
    List<ContactShare> shares = [select id from ContactShare where 
      ContactId IN :ids and RowCause = 'Manual'];
    System.assertEquals(shares.size(),50);

    }

    // insert records and switch them from public = true to public = false
    static testMethod void testUpdateContacts() {

    Set<ID> ids = new Set<ID>();
    List<Contact> contacts = new List<Contact>();

    for (Integer i=0;i<50;i++)
      contacts.add(new Contact(FirstName='First ',LastName='Name '+i,
        Email='email'+i+'@email.com',Make_Public__c=false));

    insert contacts;

    for (Contact c : contacts)
      ids.add(c.id);

    update contacts;

    // assert that 0 shares exist
    List<ContactShare> shares = [select id from ContactShare where 
      ContactId IN :ids and RowCause = 'Manual'];
    System.assertEquals(shares.size(),0);

    for (Contact c : contacts)
      c.Make_Public__c = true;

    update contacts;

    // assert that 50 shares were created
    shares = [select id from ContactShare where ContactId IN :ids and RowCause = 'Manual'];
    System.assertEquals(shares.size(),50);

    for (Contact c : contacts)
      c.Make_Public__c = false;

    update contacts;

    // assert that 0 shares exist
    shares = [select id from ContactShare where ContactId IN :ids and RowCause = 'Manual'];
    System.assertEquals(shares.size(),0);

    }
}