@IsTest
public with sharing class AccountTrigger_Test {
    @IsTest static void TestCreateNewAccountInBulk() {
		// Test Setup data
		// Create 200 new Accounts
		List<Account> accounts = new List<Account>();
		for (Integer i=0; i < 200; i++) {
			Account account = new Account(Name = 'Test Account ' + i);
			accounts.add(account);
		}

		// Perform Test
		Test.startTest();
		insert accounts;
		Test.stopTest();

		// Verify that 200 new Accounts were inserted
		List<Account> verifyAccounts = [SELECT Id FROM Account];
		System.assertEquals(200, verifyAccounts.size());
		// Aslo verify that 200 new Opportunities were inserted
		List<Opportunity> verifyOpportunities = [SELECT Id FROM Opportunity];
		System.assertEquals(200, verifyOpportunities.size());
	}
}
