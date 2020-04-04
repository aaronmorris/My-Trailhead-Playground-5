@IsTest
private class ExternalSearch_Tests {
    @IsTest static void testMethodOne() {
        HTTPMockFactory mock = new HTTPMockFactory(200, 'OK', 'I found it!', new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        String result;
        Test.startTest();
        result = ExternalSearch.googleIt('epic search');
        Test.stopTest();

        System.assertEquals('I found it!', result, 'Expected to get the same result from the mock');
    }

    @IsTest static void testMethod500() {
        HTTPMockFactory mock = new HTTPMockFactory(500, 'Server Error', 'There was a server error', new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        String result;
        Boolean caughtException = false;
        Test.startTest();
        try{
            result = ExternalSearch.googleIt('epic search');
            System.assert(false, 'There should have been an exception thrown in the googleIt call.');
        }
        catch (Exception ex) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'Exception should have been caught');
    }
}