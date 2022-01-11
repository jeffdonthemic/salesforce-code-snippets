public class DispatcherOpportunityNewController {
	
    private final ApexPages.StandardController controller;   	

    public DispatcherOpportunityNewController(ApexPages.StandardController controller) {
        this.controller = controller;
    } 	
 	
    public PageReference getRedir() {
    	
        PageReference newPage;

        if (ApexPages.currentPage().getParameters().get('RecordType') == '01260000000DXs4') {
            newPage = Page.CAS_Opportunity_New;
            // this does not make a difference either
            newPage.getParameters().put('RecordType', ApexPages.currentPage().getParameters().get('RecordType'));
            return newPage.setRedirect(true);
        } else {
            return null;
        }
 	
    }
 
}
