// This code should be combined with the AccountHandler code, but it is separated based on the trailhead instructions
public with sharing class AccountTriggerHandler {
	// Suppress the warning for naming convention because this is the name the instrutions gave
	@SuppressWarnings('PMD.MethodNamingConventions')
    public static void CreateAccounts(List<Account> accounts) {
		for (Account account : accounts) {
			account.ShippingState = account.BillingState;
		}
	}
}
