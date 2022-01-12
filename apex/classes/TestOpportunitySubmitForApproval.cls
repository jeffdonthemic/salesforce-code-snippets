@isTest
private class TestOpportunitySubmitForApproval/ {

    static testMethod void testApprovalSuccess() {

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.Amount = 100;
        opp.CloseDate = Date.today();
        opp.Probability = 10;
        opp.StageName = 'Prospecting';
        // insert the new opp
        insert opp;
        // change the probability of the opp so the trigger submits it for approval
	opp.Probability = 40;
	// update the opp which should submit it for approval
	update opp;

        // ensure that the opp was submitted for approval
        List&lt;ProcessInstance&gt; processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :opp.id];
	System.assertEquals(processInstances.size(),1);

    }

}