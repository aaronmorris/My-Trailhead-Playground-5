// Suppressing PMD.MethodNamingConventions for my own testing name conventions
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest
public with sharing class AccountUtilsTest {
	@IsTest static void accountsByState() {
		List<Account> accounts = createAccounts();
		System.assertEquals(3, accounts.size(), 'Expected there to be 3 accounts created');

		Test.startTest();
		List<Account> matchingAccounts = AccountUtils.accountsByState(VA_BILLING_STATE);
		Test.stopTest();

		System.assertEquals(1, matchingAccounts.size(), 'Expected there to be 1 matching account');
		System.assertEquals(VA_BILLING_STATE, matchingAccounts[0].BillingState, 'Expected the billing state to be ' + VA_BILLING_STATE);
		System.assertEquals(VA_ACCOUNT_NAME, matchingAccounts[0].Name, 'Expected the matching account name to be ' + VA_ACCOUNT_NAME);
	}

	@IsTest static void accountsByState_error_noAccess() {
		List<Account> accounts = createAccounts();
		System.assertEquals(3, accounts.size(), 'Expected there to be 3 accounts created');

		User noAccessUser = TestUtility.createUserWithNoAccess();
		List<Account> matchingAccounts = new List<Account>();
		List<ApexPages.Message> pageMessages = new List<ApexPages.Message>();

		System.runAs(noAccessUser) {
			Test.startTest();
			matchingAccounts = AccountUtils.accountsByState(VA_BILLING_STATE);
			pageMessages = ApexPages.getMessages();
			Test.stopTest();
		}

		System.assertEquals(null, matchingAccounts, 'Expected the accounts returned to be null');
		System.assertEquals(1, pageMessages.size(), 'Expected there to be 1 PageMessage');
		System.assertEquals(ApexPages.Severity.ERROR, pageMessages[0].getSeverity(), 'Expected the message severity to be ERROR');
		System.assertEquals(pageMessages[0].getDetail(), AccountUtils.ERROR_MESSAGE_INSUFFICIENT_ACCESS, 'Expected the error message to be ' + AccountUtils.ERROR_MESSAGE_INSUFFICIENT_ACCESS);
	}

	private static List<Account> createAccounts() {
		Account vaAcccount = new Account(Name = VA_ACCOUNT_NAME);
		Account ncAccount = new Account(Name = NC_ACCOUNT_NAME);
		Account caAccount = new Account(Name = CA_ACCOUNT_NAME);

		vaAcccount.BillingState = VA_BILLING_STATE;
		ncAccount.BillingState = NC_BILLING_STATE;
		caAccount.BillingState = CA_BILLING_STATE;

		List<Account> accountsToInsert = new List<Account> {vaAcccount, ncAccount, caAccount};
		insert accountsToInsert;
		return accountsToInsert;
	}

	private static final String
		VA_ACCOUNT_NAME = 'VA Account',
		VA_BILLING_STATE = 'VA',
		NC_ACCOUNT_NAME = 'NC Account',
		NC_BILLING_STATE = 'NC',
		CA_ACCOUNT_NAME = 'CA Account',
		CA_BILLING_STATE = 'CA';
}
