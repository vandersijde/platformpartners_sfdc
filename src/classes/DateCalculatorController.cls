public class DateCalculatorController {

    public String inputDate {get;set;}
    public Integer inputDays {get;set;}
    public String outputDate {get;set;}

    public String selectedOperator{
        get{
            if(selectedOperator == null) selectedOperator = 'plus';
            return selectedOperator;
        }
        set;
    }
    
    public List<SelectOption> operatorList{
        get{
            if(operatorList == null){
                operatorList = new List<SelectOption>();
                operatorList.add(new SelectOption('minus','minus'));
                operatorList.add(new SelectOption('plus','plus'));
            }
            return operatorList;
        }
        set;
    }
    
    public List<String> dateList {
        get{
            if(dateList == null) dateList = new List<String>();
            return dateList;
        }
        set;
    }
    
    public PageReference AddToList(){
		Set<String> dateSet = new Set<String>();
        dateSet.addAll(dateList);
        if(!dateSet.contains(outputDate)){
	        dateList.add(outputDate);
        }
        return null;
    }

    public PageReference Calculate(){
		Date newDate = Date.parse(inputDate);
        if(selectedOperator == 'plus')
	        outputDate = newDate.addDays(inputDays).format();
        else 
	        outputDate = newDate.addDays(inputDays * -1).format();
        return null;
    }
}