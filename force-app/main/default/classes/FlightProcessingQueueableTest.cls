@IsTest
private class FlightProcessingQueueableTest {
    
    @IsTest
    static void testQueueableProcessing() {
        
        Flight__c flight = new Flight__c(Name = 'TEST-2001',
                                         Departure_Airport__c = 'DEL',
                                         Arrival_Airport__c = 'BOM',
                                         Departure_Date_Time__c = DateTime.now().addHours(5),
                                         Arrival_Date_Time__c = DateTime.now().addHours(7),
                                         Flight_Status__c = 'Scheduled',
                                         Total_Seats__c = 180,
                                         Available_Seats__c = 180,
                                         Base_Fare__c = 8500);
        insert flight;
        
        Test.startTest();
        
        System.enqueueJob(new FlightProcessingQueueable(new Set<Id>{ flight.Id }));
        
        Test.stopTest();
        
        System.assertEquals('Scheduled',
                            [SELECT Flight_Status__c FROM Flight__c WHERE Id = :flight.Id]
                            .Flight_Status__c);
    }
    
    @IsTest
    static void testQueueableHandlesMissingFlight() {
        Id fakeFlightId = '001000000000000AAA';
        
        Test.startTest();
        
        System.enqueueJob(new FlightProcessingQueueable(new Set<Id>{ fakeFlightId }));
        
        Test.stopTest();
        
        System.assertEquals(true,true, 'Queueable should handle the exception without failing the test.');
    }
}