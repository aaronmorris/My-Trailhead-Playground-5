@isTest
private class DataGeneration_Tests {
    @TestSetup
    static void dataCreation(){
        Account a = TestFactory.getAccount('Muddy Waters Inc.', true);
        Contact c = TestFactory.getContact(a.Id, 'Muddy', 'Waters', true);
        Opportunity opp = new Opportunity();
        opp.name = 'Long lost record';
        opp.accountId = a.Id;
        opp.closeDate = Date.today().addDays(14);
        opp.stageName = 'prospecting';
        insert opp;
    }

    @isTest
    static void testBruteForceAccountCreation() {
        List<Account> accts = new List<Account>();
        Account a = new Account(name='McTesterson LLC');
        insert a;
        Test.startTest();
        accts = [SELECT Id FROM Account];
        Test.stopTest();
        System.assert(accts.size() > 0, 'Was expecting to find at least one account.');
    }

    @isTest
    static void testUseTesFactoryToCreateAcountsWithContacts() {
        List<Account> accts;
        List<Contact> contacts;
        TestFactory.generateAccountWithContacts(5);
        Test.startTest();
        accts = [SELECT Id FROM Account];
        contacts = [SELECT Id FROM Contact];
        Test.stopTest();

        System.assert(accts.size() > 0, 'Was expecting to find at least one account');
        System.assertEquals(6, contacts.size(), 'Was expecting to find 5 contacts');
    }
}