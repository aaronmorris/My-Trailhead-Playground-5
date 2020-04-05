public without sharing class AccountUtils {
	public static List<Account> accountsByState (String abbreviation) {
		if (!Schema.sObjectType.Account.isAccessible()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MESSAGE_INSUFFICIENT_ACCESS));
			return null;
		}

		List<Account> accounts = [
			SELECT
				Id,
				Name,
				BillingState
			FROM Account
			WHERE
				BillingState = :abbreviation
		];

		return accounts;
	}

	public static final String
		ERROR_MESSAGE_INSUFFICIENT_ACCESS = 'Error: Insufficient access to object.';
}
