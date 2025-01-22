@IsTest
public class ProductValidatorTests {
    @IsTest
    static void validateIsMultiProduct() {
        Boolean result = ProductValidator.isMultiProduct('MP:123-456-789');
        System.assertEquals(result, true);
    }
    
    @IsTest
    static void validateIsNotMultiProduct() {
        Boolean result = ProductValidator.isMultiProduct('JL:123-456-789');
        System.assertEquals(result, false);
    }
    
    @IsTest
    static void validateIsSingleProduct() {
        Boolean result = ProductValidator.isSingleProduct('SP:123-456-789');
        System.assertEquals(result, true);
    }
    
    @IsTest
    static void validateIsNotSingleProduct() {
        Boolean result = ProductValidator.isSingleProduct('JL:123-456-789');
        System.assertEquals(result, false);
    }
}