public class AccountQuoteID {
    public static void transformAccounts(List<Account> accounts) {
        for (Account acc : accounts) {
            // Check if the Active__c field is set to "Yes"
            if (acc.Active__c != 'Yes') {
                continue; // Skip this account and move to the next one
            }

            String accountName = acc.Name;
            String accountNamePrefix = accountName.substring(0, 3);

            // Initialize the new Subscription Number and SLA Expiration Date
            String newSubscriptionNumber = null;
            String newSLAExpirationDate = null;

            // Proceed with the transformation of the subscription number
            String subscriptionNumber = acc.Subscription_number__c;
            String prefixToRemove = 'GEA-';

            if (subscriptionNumber != null && subscriptionNumber.startsWith(prefixToRemove)) {
                // Remove the "GEA-" prefix
                subscriptionNumber = subscriptionNumber.substring(prefixToRemove.length());

                // Combine the Account Name prefix with the remaining subscription number
                newSubscriptionNumber = accountNamePrefix + subscriptionNumber;

                // Ensure the length does not exceed 10
                if (newSubscriptionNumber.length() > 10) {
                    // Trim to 10 characters and add "!"
                    newSubscriptionNumber = newSubscriptionNumber.substring(0, 10) + '!';
                }

                // Check if "USA" is present in any part of the BillingAddress
                Boolean containsUSA = false;

                if (acc.BillingAddress != null) {
                    String billingAddressLower = acc.BillingStreet.toLowerCase();
                    String billingCityLower = acc.BillingCity.toLowerCase();
                    String billingStateLower = acc.BillingState.toLowerCase();
                    String billingPostalCodeLower = acc.BillingPostalCode.toLowerCase();
                    String billingCountryLower = acc.BillingCountry.toLowerCase();

                    if (billingAddressLower.contains('usa') ||
                        billingCityLower.contains('usa') ||
                        billingStateLower.contains('usa') ||
                        billingPostalCodeLower.contains('usa') ||
                        billingCountryLower.contains('usa')) {
                        containsUSA = true;
                    }
                }

                // Derive SLA Expiration Date and reformat it
                Date slaDate = acc.SLAExpirationDate__c;
                Date formattedSLADate = null;

                if (slaDate != null) {
                    if (containsUSA) {
                        // SLAExpirationDate__c should be in the format "MMMM DD YYYY" if "USA" is detected
                        String formattedDate = slaDate.month() + ' ' + slaDate.day().format() + ' ' + slaDate.year();
                        formattedSLADate = Date.valueOf(formattedDate);
                    } else {
                        // SLAExpirationDate__c should be in the format "MMM dd YYYY" if "USA" is not detected
                        formattedSLADate = slaDate;
                    }
                }

                // Update the Account Subscription_number_for_Invoice__c and SLAExpirationDate__c fields
                acc.Subscription_number_for_Invoice__c = newSubscriptionNumber;
                acc.SLAExpirationDate__c = formattedSLADate;
            }
        }
    }
}