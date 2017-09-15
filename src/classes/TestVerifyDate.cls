@isTest
private class TestVerifyDate {

    
    @isTest
    private static void TestDateWithin30Days(){
		Date d1 = Date.newInstance(2017, 1, 1);
		Date d2 = Date.newInstance(2017, 1, 14);

        system.assertEquals(d2, VerifyDate.CheckDates(d1, d2),'The second date should be returned');
    }

    @isTest
    private static void TestDateOutside30Days(){
		Date d1 = Date.newInstance(2017, 1, 1);
		Date d2 = Date.newInstance(2017, 2, 14);
        Date d3 = Date.newInstance(2017, 1, 31);

        system.assertEquals(d3, VerifyDate.CheckDates(d1, d2),'The end of the month for the first date should be returned');
    }

}