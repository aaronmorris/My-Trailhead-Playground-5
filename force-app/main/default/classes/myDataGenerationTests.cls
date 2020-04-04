@isTest
private class myDataGenerationTests {
    @TestSetup
    static void loadTestDataFromStaticResource(){
        List<sObject> accounts = Test.loadData(Account.SObjectType, 'Mock_Data');        
    }

    @isTest static void testLoadAccontsFromStaticResource() {
        List<Account> accts = [SELECT Id FROM Account];
        System.assert(accts.size() == 15, 'expected 15 accounts');
    }
}