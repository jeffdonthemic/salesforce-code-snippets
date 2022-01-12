@isTest
private class Test_DocumentEmailer {

  static Document document;

  static {
    
    document = new Document();
    document.Body = Blob.valueOf('Some Text');
    document.ContentType = 'application/pdf';
    document.DeveloperName = 'my_document';
    document.IsPublic = true;
    document.Name = 'My Document';
    document.FolderId = [select id from folder where name = 'My Test Docs'].id;
    insert document;
    
  }

  static testMethod void testDocumentEmailer() {

    PageReference pref = Page.DocumentEmailer;        
    DocumentEmailController con = new DocumentEmailController();    
           
    Test.startTest();
    
    System.assertEquals(2,con.documents.size());
    
    // populate the field with values
    con.documentId = document.id;
    con.email = 'test@noemail.com';
    // submit the request
    pref = con.sendDoc();
    
    Test.stopTest(); 

  }
}