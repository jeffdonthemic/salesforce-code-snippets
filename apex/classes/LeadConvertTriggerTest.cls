@IsTest
private class LeadConvertTriggerTest {
	
	public static testMethod void testCasLeadConvert() {
		
		Lead lead = new Lead(
			firstName='Jeff',
			lastName='Test Lead',
			company='Jeff Test Company',
			course_name__c = 'My Course Name',
			recordtypeid='01260000000DXrVAAW',
			Country_List__c='United States',
			State_List__c='Florida'			
		);
		insert lead;
	
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(lead.id);
		
		LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		System.debug('========================== lead convert results: '+lcr);
		System.assert(lcr.isSuccess());
		
		// fetch the lead again to get the converted ids
		lead = [Select l.Id, l.Course_Name__c, l.Country_List__c, l.State_List__c, l.ConvertedOpportunityId, l.ConvertedContactId, l.ConvertedAccountId From Lead l Where l.Id = :lead.Id];		
		
		Contact contact = [select Mailing_State_List__c, Mailing_Country_List__c from Contact where Id = :lead.ConvertedContactId];	
		Opportunity opp = [select Name from Opportunity where Id = :lead.ConvertedOpportunityId];	

		System.assertEquals(lead.Country_List__c,contact.Mailing_Country_List__c);
		System.assertEquals(lead.State_List__c,contact.Mailing_State_List__c);
		System.assertEquals(lead.Course_Name__c,opp.Name);
		
	}	

	public static testMethod void testDatamonitorLeadConvert() {
		
		Lead lead = new Lead(
			firstName='Jeff',
			lastName='Test Lead',
			company='Jeff Test Company',
			recordtypeid='01260000000DSdsAAG'
		);
		insert lead;
		
		Set<ID> sectorIds = new Set<ID>();
		Set<String> sectorNames = new Set<String>();
		Set<ID> subSectorIds = new Set<ID>();
		Set<String> subSectorNames = new Set<String>();	
        String csvSectors = '';
        String csvSubsectors = '';		
        List<Subsector_Selected__c> sectorsToInsert = new List<Subsector_Selected__c>();
    	
        // add some new sector/subsector data
        Sector_Subsector__c s1 = new Sector_Subsector__c(
    		name='Sector 1',
    		Company__c='Datamonitor'
        );
        insert s1;
    	
        Sector_Subsector__c s2 = new Sector_Subsector__c(
    		name='Sub Sector',
    		Company__c='Datamonitor',
    		Parent__c=s1.Id
        );
        insert s2;    	
    	
		
		// get some sectors
		for (Sector_Subsector__c sector : [Select s.Name, s.Id From Sector_Subsector__c s where s.Parent__c = null limit 2]) {
			sectorIds.add(sector.Id);
			sectorNames.add(sector.Name);
			csvSectors = csvSectors + sector.Name + ', ';
		}
		csvSectors = csvSectors.substring(0,csvSectors.length()-2);	
		
		// get their sub sectors
		for (Sector_Subsector__c sector : [Select s.Name, s.Id From Sector_Subsector__c s where s.Parent__c IN :sectorIds]) {
			subSectorIds.add(sector.Id);
			subSectorNames.add(sector.Name);
			csvSubsectors = csvSubsectors + sector.Name + ', ';
			
			// create a selected subsector to insert
			Subsector_Selected__c selected = new Subsector_Selected__c();
			selected.Name = sector.Name;
			selected.Lead__c = lead.id;
			selected.Sector_Subsector__c = sector.id;
			sectorsToInsert.add(selected);
		}		
		csvSubsectors = csvSubsectors.substring(0,csvSubsectors.length()-2);
		
		//System.debug('========================== sector ids: '+sectorIds);
		//System.debug('========================== sector names: '+sectorNames);
		//System.debug('========================== sub sector ids: '+subSectorIds);
		//System.debug('========================== sub sector names: '+subSectorNames);	
		//System.debug('========================== sector display: '+csvSectors);
		//System.debug('========================== sub sector display: '+csvSubsectors);			
		
		// add the comma separated list to the lead in for the sector/subsectors
		lead.sector__c = csvSectors;
		lead.sub_sector__c = csvSubsectors;
		update lead;
		
		// add the selected subsectors to the table
		insert sectorsToInsert;
	
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(lead.id);
		
		LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		System.debug('========================== lead convert results: '+lcr);
		System.assert(lcr.isSuccess());
		
		// fetch the lead again to get the converted ids
		lead = [Select l.Id, l.ConvertedOpportunityId, l.ConvertedContactId, l.ConvertedAccountId From Lead l Where l.Id = :lead.Id];		
		
		// fetch the newly inserted subsectors for leads
		List<Subsector_Selected__c> selectedLeads = [Select s.Sector_Subsector__c, s.Name, s.Lead__c From Subsector_Selected__c s Where s.Lead__c = :lead.Id];		
		
		// fetch the newly inserted subsectors for conacts
		List<Subsector_Selected__c> selectedContacts = [Select s.Sector_Subsector__c, s.Name, s.Contact__c From Subsector_Selected__c s Where s.Contact__c = :lead.ConvertedContactId];
		System.assertEquals(selectedLeads.size(),selectedContacts.size());
		
	}

}
