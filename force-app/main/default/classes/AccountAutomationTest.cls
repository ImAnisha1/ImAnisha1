@isTest
private class AccountAutomationTest {

    /**
     * Sets up common test data used across test methods to optimize performance.
     */
    @testSetup
    static void setupTestData() {
        List<Account> testAccounts = new List<Account>();
        
        // 1. Account for "Hot" rating testing
        testAccounts.add(new Account(Name = 'Hot Tier Test', AnnualRevenue = 600000));
        
        // 2. Account for "Warm" rating testing
        testAccounts.add(new Account(Name = 'Warm Tier Test', AnnualRevenue = 250000));
        
        // 3. Account with existing description to ensure it isn't overwritten
        testAccounts.add(new Account(Name = 'Manual Desc Test', AnnualRevenue = 50000, Description = 'Keep Me'));

        insert testAccounts;
    }

    @isTest
    static void testAutomationLogic() {
        // Retrieve records created in test setup
        List<Account> recordsToProcess = [SELECT Id, Name, Description, AnnualRevenue, Rating FROM Account];
        
        // Execute the automation logic
        Test.startTest();
        AccountAutomation.populateDefaultFields(recordsToProcess);
        Test.stopTest();
        
        // Validate results using assertions
        for (Account acc : recordsToProcess) {
            if (acc.Name == 'Hot Tier Test') {
                System.assertEquals('Hot', acc.Rating, 'Accounts making >= 500k should be classified as Hot.');
                System.assertEquals('This account was automatically updated by AccountAutomation.', acc.Description);
            } else if (acc.Name == 'Warm Tier Test') {
                System.assertEquals('Warm', acc.Rating, 'Accounts making between 100k and 500k should be Warm.');
            } else if (acc.Name == 'Manual Desc Test') {
                System.assertEquals('Cold', acc.Rating, 'Accounts making < 100k should be Cold.');
                System.assertEquals('Keep Me', acc.Description, 'An existing description should not be overwritten.');
            }
        }
    }

    @isTest
    static void testBulkProcessing() {
        // Ensure the class scales effectively without running into governor limits
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            bulkAccounts.add(new Account(
                Name = 'Bulk Test ' + i,
                AnnualRevenue = 750000
            ));
        }
        
        Test.startTest();
        AccountAutomation.populateDefaultFields(bulkAccounts);
        Test.stopTest();
        
        // Assert a sample record from the bulk list to ensure processing succeeded
        System.assertEquals('Hot', bulkAccounts[0].Rating);
        System.assertEquals('This account was automatically updated by AccountAutomation.', bulkAccounts[199].Description);
    }
}