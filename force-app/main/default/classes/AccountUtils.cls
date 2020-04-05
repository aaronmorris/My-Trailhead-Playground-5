public with sharing class AccountUtils {
    public static List<Account> accountsByState (String abbreviation) {
        // This PMD check may cause the trailhead to fail
        if (Schema.sObjectType.Account.isQueryable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Insufficient access to Account object.'));
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
}
