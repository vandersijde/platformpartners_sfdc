public class AccountsController {
  @AuraEnabled
  public static List<Account> getAccounts() {
    return [SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone
    FROM Account ORDER BY createdDate ASC];
  }
  
  public static void doSomething(){
  	system.debug('### hello world ###');
  	system.debug('@@@ another debug @@@');
  	system.debug('### GIT ###');
  }
}