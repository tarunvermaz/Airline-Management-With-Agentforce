public class BookingService {
    public static Boolean canConfirmBooking(Booking__c booking) {
        
        if (booking == null) {
            return false;
        }
        return booking.Payment_Status__c == 'Paid' && booking.Booking_Status__c == 'Confirmed';
    }
    
    //method 2 Fare validation logic
    
    public static Boolean hasValidFare(Booking__c booking) {
        
        if (booking == null || booking.Fare_Amount__c == null) {
            return false;
        }
        return booking.Fare_Amount__c > 0;
    }
    
    //Method 3 Booking cancellation eligibility
    
    public static Boolean canCancelBooking(Booking__c booking) {
        if (booking == null) {
            return false;
        }
        return booking.Booking_Status__c != 'Cancelled';
    }
    
    //Method 4 Booking Status Message
    
    public static String getBookingStatusMessage(Booking__c booking) {
        if (booking == null) {
            return 'Booking not provided.';
        }
        if (booking.Booking_Status__c == 'Confirmed') {
            return 'Booking is confirmed.';
        }
        if (booking.Booking_Status__c == 'Cancelled') {
            return 'Booking is cancelled.';
        }
        return 'Booking is pending.';
    }
    
    //method 5 Before issuing a ticket, Check isBookingReadyForTicket
    
    public static Boolean isBookingReadyForTicket(Booking__c booking) {
        if (booking == null) {
            return false;
        }
        return booking.Booking_Status__c == 'Confirmed'
            && booking.Payment_Status__c == 'Paid'
            && booking.Fare_Amount__c != null
            && booking.Fare_Amount__c > 0;
    } 
    
    //Method 6
    
    public static Boolean hasImportantChanges(Booking__c newBooking, Booking__c oldBooking){
        if (newBooking == null || oldBooking == null) {
            return false;
        }
        
        return newBooking.Payment_Status__c != oldBooking.Payment_Status__c
            || newBooking.Booking_Status__c != oldBooking.Booking_Status__c
            || newBooking.Ticket_Status__c != oldBooking.Ticket_Status__c
            || newBooking.Fare_Amount__c != oldBooking.Fare_Amount__c
            || newBooking.Seat_Number__c != oldBooking.Seat_Number__c;
    }
}


/*1
Booking__c booking = new Booking__c(
Payment_Status__c = 'Paid',
Booking_Status__c = 'Confirmed'
);

Boolean result = BookingService.canConfirmBooking(booking);

System.debug('Can Confirm Booking: ' + result);
*/
/*2
Booking__c booking = new Booking__c(
Fare_Amount__c = 8500
);

Boolean result = BookingService.hasValidFare(booking);

System.debug('Has Valid Fare: ' + result);
*/
/*3
Booking__c booking = new Booking__c(
Booking_Status__c = 'Confirmed'
);

Boolean result = BookingService.canCancelBooking(booking);

System.debug('Can Cancel Booking: ' + result);
*/