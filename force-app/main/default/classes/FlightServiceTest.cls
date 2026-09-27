@IsTest
private class FlightServiceTest {
    
    @IsTest
    static void testOperationalChangesDetected() {
        
        Flight__c oldFlight = new Flight__c(Name = 'TEST-1001',
                                            Departure_Airport__c = 'DEL',
                                            Arrival_Airport__c = 'BOM',
                                            Departure_Date_Time__c = DateTime.now().addHours(5),
                                            Arrival_Date_Time__c = DateTime.now().addHours(7),
                                            Flight_Status__c = 'Scheduled',
                                            Total_Seats__c = 180,
                                            Available_Seats__c = 180,
                                            Base_Fare__c = 8500);
        
        Flight__c newFlight = oldFlight.clone(false, true, false, false);
        newFlight.Flight_Status__c = 'Delayed';
        Test.startTest();
        Boolean result = FlightService.hasOperationalChanges(newFlight, oldFlight);
        
        Test.stopTest();
        
        System.assertEquals(
            true,
            result,
            'Operational flight change should be detected.');
    }
}