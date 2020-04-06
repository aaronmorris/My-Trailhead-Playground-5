// Cant suppress warning because trigger has to be the first word
// There is logic in the trigger because that is how the Trailhead challenge checks it
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	if (Trigger.isBefore && Trigger.isInsert) {
		AccountTriggerHandler.CreateAccounts(Trigger.new);
	}

	AccountTriggerDirector.direct();
}