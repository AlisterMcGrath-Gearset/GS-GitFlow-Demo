@isTest
public class PassingTests {

    @isTest static void test1() {
         System.assertEquals(17, 17);
    }
    
    @isTest static void test2() {
        System.assertEquals(19, 19);
    }
}