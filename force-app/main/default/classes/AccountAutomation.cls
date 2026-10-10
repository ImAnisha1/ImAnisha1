public with sharing class AccountAutomation {
    
    /**
     * Automates business logic for a list of Accounts.
     * Can be invoked from triggers, batch jobs, or controllers.
     */
    public static void populateDefaultFields(List<Account> accountList) {
        if (accountList == null || accountList.isEmpty()) {
            return;
        }

        for (Account acc : accountList) {
            // 1. Automatically populate missing descriptions
            if (String.isBlank(acc.Description)) {
                acc.Description = 'This account was automatically updated by AccountAutomation.';
            }
            
            // 2. Automate Rating classification based on Annual Revenue
            if (acc.AnnualRevenue >= 500000) {
                acc.Rating = 'Hot';
            } else if (acc.AnnualRevenue >= 100000) {
                acc.Rating = 'Warm';
            } else {
                acc.Rating = 'Cold';
            }
        }
    }
}