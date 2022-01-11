public class CASContactSearchExportController {
		
	static final Id casCourseOppRecordType = '01260000000DXs4AAG';	
	
	private String searchType {get; set;}
	private String subjectCodes {get; set;}
	private Id level1 {get; set;}
	private Id level2 {get; set;}
	private Id level3 {get; set;}
	private Date closeDateFrom {get; set;}
	private Date closeDateTo {get; set;}
    public String countries {
		get {
			if (countries == null) countries = '';
	        return countries;			
		}
		set;
    }
	
	// the search results
    public List<Contact> results {
		get {
			if (results == null) results = new List<Contact>();
	        return results;			
		}
		set;
    }
	
    public CASContactSearchExportController() {
		 	
        searchType = ApexPages.currentPage().getParameters().get('searchType');
    	
        if (searchType == 'SubjectCodes') {
    		if (ApexPages.currentPage().getParameters().get('scodes') != null) {
    			 subjectCodes = toSoqlList(ApexPages.currentPage().getParameters().get('scodes').split(',',0));
    		}
	        if (ApexPages.currentPage().getParameters().get('c') != null) {
	    		// convert the comma separated list of countries (USA,Canada,France) to a soql list ('USA','Canada','France')
	    		countries = toSoqlList(ApexPages.currentPage().getParameters().get('c').split(',',0));
	        }
	        doSubjectCodeSearch();
        } else {
    		if (ApexPages.currentPage().getParameters().get('l1') != null) level1 = ApexPages.currentPage().getParameters().get('l1');
	        if ( ApexPages.currentPage().getParameters().get('l2') != null) level2 = ApexPages.currentPage().getParameters().get('l2');
	        if (ApexPages.currentPage().getParameters().get('l3') != null) level3 = ApexPages.currentPage().getParameters().get('l3');
	        if (ApexPages.currentPage().getParameters().get('f') != null) closeDateFrom = Date.valueOf(ApexPages.currentPage().getParameters().get('f'));
	        if (ApexPages.currentPage().getParameters().get('t') != null) closeDateTo = Date.valueOf(ApexPages.currentPage().getParameters().get('t'));
	        if (ApexPages.currentPage().getParameters().get('c') != null) {
	    		// convert the comma separated list of countries (USA,Canada,France) to a soql list ('USA','Canada','France')
	    		countries = toSoqlList(ApexPages.currentPage().getParameters().get('c').split(',',0));
	        }
	        doCategorySearch();
        }
    	
    }
	
    private void doSubjectCodeSearch() {
		
		String qry = 'Select c.Title, c.Phone, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.LastName, c.FirstName, c.Email, c.Account.Name, c.AccountId From Contact c Where c.Id IN (';
		qry += 'Select c.Contact__c from CAS_Subject_Code_Contact__c c Where Subject_Code__c IN ('+subjectCodes+') ';
   
		if (countries.length() > 0) qry += 'And c.Contact__r.MailingCountry IN ('+countries+') ';  
			
		qry += ') Order By c.LastName';		
		
		results = Database.query(qry);
		
    }
	
    private void doCategorySearch() {
		
		String qry = 'Select c.Title, c.Phone, c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry, c.MailingCity, c.LastName, c.FirstName, c.Email, c.Account.Name, c.AccountId From Contact c Where c.Id IN (';
		qry += 'Select o.ContactId from OpportunityContactRole o Where o.Opportunity.RecordTypeId = \''+casCourseOppRecordType+'\' And o.Opportunity.CAS_Course_Cat1__c = \''+level1+'\' ';
		
		if (level2 != null) qry += 'And o.Opportunity.CAS_Course_Cat2__c = \''+level2+'\' ';		
			
		if (level3 != null) qry += 'And o.Opportunity.CAS_Course_Cat3__c = \''+level3+'\' ';					
		
		if (countries.length() > 0) qry += 'And o.Contact.MailingCountry IN ('+countries+') ';   
			
		if (closeDateFrom != null) qry += ' And o.Opportunity.CloseDate >= ' + toSoqlDate(closeDateFrom);	
			
		if (closeDateTo != null) qry += ' And o.Opportunity.CloseDate <= ' + toSoqlDate(closeDateTo);
 
  		qry += ') Order By c.LastName';	
		
		results = Database.query(qry);		
		
    }    	
	
    // converts a comma separated list of values (USA,Canada,France) to a soql list ('USA','Canada','France')
    private String toSoqlList(List<String> l) {
		String s = '';
		for (Integer i=0;i<l.size();i++) {
			s += '\''+l.get(i)+'\'';
			if (i != l.size()-1) s += ',';
		}
		return s;
    }		
	
    // converts a Date to a string date for soql
    private String toSoqlDate(Date d) {
		String r = d.year() + '-';
		if (String.valueOf(d.month()).length() == 1)
			r += '0'+d.month()+'-';
		else
			r += d.month()+'-';

		if (String.valueOf(d.day()).length() == 1)
			r += '0'+d.day();
		else
			r += d.day();
		
		return r;
    }	

}
