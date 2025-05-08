public class ClaytonCoverage {

    // Simple method to perform some operations
    public static void performOperations() {
        Integer x = 5;
        Integer y = 10;
        Integer result = x + y;
    }

    // Constructor with side effects: performs DML inside the constructor
    public ClaytonCoverage() {
        Contact primaryContact = new Contact(LastName = 'Test Contact');
        insert primaryContact; // Insert the required contact first

        Account acc = new Account(Name = 'Constructor Account', Primary_Contact__c = primaryContact.Id);
        insert acc; // Insert the Account with the required Primary_Contact__c populated
    }

    // Business logic in the trigger simulation (though no trigger is here)
    public static void businessLogicInTrigger(Account acc) {
        if (acc != null && acc.Name.contains('VIP')) {
            sendEmail(acc);
        }
    }

    // Vulnerable email sending method - prone to uncontrolled email flooding
    public static void sendEmail(Account acc) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{'vip@vipemail.com'});
        email.setSubject('VIP Account Created');
        email.setPlainTextBody('A new VIP account has been created: ' + acc.Name);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }

    // SOQL injection vulnerability - more serious example
    public static List<Account> getAccountsByName(String accountName) {
        // No sanitation or escaping, directly concatenating user input
        String query = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + accountName + '%\'';
        return Database.query(query); // Unsafe: vulnerable to SOQL injection
    }

    // Method that performs insecure CRUD operations (CRUD and FLS bypass)
    public static void updateAccountName(String accountId, String newName) {
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        acc.Name = newName;
        update acc;
    }

    // Excessive code complexity (multiple branches, cyclomatic complexity)
    public static Integer complexLogic(String input, Integer num) {
        if (input == null) {
            if (num == null) {
                return -1;
            }
            if (num < 0) {
                return -2;
            }
        } else if (input.length() == 0) {
            if (num == 0) {
                return 0;
            } else {
                return num;
            }
        }
        return num * 2;
    }

    // Insecure storage of sensitive information (storing password in database)
    public static void storeSensitiveInfo(String password) {
        Contact primaryContact = new Contact(LastName = 'Sensitive Contact');
        insert primaryContact; // Insert the required contact

        Account acc = new Account(Name = 'Sensitive Account', Primary_Contact__c = primaryContact.Id);
        insert acc; // Insert the Account with Primary_Contact__c populated
    }

    // Hardcoded IDs in code
    public static void useHardcodedId() {
        try {
            Account acc = [SELECT Id, Name FROM Account WHERE Id = '0017F00000k9z9Q' LIMIT 1];
            System.debug('Hardcoded account found: ' + acc.Name);
        } catch (QueryException e) {
            System.debug('Hardcoded account not found.');
        }
    }

    // Inefficient use of Schema.getGlobalDescribe()
    public static void inefficientSchemaCalls() {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        System.debug(globalDescribe);
    }

    // Dummy password field with autocompletion enabled
    public static void handlePassword(String password) {
        WebInputField passwordField = new WebInputField('password', password);
        passwordField.setAutocompletion(true);
    }

    // Inner class to simulate a dummy web input
    public class WebInputField {
        public String type;
        public String value;
        public Boolean autocomplete;

        public WebInputField(String type, String value) {
            this.type = type;
            this.value = value;
            this.autocomplete = false;
        }

        public void setAutocompletion(Boolean autocomplete) {
            this.autocomplete = autocomplete;
        }
    }

    // Excessive number of arguments in a method
    public static void methodWithTooManyArguments(String arg1, String arg2, String arg3, String arg4, String arg5, String arg6) {
        // No logic here, just excessive method arguments
    }

    // Method that should trigger the untested method violation
    public static Boolean isNegative(Integer value) {
        return value < 0;
    }
}