@isTest
public class AccountUpdateUtilityTest {
    @isTest
    static void testUpdateAccountIndustry() {
        // Step 1: Create test data
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i, Industry = 'Energy'));
        }
        insert testAccounts;

        // Collect IDs
        List<Id> testAccountIds = new List<Id>();
        for (Account acc : testAccounts) {
            testAccountIds.add(acc.Id);
        }

        // Step 2: Call the method to test
        Test.startTest();
        AccountUpdateUtility.updateAccountIndustry(testAccountIds, 'Technology');
        Test.stopTest();

        // Step 3: Verify results
        List<Account> updatedAccounts = [SELECT Id, Industry FROM Account WHERE Id IN :testAccountIds];
        for (Account acc : updatedAccounts) {
            System.assertEquals('Technology', acc.Industry, 'The industry should be updated to Technology');
        }
    }
}