@IsTest
public with sharing class AccountTrigger_Test {
    @IsTest static void testCreateNewAccountInBulk() {
		List<Account> accounts = new List<Account>();
		for (Integer i=0; i < 200; i++) {
			Account account = new Account(Name = 'Test Account ' + i);
			accounts.add(account);
		}

		Test.startTest();
		insert accounts;
		Test.stopTest();

		List<Account> verifyAccounts = [SELECT Id FROM Account];
		System.assertEquals(200, verifyAccounts.size(), 'Expected 200 accounts to have been created');

		List<Opportunity> verifyOpportunities = [SELECT Id FROM Opportunity];
		System.assertEquals(200, verifyOpportunities.size(), 'Expected 200 Opportunities to have been created in the trigger');
	}
}
