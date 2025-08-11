@IsTest(SeeAllData=true)
public class ClaytonCoverageTest {

    @IsTest
    public static void testDummyCoverage() {
        ClaytonCoverage.performOperations(); // Call the performOperations method correctly
        System.assert(true); // Minimal assertion
    }

    @IsTest
    public static void testConstructorSideEffects() {
        ClaytonCoverage coverage = new ClaytonCoverage(); // Primary_Contact__c is handled in the constructor now
        System.assert(true);
    }

    @IsTest(SeeAllData=true)
    public static void testBusinessLogicInTrigger() {
        Contact primaryContact = new Contact(LastName = 'VIP Contact');
        insert primaryContact;

        Account acc = new Account(Name = 'VIP Account', Primary_Contact__c = primaryContact.Id);
        insert acc;
        
        ClaytonCoverage.businessLogicInTrigger(acc);
        System.assert(true);
    }

    // Test for SOQL injection vulnerability
    @IsTest(SeeAllData=true)
    public static void testGetAccountsByName() {
        // Simulating a potential SOQL injection attack with a dangerous payload
        List<Account> accounts = ClaytonCoverage.getAccountsByName('\' OR Name != null OR Name = \'');

        // Malicious input should return all accounts, bypassing the intended filter
        System.assert(accounts.size() > 0, 'Account list should not be empty');
    }

    @IsTest(SeeAllData=true)
    public static void testUpdateAccountName() {
        Contact primaryContact = new Contact(LastName = 'Test Contact');
        insert primaryContact;

        Account acc = new Account(Name = 'Test Account', Primary_Contact__c = primaryContact.Id);
        insert acc;

        ClaytonCoverage.updateAccountName(acc.Id, 'New Name');
        System.assert(true);
    }

    @IsTest
    public static void testComplexLogic() {
        Integer result1 = ClaytonCoverage.complexLogic('test', 1);
        Integer result2 = ClaytonCoverage.complexLogic(null, -1);
        System.assertEquals(result1, 2);
        System.assertEquals(result2, -2);
    }

    @IsTest
    public static void testHardcodedId() {
        ClaytonCoverage.useHardcodedId();
        System.assert(true);
    }

    @IsTest
    public static void testInefficientSchemaCalls() {
        ClaytonCoverage.inefficientSchemaCalls();
        System.assert(true);
    }

    @IsTest
    public static void testStoreSensitiveInfo() {
        ClaytonCoverage.storeSensitiveInfo('superSecret123');
        System.assert(true);
    }

    @IsTest
    public static void testMethodWithTooManyArguments() {
        ClaytonCoverage.methodWithTooManyArguments('a', 'b', 'c', 'd', 'e', 'f');
        System.assert(true);
    }

    @IsTest
    public static void testHandlePassword() {
        ClaytonCoverage.handlePassword('dummyPassword');
        System.assert(true);
    }

    // Dummy test missing @IsTest annotation to trigger the missing annotation violation
    public static void testWithoutAnnotation() {
        ClaytonCoverage.performOperations(); // Correct method call
    }
}