@isTest
private class Calculator_Test {
  @testSetup
  static void loadData() {

  }

  @isTest static void testAdd() {
      Test.startTest();
      Integer sum = Calculator.addition(1, 2);
      Test.stopTest();

      System.assertEquals(3, sum, 'Expected sum to be 3');
  }

  @isTest static void testSubtraction() {
      Test.startTest();
      Integer difference = Calculator.subtraction(3, 2);
      Test.stopTest();

      System.assertEquals(1, difference, 'Expected Difference to be 1');
  }

  @isTest static void testMultiplication() {
      Test.startTest();
      Integer product = Calculator.multiply(2, 3);
      Test.stopTest();

      System.assertEquals(6, product, 'Expected product to be 6');
  }

  @isTest static void testMultiplyNegative() {
      Boolean exceptionThrown = false;
      Test.startTest();
      try {
          Integer product = Calculator.multiply(0, 3);
      }
      catch (Calculator.CalculatorException ce) {
          exceptionThrown = true;
      }

      System.assert(exceptionThrown, 'Exception should have been thrown');
  }

  @isTest static void testDivision() {
      Test.startTest();
      Decimal quotient = Calculator.divide(10, 2);
      Test.stopTest();

      System.assertEquals(5, quotient, 'Expected quotient to be 5');
  }

  @istest static void testDivisionNegativeZeroDenominator() {
      Boolean exceptionThrown = false;
      Test.startTest();
      try {
          Decimal quotient = Calculator.divide(10, 0);
      }
      catch (Calculator.CalculatorException ce) {
          exceptionThrown = true;
      }
      Test.stopTest();

      System.assert(exceptionThrown, 'Exception should have been thrown');
  }

    @isTest static void testDivisionNegativeNegativeResult() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            Decimal quotient = Calculator.divide(-10, 2);
        }
        catch (Calculator.CalculatorException ce) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'Exception should have been thrown');
    }

}