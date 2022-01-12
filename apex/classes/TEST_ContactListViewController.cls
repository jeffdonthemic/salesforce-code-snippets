@isTest
private class TEST_ContactListViewController {
  private testMethod static void testSuccess() {
    ContactListViewController con = new ContactListViewController();
    con.listName = 'Super Special Contacts';
    System.assert(con.listId != null);
  }
  
  private testMethod static void testFailure() {
    ContactListViewController con = new ContactListViewController();
    con.listName = 'BADLISTNAME';
    System.assert(con.listId == null);
  }    
}