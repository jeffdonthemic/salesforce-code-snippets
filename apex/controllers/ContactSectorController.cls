public class ContactSectorController {
	
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
	
    // the contact we are editing
    private Contact contact {get; set;}
	
    public List<SectorWrapper> sectors {
		get {   
			if (sectors == null) sectors = new List<SectorWrapper>();
			return sectors;
		}
		set;
    } 	
	
    public List<SectorWrapper> subsectors {
		get {   
			if (subsectors == null) subsectors = new List<SectorWrapper>();
			return subsectors;
		}
		set;
    }
    	
    // the list of selected sector ids for the soql in clause
    private List<ID> selectedSectorsIds {
		get {
			if (selectedSectorsIds == null) selectedSectorsIds = new List<ID>();
			return selectedSectorsIds;
		}
		set;
    }        	
	
    // the list of existing subsectors ids that is searchable - being used???
    private Set<ID> currentSubsectorIds {
		get {
			if (currentSubsectorIds == null) currentSubsectorIds = new Set<ID>();
			return currentSubsectorIds;
		}
		set;
    }     	
  	
    public ContactSectorController(ApexPages.StandardController controller) {
	
        //initialize the stanrdard controller
        this.controller = controller;
        // populate the sectors and subsectors with existing data
        Set<ID> currentSectorIds = new Set<ID>();  	
    	
        // fetch the contact
        this.contact = [Select Id, Name, RecordTypeId From Contact Where Id = :ApexPages.currentPage().getParameters().get('id')];			

        // find the selected subsectors for the contacts to get the selected sector and sub sector ids
   		for (Subsector_Selected__c  css : [Select s.Sector_Subsector__c, s.Sector_Subsector__r.Parent__c from Subsector_Selected__c s Where s.Contact__c = :contact.Id]) {
   			currentSectorIds.add(css.Sector_Subsector__r.Parent__c);
   			currentSubsectorIds.add(css.Sector_Subsector__c);
   		}   		

		// get all of the sectors and preselect one for this contact
        for(Sector_Subsector__c s : [select Id, Name from Sector_Subsector__c Where Parent__c = null And Company__c = 'Datamonitor' Order By Name]) {
    		SectorWrapper sw = new SectorWrapper(s);
    		// see if this sector is in the list ones from the database
    		if (currentSectorIds.contains(s.id)) sw.checked = true;
            sectors.add(sw);
		}
   		
    }    	
	
    public PageReference step1() {
        return Page.Contact_Sector;
    }
	
    public PageReference step2() {   	

		// clear the list of sector ids were querying for
	    selectedSectorsIds.clear();
	    // clear out the list of resulting sub sectors
	    subsectors.clear();
		
	    // create a list of all of the ids selected
	    for (SectorWrapper sw : sectors) {
			if (sw.checked)
				selectedSectorsIds.add(sw.sector.id);
	    }
		
	    if (selectedSectorsIds.size() > 0) {
			
			// query for all subsectors for the selected sectors and add them to list of sub sector wrappers
		    for(Sector_Subsector__c ss : [Select s.Parent__r.Name, s.Parent__r.Id, s.Parent__c, s.Name, s.Id From Sector_Subsector__c s Where s.Parent__c IN :selectedSectorsIds Order By s.Parent__r.Name]){
			    SectorWrapper ssw = new SectorWrapper(ss);
			    if (currentSubsectorIds.contains(ss.id)) ssw.checked = true;
			    subsectors.add(ssw);
		    }

			return Page.Contact_Sub_Sector;
			
	    } else {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Sector.'));
	        return null;  
	    }
    }  	
	
    public PageReference step3() {

		// display list of sectors and subsectors
		Set<String> selectedSectorNames = new Set<String>();
        String csvSectors = '';
        String csvSubsectors = '';
        List<Subsector_Selected__c> toInsert = new List<Subsector_Selected__c>();
        List<Subsector_Selected__c> toDelete = new List<Subsector_Selected__c>();

	    // create a list of all of the ids selected
	    for (SectorWrapper ssw : subsectors) {
			if (ssw.checked) {
				selectedSectorNames.add(ssw.sector.Parent__r.Name);
				csvSubsectors = csvSubsectors + ssw.sector.Name + ', ';
				toInsert.add(new Subsector_Selected__c(Name = ssw.sector.Name, Sector_Subsector__c = ssw.sector.id, Contact__c = contact.Id));
			}
	    }  
	    csvSubsectors = csvSubsectors.substring(0,csvSubsectors.length()-2);
		
        // create csv list of selected sectors
        for (Sector_Subsector__c sector : [Select s.Name from Sector_Subsector__c s Where s.Id IN :selectedSectorsIds Order By s.Name])
            csvSectors = csvSectors + sector.Name + ', ';
        csvSectors = csvSectors.substring(0,csvSectors.length()-2);	  
    	
        //System.debug('==============================> csvSectors '+csvSectors);
        //System.debug('==============================> csvSubsectors '+csvSubsectors);
    	
        try {
	        	
	        // delete all of the existing subsectors for the contact
	        for (Subsector_Selected__c css : [Select Id From Subsector_Selected__c Where Contact__c = :contact.Id])
	    		toDelete.add(css);
	        if (toDelete.size() > 0)	
	    		delete toDelete;
	    		
	        // insert the array of selected subsectors
	        insert toInsert;
	    		
	        // update the contact with the csv list of sectors and subsectors	
	        contact.Sector__c = csvSectors;	
	        contact.Sub_Sector__c = csvSubsectors;
	        update contact;
        	
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }			

        return (new ApexPages.StandardController(contact)).view();    	

    }	
	
	public static testmethod void testMe() {
		
		Sector_Subsector__c ss1 = new Sector_Subsector__c(
			Company__c='Datamonitor',
			Name='Test'
		);
		insert ss1;	
		// create a new subsector wrapper for the sector
		SectorWrapper sw1 = new SectorWrapper(ss1);  	
		sw1.checked = true;
				
		Sector_Subsector__c ss2 = new Sector_Subsector__c(
			Company__c='Datamonitor',
			Parent__c=ss1.id,
			Name='Test 1'
		);
		insert ss2;	
		// create a new subsector wrapper for the sector
		SectorWrapper sw2 = new SectorWrapper(ss2);  	
		sw2.checked = true;				
		
		Contact c = new Contact(
			FirstName='Test',
			LastName='Test',
			email='no@email.com'
		);
		insert c;
		
        // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.Contact_Sector;
        pref.getParameters().put('id',c.id);
        Test.setCurrentPage(pref);
    	
        // Construct the standard controller for the contact.
        ApexPages.StandardController con = new ApexPages.StandardController(c);      	
    	
        // Switch to runtime context
        Test.startTest();  	
    	
        // Construct the controller class
        ContactSectorController ext = new ContactSectorController(con);   
    	
        System.assertEquals(ext.sectors.size(),[select count() from Sector_Subsector__c Where Parent__c = null And Company__c = 'Datamonitor']); 	
        System.assertEquals(ext.subsectors.size(),0); 	
        System.assertEquals(ext.currentSubsectorIds.size(),0);
        System.assertEquals(ext.selectedSectorsIds.size(),0);  	
        System.assertEquals(ext.contact.name,'Test Test');
    	
		// call the step1 method again
		PageReference ref1 = ext.step1();  
		String step1Page = ext.step1().getUrl();
		System.assertEquals('/apex/contact_sector', step1Page);    	
    	
		// simulate the selection of a sector
		ext.sectors.add(sw1);    	
    	
		// call the step2 method
		PageReference ref2 = ext.step2();   
		String step2Page = ext.step2().getUrl();
		System.assertEquals('/apex/contact_sub_sector', step2Page);
		
		// simulate the selection of a sector
		ext.subsectors.add(sw2);   		
		
		// call the step3 method again
		PageReference ref3 = ext.step3(); 	
		
		// fetch the contact to see if the sector/subsectors are set correctly
		c = [Select Id, Sector__c, Sub_Sector__c From Contact Where Id = :c.id];			
		System.assertEquals(c.Sector__c,ss1.name);
		System.assertEquals(c.Sub_Sector__c,ss2.name);
    	
        // Switch back to test context
        Test.stopTest();    	
	}	   	

}
