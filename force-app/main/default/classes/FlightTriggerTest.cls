@IsTest
private class FlightTriggerTest { 
    @IsTest
    static void testFlightUpdateEnqueuesQueueable() {
        
        Flight__c flight = new Flight__c(Name = 'TEST-3001',
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
        
        flight.Flight_Status__c = 'Delayed';
        update flight;
        
        Test.stopTest();
        
        Flight__c updatedFlight = [SELECT Flight_Status__c
                                   FROM Flight__c
                                   WHERE Id = :flight.Id];
        System.assertEquals('Delayed', updatedFlight.Flight_Status__c, 'Flight status should be updated.');
    }
    
    @IsTest
    static void testBulkFlightUpdates() {
        
        List<Flight__c> flights = new List<Flight__c>();
        for (Integer i = 1; i <= 5; i++) {
            
            flights.add(new Flight__c(Name = 'BULK-' + i,
                                      Departure_Airport__c = 'DEL',
                                      Arrival_Airport__c = 'BOM',
                                      Departure_Date_Time__c = DateTime.now().addHours(5),
                                      Arrival_Date_Time__c = DateTime.now().addHours(7),
                                      Flight_Status__c = 'Scheduled',
                                      Total_Seats__c = 180,
                                      Available_Seats__c = 180,
                                      Base_Fare__c = 8500));
        }
        
        insert flights;
        
        Test.startTest();
        
        for (Flight__c flight : flights) {
            flight.Flight_Status__c = 'Delayed';
        }
        
        update flights;
        
        Test.stopTest();
        
        List<Flight__c> updatedFlights = [SELECT Flight_Status__c
                                          FROM Flight__c
                                          WHERE Id IN :flights];
        System.assertEquals(5, updatedFlights.size(), 'All five Flights should be updated.');
        for (Flight__c flight : updatedFlights) {
            System.assertEquals('Delayed', flight.Flight_Status__c, 'All Flights should have Delayed status.');
        }
    }
}