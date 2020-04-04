trigger SystemDebugTest on Manager_Note__c (after insert, after update) {
	System.debug('>>> show me');
}