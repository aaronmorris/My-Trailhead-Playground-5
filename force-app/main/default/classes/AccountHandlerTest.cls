// Suppressing PMD.MethodNamingConventions for my own testing name conventions
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest
public with sharing class AccountHandlerTest {
    @IsTest static void createNewOpportunity_singleAccount() {
		List<Account> accounts = TestFactory.createAccounts(1);

		Test.startTest();
		AccountHandler.createNewOpportunity(accounts);
		Test.stopTest();

		List<Opportunity> opportunities = TestUtility.getOpportunities();
		System.assertEquals(1, opportunities.size(), 'Expected only one Opportunity to have been created');
		System.assertEquals('Prospecting', opportunities[0].StageName, 'Expected the StageName to be "Prospecting"');
		System.assertEquals(accounts[0].Name + ' Opportunity', opportunities[0].Name, 'Opportunity name was set incorrectly');
		System.assertEquals(accounts[0].Id, opportunities[0].AccountId, 'The AccountId was set incorrectly');
	}

	@IsTest static void createNewOpportunity_error_noAccess() {
		List<Account> accounts = TestFactory.createAccounts(1);

		User noAccessUser = TestUtility.createUserWithNoAccess();
		List<ApexPages.Message> pageMessages = new List<ApexPages.Message>();

		System.runAs(noAccessUser) {
			Test.startTest();
			AccountHandler.createNewOpportunity(accounts);
			pageMessages = ApexPages.getMessages();
			Test.stopTest();
		}

		List<Opportunity> opportunities = TestUtility.getOpportunities();

		System.assertEquals(0, opportunities.size(), 'Expected no opportunities to have been');
		System.assertEquals(1, pageMessages.size(), 'Expected there to be 1 PageMessage');
		System.assertEquals(ApexPages.Severity.ERROR, pageMessages[0].getSeverity(), 'Expected the message severity to be ERROR');
		System.assertEquals(pageMessages[0].getDetail(), AccountHandler.ERROR_MESSAGE_INSUFFICIENT_ACCESS, 'Expected the error message to be ' + AccountHandler.ERROR_MESSAGE_INSUFFICIENT_ACCESS);
	}
}
