public class AccountHandler {
    public static Account insertNewAccount(String account_name){
 		Account acct = new Account(Name=account_name);
        try {
        	insert acct;
        } catch (DmlException e ){
            return null;
        }
        return acct;     
    }
}