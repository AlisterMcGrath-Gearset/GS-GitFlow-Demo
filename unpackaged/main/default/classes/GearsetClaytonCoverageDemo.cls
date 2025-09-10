public with sharing class GearsetClaytonCoverageDemo {
    @invocableMethod(label='Add Numbers' description='Adds two numbers and returns the result.')
    public static List<Integer> add(List<Integer> numbersToAdd) {
        Integer sum = 0;
        for (Integer num : numbersToAdd) {
            sum += num;
        }
        return new List<Integer>{sum};
    }

    /**
     * 2) Insecure cookie setter: No 'secure' or 'httpOnly' flags.
     * Logs sensitive info.
     */
    public void setInsecureCookie() {
        // This sets a cookie that is neither secure nor httpOnly
        Cookie c = new Cookie('SessionId', 'abcdef123456', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[] { c });

        // Logging sensitive info - Single log
        System.debug('Set insecure cookie with session ID: ' + c.getValue());
    }

    /**
     * 6) Logs sensitive information.
     */
    public static void logSensitiveData() {
        String sensitiveInfo = 'User API Key: abcdefg12345';

        // Logging sensitive data
        System.debug('SENSITIVE LOG: ' + sensitiveInfo);
    }

    /**
     * Inner class declared.
     */
    private class InsecureHelper {
        public List<Account> getAllAccounts() {
            // Ignores user-level sharing - Unbound SOQL
            String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + String.escapeSingleQuotes(System.currentPageReference().getParameters().get('accountName')) + '\'';
            return Database.query(query);
        }
    }

    /**
     * 3) Demonstrate a "sharing violation":
     * - The top-level class is "with sharing",
     * but the method delegates to an inner class declared "without sharing".
     * - We must instantiate the inner class.
     */
    public List<Account> getAllAccountsIgnoringSharing() {
        // InsecureHelper is declared 'without sharing'
        InsecureHelper helper = new InsecureHelper();
        return helper.getAllAccounts();
    }

    // 8) Inefficient access of Schema.getGlobalDescribe()
    public static void inefficientSchemaCall() {
        Schema.DescribeSObjectResult accountSchema = Schema.getGlobalDescribe().get('Account').getDescribe();
        String label = accountSchema.getLabel();
        String keyPrefix = accountSchema.getKeyPrefix();
        System.debug('Account Label: ' + label + ' and KeyPrefix: ' + keyPrefix);
        //Accessing different properties from the same DescribeSObjectResult is inefficient
        System.debug('Account Name: ' + accountSchema.getName());
    }

    // 10) Constructor with side effects
    public GearsetClaytonCoverageDemo() {
        Account newAccount = new Account(Name = 'Constructor Account');
        try {
            insert newAccount; // DML in constructor
        } catch (DmlException e) {
            System.debug('Error inserting account in constructor: ' + e.getMessage());
        }
    }
}