public with sharing class AccountHandler {
	public static void createNewOpportunity(List<Account> accounts) {
		if (!Schema.sObjectType.Opportunity.isCreateable()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MESSAGE_INSUFFICIENT_ACCESS));
			return;
		}

		List <Opportunity> opportunitiesToAdd = new List<Opportunity>();
		for (Account account : accounts) {
			Opportunity opportunity = new Opportunity();
			opportunity.Name = account.Name + ' Opportunity';
			opportunity.AccountId = account.Id;
			opportunity.StageName = 'Prospecting';
			opportunity.CloseDate = System.today().addMonths(1);
			opportunitiesToAdd.add(opportunity);
		}

		insert opportunitiesToAdd;
	}

	public static final String
		ERROR_MESSAGE_INSUFFICIENT_ACCESS = 'Insufficient access to object';
}
