// This should be combined with AccountTrigger_Test.cls but this is the class name the Trailhead exercise gave
// Suppressing PMD.MethodNamingConventions for my own testing name conventions
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest
public with sharing class AccountTriggerTest {
	@IsTest static void beforeInsert_bulkProcessing() {
		List<Account> accountsToInsert = new List<Account>();
		for (Integer i = 0; i < 200; i++) {
			Account account = new Account(Name = 'Account ' + i);
			account.BillingState = 'CA';
			accountsToInsert.add(account);
		}

		Test.startTest();
		insert accountsToInsert;
		Test.stopTest();

		List<Account> accounts = [SELECT BillingState, ShippingState FROM Account];

		for (Integer j = 0; j < 200; j++) {
			System.assertEquals('CA', accounts[j].BillingState, 'The billing state should have been inserted');
			System.assertEquals('CA', accounts[j].ShippingState, 'The shipping state should have been set in the trigger');
		}
	}
}
