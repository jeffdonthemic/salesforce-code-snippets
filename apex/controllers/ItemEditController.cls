public with sharing class ItemEditController {

  private ApexPages.StandardController controller {get; set;}
  public List<itemObject__c> searchResults {get;set;}
  public string searchText {get;set;}

  // standard controller - could also just use custom controller
  public ItemEditController(ApexPages.StandardController controller) { }

  // fired when the search button is clicked
  public PageReference search() {
    String qry = 'select id, name, value__c from ItemObject__c ' +
      'where name LIKE \'%'+searchText+'%\' order by name';
    searchResults = Database.query(qry);
    return null;
  }

  // fired when the save records button is clicked
  public PageReference save() {

    try {
      update searchResults;
    } Catch (DMLException e) {
      ApexPages.addMessages(e);
      return null;
    }

    return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
  }

  // takes user back to main record
  public PageReference cancel() {
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
  }

}