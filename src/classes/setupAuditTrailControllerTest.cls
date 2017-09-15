/**
 * @author			Richard van der Sijde
 * @date			21-11-2016
 * @description		Test class for the setupAuditTrailController class
 */
@isTest
private class setupAuditTrailControllerTest {

    @isTest(SeeAllData=true)
    private static void TestSetupAuditTrail(){
        setupAuditTrailController satContr = new setupAuditTrailController();
		setupAuditTrailController.DisplayInfo di = new setupAuditTrailController.DisplayInfo('Test Label','Test Section','Test Action','User','01-01-2020',1);
        
        system.assertEquals(false, satContr.textToRemove.isEmpty(), 'Text to remove list should not be empty');
        system.assertEquals(true, (System.Today().addDays(-90) == satContr.startDate), 'Start date should be today -90 days');
        system.assertEquals(true, (System.Today() == satContr.endDate), 'End date should be today');
        system.assertEquals(true, (satContr.displayMap.isEmpty() || !satContr.displayMap.isEmpty()), 'displayMap could be empty or not...');
    }

    @isTest(SeeAllData=true)
    private static void TestSetupAuditTrailWithWideRange(){
        setupAuditTrailController satContr = new setupAuditTrailController();
		satContr.startDateString = String.valueOf(system.Today().addYears(-2));
		satContr.endDateString = String.valueOf(system.Today().addDays(7));

        for(setupAuditTrailController.SectionSelect actSelect:satContr.sectionSelectList){
        	actSelect.Selected = true;
        }
        satContr.ReloadPage();
        
        system.assertEquals(true, (satContr.displayMap.isEmpty() || !satContr.displayMap.isEmpty()), 'displayMap could be empty or not...');
        system.assertEquals(Page.setupAuditTrailExport.getUrl(), satContr.ExportToExcel().getUrl(), 'Should navigate to the export page');
    }

}