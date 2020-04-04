@IsTest
public with sharing class AddPrimaryContactTest {
    @TestSetup static void testSetup() {
        Account baseAccount = new Account(Name = 'Test Account');
        List<String> states = new List<String> {'NY', 'CA'};

        List<Account> accountsToInsert = new List<Account>();
        for (String state : states) {
            for (Integer i = 0; i < 50; i++) {
                Account account = new Account (Name = 'Test Account - ' + state + ' - ' + i, BillingState = state);
                accountsToInsert.add(account);
            }
        }

        insert accountsToInsert;
    }

    @IsTest static void test() {
        Contact baseContact = new Contact(LastName = 'Last');
        insert baseContact;

        AddPrimaryContact addPrimaryContactJob = new AddPrimaryContact(baseContact, 'CA');
        Test.startTest();
        System.enqueueJob(addPrimaryContactJob);
        Test.stopTest();

        List<Account> accounts = [SELECT Id, Name, BillingState FROM Account];

        System.assertEquals(100, accounts.size(), 'Expected there to be 100 total accounts');

        Integer caCount = 0;
        Integer caContactCount = 0;
        Integer nyCount = 0;
        Integer nyContactCount = 0;

        for (Account account : accounts) {
            if (account.BillingState == 'NY') {
                nyCount++;
                nyContactCount += account.Contacts.size();
            }

            if (account.BillingState == 'CA') {
                caCount++;
                caContactCount += account.Contacts.size();
            }
        }

        System.assertEquals(50, caCount);
        System.assertEquals(50, nyCount);
        System.assertEquals(0, nyContactCount);
    }
}