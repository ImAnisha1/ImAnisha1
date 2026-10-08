public class AccountUpdateUtility {
    public static void updateAccountIndustry(List<Id> accountIds, String newIndustry) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        
        List<Account> accountsToUpdate = [SELECT Id, Industry FROM Account WHERE Id IN :accountIds];
        for (Account acc : accountsToUpdate) {
            acc.Industry = newIndustry;
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}