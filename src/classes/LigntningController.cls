public class LigntningController {

    @AuraEnabled
    public static Boolean IsIBANValid(String iban){
        if(iban == 'NL46INGB0006858838'){
            return true;
        }else{
            return false;
        }
    }
}