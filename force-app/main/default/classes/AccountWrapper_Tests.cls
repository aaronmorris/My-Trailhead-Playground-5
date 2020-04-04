@isTest
private class AccountWrapper_Tests {
  @testSetup
  static void loadTestData(){
    List<Account> accounts = (List<Account>) Test.loadData(Account.SObjectType, 'accountData');
    List<Opportunity> opps = new List<Opportunity>();
    for(Account a : accounts){
      opps.addAll(TestFactory.generateOppsForAccount(a.id, 1000000.00, 5));
    }
    insert opps;
  }
  @isTest static void testPositiveRoundedAveragePrice() {
    List<AccountWrapper> accounts = new List<AccountWrapper>();
    for(Account a : [SELECT ID, Name FROM ACCOUNT]){
      accounts.add(new AccountWrapper(a));
    }
    // sanity check asserting that we have opportunities before executing our tested method.
    List<Opportunity> sanityCheckListOfOpps = [SELECT ID FROM Opportunity];
    System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue');
    Test.startTest();
    for(AccountWrapper a : accounts){
      System.assertEquals(a.getRoundedAvgPriceOfOpps(), 1000000.00, 'Expected to get 1000000.00');
    }
    Test.stopTest();
  }
    
    @isTest static void testPositiveIsHighPriority() {
        List<AccountWrapper> accounts = new List<AccountWrapper>();
        for(Account a : [SELECT ID, Name FROM ACCOUNT]){
          accounts.add(new AccountWrapper(a));
        }

        Test.startTest();
        for(AccountWrapper a : accounts){
            System.assert(a.isHighPriority(), 'Expected to get true');
        }
        Test.stopTest();
    }

    @isTest static void testNegativeAccountWrapperRoundedOpps() {
        List<Account> accts = [SELECT id FROM Account];
        List<Opportunity> opps = [SELECT Id, Amount FROM Opportunity WHERE accountId in :accts];
        List<AccountWrapper> wrappers = new List<AccountWrapper>();
        
        for (Opportunity o : opps) {
            o.amount = 0;
        }

        update opps;

        for (Account a: accts) {
            wrappers.add(new AccountWrapper(a));
        }

        Test.startTest();
        List<Boolean> exceptions = new List<Boolean>();
        for (AccountWrapper a : wrappers) {
            try {
                a.getRoundedAvgPriceOfOpps();
            }
            catch (AccountWrapper.AWException awe) {
                if (awe.getMessage().equalsIgnoreCase('no won opportunities')) {
                    exceptions.add(true);
                }
            }
        }
        Test.stopTest();
        
        for (Boolean b : exceptions) {
            System.assert(b, 'Account should have thrown an exception');
        }
    }
}