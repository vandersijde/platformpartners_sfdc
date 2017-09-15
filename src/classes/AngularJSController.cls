global with sharing class AngularJSController {

    @RemoteAction
    global static List<AccountObj> GetAccountList(){
        List<AccountObj> accObjList = new List<AccountObj>();
        List<Account> accList = [SELECT Id, Name, (SELECT Id FROM Invoice_Account_Orders__r) FROM Account ORDER BY Name asc LIMIT 100];
        for(Account acc:accList){
            if(acc.Invoice_Account_Orders__r.size() > 0) accObjList.add(new AccountObj(acc.Id, acc.Name, acc.Invoice_Account_Orders__r.size()));
        }
        return accObjList;
    }
    
    global class AccountObj{
		global String ObjId;
        global String Name;
        global Integer NumOfOrders;
        
        global AccountObj(String i, String n, Integer j){
			ObjId = i;
            Name = n;
            NumOfOrders = j;
        }
    }
}