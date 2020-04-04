trigger IsItNote on Note (before insert) {
	System.debug('>>> in note trigger');
}