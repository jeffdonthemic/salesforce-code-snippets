public class CASOpportunityController {
	
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}

    private Opportunity opp;

    public string selectedLevel1 {get; set;}
    public string selectedLevel2 {get; set;}
    public string selectedLevel3 {get; set;}
	
    public List<SelectOption> level1Items {
		get {
			List<SelectOption> options = new List<SelectOption>();
				
				boolean showNorthAmerica = false;
				// find out what country the current user is from
				string country = [select Id, Country from User where Id = :UserInfo.getUserId()].Country;
				if (country == 'United States' || country == 'Canada')
					showNorthAmerica = true;
				
		        options.add(new SelectOption('','-- Choose a Category --'));
		        for (CAS_Course_Cat1__c cat : [select Id, Name from CAS_Course_Cat1__c where North_America__c = :showNorthAmerica Order By Name])
		            options.add(new SelectOption(cat.Id,cat.Name));
		        	
	        return options;			
		}
		set;
    }
	
    public List<SelectOption> level2Items {
		get {
	        List<SelectOption> options = new List<SelectOption>();

	        if (selectedLevel1 != NULL) {
	            options.add(new SelectOption('','-- Choose a Category --'));
	            for (CAS_Course_Cat2__c cat : [select Id, Name from CAS_Course_Cat2__c Where CAS_Course_Cat1__c = :selectedLevel1 Order By Name])
	                options.add(new SelectOption(cat.Id,cat.Name));
	        }
	    	
	        return options;			
		}
		set;
    }	
	
    public List<SelectOption> level3Items {
		get {
	        List<SelectOption> options = new List<SelectOption>();

	        if (selectedLevel2 != NULL) {
	            options.add(new SelectOption('','-- Choose a Category --'));
	            for (CAS_Course_Cat3__c cat : [select Id, Name from CAS_Course_Cat3__c Where CAS_Course_Cat2__c = :selectedLevel2 Order By Name])
	                options.add(new SelectOption(cat.Id,cat.Name));
	        }
	    	
	        return options;			
		}
		set;
    }    	
	
    // if category 1 is null, then redirect them to the course category edit page
    public PageReference checkCategory(){
	    if (opp.CAS_Course_Cat1__c == null) {
			PageReference newRef = Page.CAS_Course_Categories_Edit;
			newRef.getParameters().put('id', opp.id);
			newRef.setRedirect(true);
			return newRef;
	    } else {
			return null;
	    }
    }	
	
    public CASOpportunityController(ApexPages.StandardController controller) {
	
        //initialize the stanrdard controller
        this.controller = controller;
    	
        this.opp = (Opportunity)controller.getRecord();
    	
        selectedLevel1 = opp.CAS_Course_Cat1__c;
        selectedLevel2 = opp.CAS_Course_Cat2__c;
        selectedLevel3 = opp.CAS_Course_Cat3__c;  
    	
    }	
	
    public PageReference goToCourseCategories() {
		
		PageReference newPage = Page.CAS_Course_Categories_Edit;
        newPage.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        return newPage.setRedirect(true);
		
    }     	
	
    public PageReference cloneOpp() {
		
		PageReference newPage = new PageReference('/'+opp.id+'/e?clone=1');
        return newPage.setRedirect(true);
    	
    }   	
	
    public PageReference shareOpp() {
		
		PageReference newPage = new PageReference('/p/share/OppSharingDetail?parentId='+opp.id);
        return newPage.setRedirect(true);
    	
    }         	
	
    public PageReference save() {
        opp.CAS_Course_Cat1__c = selectedLevel1;
        opp.CAS_Course_Cat2__c = selectedLevel2;
        opp.CAS_Course_Cat3__c = selectedLevel3;
    	
        try {
            upsert(opp);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return (new ApexPages.StandardController(opp)).view();
    }     	
	
}
