/**
 * An apex page controller that exposes the change password functionality
 * Some additional notes I've made to this Apex class
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}
/**
*btw, here's an imprtant note which should be pushed up through the environments 
*/        
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
    public ChangePasswordController() {}
}