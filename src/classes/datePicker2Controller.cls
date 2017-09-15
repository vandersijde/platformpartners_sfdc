public class datePicker2Controller {

    public String theDate {get;set;}
    
    public PageReference LogDate(){
        system.debug('### date: ' + theDate);
        return null;
    }
}