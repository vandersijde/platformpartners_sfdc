public class kilometerregistratie {

    public String van {get;set;}
    public String naar {get;set;}
    public Integer kms {get;set;}
    public Integer totalkms {get;set;}
    public Integer selectedrow {get;set;}
    
    public List<String> selectedDays {
        get{
            if(selectedDays == null){
                selectedDays = new List<String>();                
            }
            return selectedDays;
        }
        set;
    }

    public List<SelectOption> optionsDaysList{
        get{
            if(optionsDaysList == null){
                optionsDaysList = new List<SelectOption>();
                optionsDaysList.add(new SelectOption('MON','Maandag'));
                optionsDaysList.add(new SelectOption('TUE','Dinsdag'));
                optionsDaysList.add(new SelectOption('WED','Woensdag'));
                optionsDaysList.add(new SelectOption('THU','Donderdag'));
                optionsDaysList.add(new SelectOption('FRI','Vrijdag'));
                optionsDaysList.add(new SelectOption('SAT','Zaterdag'));
                optionsDaysList.add(new SelectOption('SUN','Zondag'));
            }
            return optionsDaysList;
        }
        private set;
    }
    
    public String periode {
        get{
            if(periode == null){
                if(startevent.ActivityDate != null){
                    Integer month = startevent.ActivityDate.month();
                    Integer year = startevent.ActivityDate.year();
                    if(month == 1) periode = 'Januari ' + year;
                    if(month == 2) periode = 'Februari ' + year;
                    if(month == 3) periode = 'Maart ' + year;
                    if(month == 4) periode = 'April ' + year;
                    if(month == 5) periode = 'Mei ' + year;
                    if(month == 6) periode = 'Juni ' + year;
                    if(month == 7) periode = 'Juli ' + year;
                    if(month == 8) periode = 'Augustus ' + year;
                    if(month == 9) periode = 'September ' + year;
                    if(month == 10) periode = 'Oktober ' + year;
                    if(month == 11) periode = 'November ' + year;
                    if(month == 12) periode = 'December ' + year;
                }else{
                    periode = '';
                }
            }
            return periode;
        }
        set;
    }
    
    public Event startevent {
        get{
            if(startevent == null) startevent = new Event();
            return startevent;    
        }
        set;
    }

    public Event endevent {
        get{
            if(endevent == null) endevent = new Event();
            return endevent;    
        }
        set;
    }

    public list<kmrecord> kmrecordList{
        get{
            if(kmrecordList == null) kmrecordList = new List<kmrecord>();
            return kmrecordlist;
        }
        set;
    }
    
    public class kmrecord{
        public Integer row {get;set;}
        public String datum {get;set;}
        public String van {get;set;}
        public String naar {get;set;}
        public Double km {get;set;}
    }
    
    public PageReference GenerateKmList(){
        kmrecordList.clear();
        Date whiledatum = startevent.ActivityDate;
        totalkms = 0;
        Integer row = 0;

        while(whiledatum <= endevent.ActivityDate){
            DateTime dt = DateTime.newInstance(whiledatum.year(), whiledatum.month(), whiledatum.day());
			Set<String> daysSet = new Set<String>();
            daysSet.addAll(selectedDays);
            String dayOfWeek = dt.format('E').toUpperCase();
            
            if(daysSet.contains(dayOfWeek)){ //dayOfWeek != 'SAT' && dayOfWeek != 'SUN'
                kmrecord rec_heen = new kmrecord();
                rec_heen.row = row;
                rec_heen.datum = dt.format('dd-MM-yyyy');
                rec_heen.van = van;
                rec_heen.naar = naar;
                rec_heen.km = kms;
                kmrecordList.add(rec_heen);
                totalkms += kms;
                row++;
                
                kmrecord rec_terug = new kmrecord();
                rec_terug.row = row;
                rec_terug.datum = dt.format('dd-MM-yyyy');
                rec_terug.van = naar;
                rec_terug.naar = van;
                rec_terug.km = kms;
                kmrecordList.add(rec_terug);
                totalkms += kms;
                row++;
            }
            whiledatum = whiledatum.addDays(1);
        }

        kmrecord rec_totalkm = new kmrecord();
        rec_totalkm.naar = 'Totaal kms';
        rec_totalkm.km = totalkms;
        kmrecordList.add(rec_totalkm);

        kmrecord rec_totalamount = new kmrecord();
        rec_totalamount.naar = 'Totaal bedrag';
        rec_totalamount.km = totalkms * 0.19;
        kmrecordList.add(rec_totalamount);

        return null;
    }
    
    public PageReference ExportToExcel(){
        return Page.km_excel;
    }

    public PageReference DeleteRow(){
        if(selectedrow != null){
            kmrecordList.remove(selectedrow);
        }

        Boolean gapFound = false;
        Integer previousNum = -1;
        Double totalkms = 0;
        
        for(kmrecord rec:kmrecordList){
            //Search for gap    
            if(!gapFound){
                gapFound = (rec.row - previousNum > 1);
                previousNum = rec.row;
            }
        
            //if gap is found, then decrease row numbers
            if(gapFound){
                if(rec.row != null) rec.row--;
            }
        
            //calculate total km's
            if(rec.datum != null && rec.km != null){
                totalkms += rec.km;
            }
        
            if(!kmrecordList.isEmpty() && kmrecordList.size() > 0){
                kmrecordList.get(kmrecordList.size()-2).km = totalkms;    
                kmrecordList.get(kmrecordList.size()-1).km = totalkms * 0.19;    
            }
        }
        
        return null;
    }
}