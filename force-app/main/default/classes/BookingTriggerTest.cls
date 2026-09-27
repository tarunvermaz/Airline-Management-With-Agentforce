@IsTest
private class BookingTriggerTest {
    @IsTest
    static void testBookingUpdateTrigger() {
        Contact passenger = new Contact(FirstName = 'Test', LastName = 'Passenger', Passenger_Type__c = 'Adult');
        insert passenger;
        
        Flight__c flight = new Flight__c(
            Name = 'TEST-4001',
            Departure_Airport__c = 'DEL',
            Arrival_Airport__c = 'BOM',
            Departure_Date_Time__c = DateTime.now().addHours(5),
            Arrival_Date_Time__c = DateTime.now().addHours(7),
            Flight_Status__c = 'Scheduled',
            Total_Seats__c = 180,
            Available_Seats__c = 180,
            Base_Fare__c = 8500);
        insert flight;
        
        Booking__c booking = new Booking__c(
            Contact__c = passenger.Id,
            Flight__c = flight.Id,
            Seat_Number__c = '12A',
            Fare_Amount__c = 8500,
            Payment_Status__c = 'Pending',
            Booking_Status__c = 'Pending',
            Ticket_Status__c = 'Not Issued',
            Booking_Date__c = DateTime.now());
        insert booking;
        
        Test.startTest();
        
        booking.Seat_Number__c = '15A';
        update booking;
        
        Test.stopTest();
        
        Booking__c updatedBooking = [SELECT Seat_Number__c
                                     FROM Booking__c
                                     WHERE Id = :booking.Id];
        
        System.assertEquals('15A', updatedBooking.Seat_Number__c, 'Seat number should be updated.');
    }
}