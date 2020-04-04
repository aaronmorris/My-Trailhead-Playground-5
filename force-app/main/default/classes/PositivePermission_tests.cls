@IsTest
public class PositivePermission_tests {
    @TestSetup
    static void testSetup(){
        Account a = TestFactory.getAccount('No view for you!', true);
        Private_Object__c po = new Private_Object__c(account__c = a.Id, notes__c = 'foo');
        insert po;
    }

    @IsTest static void permissionsSetTestNegative() {
        User u = TestFactory.generateUser('Custom User');
        System.runAs(u) {
            Private_Object__c[] pos;
            Test.startTest();
            pos = [SELECT Id, Account__c, notes__c FROM Private_Object__c];
            Test.stopTest();
            System.assertEquals(1, pos.size(), 'User should have been able to see object');
        }
    }
}