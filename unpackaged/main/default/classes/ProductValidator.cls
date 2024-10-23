public class ProductValidator {
    public static Boolean isMultiProduct(string productId) {
        return productId.startsWith('MP:');
    }
    
    public static Boolean isSingleProduct(string productId) {
        return productId.startsWith('SP:');
    }
}