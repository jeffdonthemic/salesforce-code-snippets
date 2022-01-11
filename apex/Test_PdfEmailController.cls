@isTest
private class Test_PdfEmailController {

  static Account account;

  static {
    
    account = new Account();
    account.Name = 'Test Account';
    insert account;
    
  }

  static testMethod void testPdfEmailer() {

    PageReference pref = Page.PdfEmailer;
    pref.getParameters().put('id',account.id);
    Test.setCurrentPage(pref);
        
    PdfEmailController con = new PdfEmailController();    
           
    Test.startTest();
    
    System.assertEquals(2,con.accounts.size());
    
    // populate the field with values
    con.accountId = account.id;
    con.email = 'test@noemail.com';
    // submit the record
    pref = con.sendPdf();
    
    Test.stopTest(); 

  }
}