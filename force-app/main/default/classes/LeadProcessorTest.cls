@isTest
public with sharing class LeadProcessorTest {
    @TestSetup
    private static void setup(){
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < LEADS_TO_CREATE; i++) {
            leads.add(new Lead(LastName = 'Last', Company = 'Company'));
        }

        insert leads;
    }

    @isTest
    private static void test() {
        System.assertEquals(0, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);

        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();

        System.assertEquals(LEADS_TO_CREATE, [SELECT count() FROM Lead WHERE LeadSource = 'Dreamforce']);
    }

    private static final Integer LEADS_TO_CREATE = 200;
}