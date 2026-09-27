@IsTest
private class BookingServiceTest {
    @IsTest
    static void testCanConfirmBooking() {
        Booking__c booking = new Booking__c(Payment_Status__c = 'Paid', Booking_Status__c = 'Confirmed');
        System.assertEquals(true, BookingService.canConfirmBooking(booking));
    }
    
    @IsTest
    static void testHasValidFare() {
        Booking__c booking = new Booking__c(Fare_Amount__c = 8500);
        System.assertEquals(true,BookingService.hasValidFare(booking));
    }
    
    @IsTest
    static void testCanCancelBooking() {
        Booking__c booking = new Booking__c(Booking_Status__c = 'Confirmed');
        System.assertEquals(true, BookingService.canCancelBooking(booking));
    }
    
    @IsTest
    static void testBookingStatusMessage() {
        Booking__c booking = new Booking__c(Booking_Status__c = 'Confirmed');
        
        System.assertEquals('Booking is confirmed.', BookingService.getBookingStatusMessage(booking));
    }
    
    @IsTest
    static void testBookingReadyForTicket() {
        
        Booking__c booking = new Booking__c(Booking_Status__c = 'Confirmed',
                                            Payment_Status__c = 'Paid',
                                            Fare_Amount__c = 8500);
        System.assertEquals(true,BookingService.isBookingReadyForTicket(booking));
    }
    
    @IsTest
    static void testImportantChanges() {
        Booking__c oldBooking = new Booking__c(Payment_Status__c = 'Pending',
                                               Booking_Status__c = 'Pending',
                                               Ticket_Status__c = 'Not Issued',
                                               Fare_Amount__c = 8500,
                                               Seat_Number__c = '12A');
        
        Booking__c newBooking = oldBooking.clone(false, true, false, false);
        newBooking.Seat_Number__c = '15A';
        System.assertEquals(true, BookingService.hasImportantChanges( newBooking, oldBooking));
    }
}