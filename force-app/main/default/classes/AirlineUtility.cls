public class AirlineUtility {
	public static String getBookingMessage(String bookingStatus) {
        if (bookingStatus == 'Confirmed') {
            return 'Booking is confirmed.';
        } else if (bookingStatus == 'Cancelled') {
            return 'Booking is cancelled.';
        } else {
            return 'Booking is pending.';
        }
    }
}

//String message = AirlineUtility.getBookingMessage('Confirmed');
//System.debug(message);