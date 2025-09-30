public class OpportunityDiscountCalculator {
    public enum ExceptionType {
        NULL_POINTER,
        QUERY_EXCEPTION,
        LIST_EXCEPTION
    }
    
    public class EnumWrapper {
        @InvocableVariable
        public String enumValue;
    }
    
    public static ExceptionType getExceptionType(String input) {
        return String.isBlank(input) ? null : ExceptionType.valueOf(input);
    }

    @InvocableMethod
    public static void throwException(List<EnumWrapper> inputList) {
        ExceptionType exceptionType;
        
        try {
            exceptionType = getExceptionType(inputList.get(0).enumValue);
        } catch (Exception e) {
            nullReference();
        }
      
        switch on exceptionType {
            when NULL_POINTER {
                nullReference();
            }
            when QUERY_EXCEPTION {
                queryException();
            }
            when LIST_EXCEPTION {
                listException();
            }
            when else {
                nullReference();
            }
        }
    }
    
    private static void nullReference() {
        String s;
        Boolean b = s.contains('Apex'); 
    }
    
    private static void queryException() {
        Account a = [SELECT Name FROM Account WHERE Name = 'XYZ' LIMIT 1];
    }
    
    private static void listException() {
        List<String> myList = new List<String>();
        String invalidElement = myList.get(100);
    }
}