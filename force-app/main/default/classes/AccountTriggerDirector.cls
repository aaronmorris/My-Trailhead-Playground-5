public with sharing class AccountTriggerDirector {
    public static void direct() {
		if (Trigger.isAfter && Trigger.isInsert) {
			AccountHandler.createNewOpportunity(Trigger.new);
		}
    }
}
