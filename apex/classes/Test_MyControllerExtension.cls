@isTest
private class Test_MyControllerExtension {

  static MyController ext;
  static MasterObject__c masterObject;
  static PageReference pref;
  static User testUser;

  static {

    Profile p = [select id from profile where name='Some Profile'];

    testUser = new User(alias = 'u1', email='u1@testorg.com',
      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
      localesidkey='en_US', profileid = p.Id, country='United States',
      timezonesidkey='America/Los_Angeles', username='u1@testorg.com');

    insert testUser;

  }

  private static void init() {

    masterObject = new MasterObject__c(Name='Test Object 1');
    insert masterObject;

    DetailObject__c d1 = new DetailObject__c(
		Name='Detail 1',Status__c='Open',MasterObject__c=masterObject.Id);
    DetailObject__c d2 = new DetailObject__c(
		Name='Detail 2',Status__c='Closed',MasterObject__c=masterObject.Id);
    DetailObject__c d3 = new DetailObject__c(
		Name='Detail 3',Status__c='Declined',MasterObject__c=masterObject.Id);

    List<DetailObject__c> children = new List<DetailObject__c>();
    children.add(d1);
    children.add(d2);
    children.add(d3);
    insert children;

    pref = Page.MoveRecords;
    pref.getParameters().put('id',masterObject.id);
    Test.setCurrentPage(pref);

    ApexPages.StandardController con = new ApexPages.StandardController(masterObject);
    ext = new MyController(con);

  }

  static testMethod void testMoveOpenOnly() {

    init();

    Test.startTest();

    // choose the owner of the new master object
    ext.testUserId = testUser.Id;           
    // indicate that we want to move the closed children
    ext.moveClosed = true;

    // perform some more assertions

    pref = ext.save();
    System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

    // ensure the original master object contains 1 child
    System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
    // ensure the new master object contains 2 children
    System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

    Test.stopTest();

  }
   
  static testMethod void testDoNotReassignDeclined() {

    init();

    Test.startTest();

    // choose the owner of the newmaster object
    ext.salesRepId = salesRep.Id;         
    // indicate that we do NOT want to move the closed children
    ext.moveClosed = false;

    // perform some more assertions

    pref = ext.save();
    System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

    // ensure the original master object contains 2 children
    System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
    // ensure the new master object contains 1 child
    System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

    Test.stopTest();

  }
   
}