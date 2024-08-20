@isTest
public class PassingTests {

    @isTest static void test1() {
    }
    
    @isTest static void test2() {
        System.assertEquals(2, 2);
        System.assertEquals(19, 19);
    }
}