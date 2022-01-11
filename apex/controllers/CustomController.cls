/**
<apex:page controller="CustomController" tabStyle="Account">
	Hello {!$User.FirstName}!
	<p>You belong to the {!account.name} account.</p>
</apex:page>
 */

public class CustomController {
	public Account getAccount() {
		return [select id, name from Account where id = :System.currentPageReference().getParameters().get('id')];
	}

	public String getName() {
		return 'My Second Custom Controller';
	}
}