@isTest
private class CSV_Tests {
    @TestSetup
    static void loadTestDataFromStaticResource(){
        List<sObject> accounts = Test.loadData(Account.SObjectType, 'accountData');        
    }

    @isTest static void testLoadAccontsFromStaticResource() {
        List<Account> accts = [SELECT Id FROM Account];
        System.assert(accts.size() == 3, 'expected 3 accounts');
    }
}