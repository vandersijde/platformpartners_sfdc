@isTest
private class KilometerregistratieTest {

    @isTest
    private static void CheckOptionLists(){
        Kilometerregistratie kr = new Kilometerregistratie();
        system.assertEquals(7, kr.optionsDaysList.size(), 'There should be 7 days in the list');
        system.assertEquals('', kr.periode, 'Period should be empty');
    }
    
    @isTest
    private static void GenerateAndExport(){
        Kilometerregistratie kr = new Kilometerregistratie();
        kr.van = 'Hier';
        kr.naar = 'Daar';
        kr.startevent.ActivityDate = Date.newInstance(2015, 10, 6);
        kr.endevent.ActivityDate = Date.newInstance(2015, 10, 8);
        kr.selectedDays.add('MON');
        kr.selectedDays.add('TUE');
        kr.selectedDays.add('WED');
        kr.kms = 10;
        kr.GenerateKmList();
        kr.ExportToExcel();
        
        system.assertEquals(6, kr.kmrecordList.size(), 'There should be 6 records in the km list');
        system.assertEquals('Oktober 2015', kr.periode, 'Period should be set to Oktober');
    }

    @isTest
    private static void DeleteRow(){
        Kilometerregistratie kr = new Kilometerregistratie();
        kr.van = 'Hier';
        kr.naar = 'Daar';
        kr.startevent.ActivityDate = Date.newInstance(2015, 10, 6);
        kr.endevent.ActivityDate = Date.newInstance(2015, 10, 8);
        kr.selectedDays.add('MON');
        kr.selectedDays.add('TUE');
        kr.selectedDays.add('WED');
        kr.kms = 10;
        kr.GenerateKmList();
        kr.selectedrow = 0;
        kr.DeleteRow();
        
        system.assertEquals(5, kr.kmrecordList.size(), 'There should be 5 records in the km list');
    }
}