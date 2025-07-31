public class CaseClosureScheduler {
    
    // Method to close cases that have not been modified in the last 180 days
    public static void closeOldCases() {
        // Calculate the date 180 days ago from today
        Date thresholdDate = Date.today().addDays(-180);
        
        // Query for cases that haven't been modified in the last 180 days and are not already closed
        List<Case> casesToClose = [
            SELECT Id, Status, LastModifiedDate 
            FROM Case 
            WHERE LastModifiedDate <= :thresholdDate 
            AND Status != 'Closed'
        ];
        
        // If there are cases to close, proceed to update them
        if (!casesToClose.isEmpty()) {
            for (Case c : casesToClose) {
                c.Status = 'Closed';
            }
            
            try {
                // Update the cases in the database
                update casesToClose;
                System.debug('Closed ' + casesToClose.size() + ' cases that were not modified in the last 180 days.');
            } catch (DmlException e) {
                System.debug('Failed to update cases: ' + e.getMessage());
            }
        } else {
            System.debug('No cases found that require closure.');
        }
    }
}