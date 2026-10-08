public class BookingTriggerHandler {
    
    public static void beforeInsert(List<Booking__c> newBookings) {       
        for (Booking__c booking : newBookings) {
            System.debug('Processing new booking: ' + booking.Name);
        }
    } 
    public static void beforeUpdate(List<Booking__c> newBookings, Map<Id, Booking__c> oldBookings){        
            for (Booking__c booking : newBookings){            
                Booking__c oldBooking = oldBookings.get(booking.Id);
                
                System.debug('Updating booking from ' + oldBooking.Booking_Status__c +' to ' + booking.Booking_Status__c);
            }
        }  
    public static void afterUpdate(List<Booking__c> newBookings, Map<Id, Booking__c> oldBookings){   
            for (Booking__c booking : newBookings) {
                Booking__c oldBooking = oldBookings.get(booking.Id);
                if (BookingService.hasImportantChanges(booking, oldBooking)) {
                    System.debug('Important Booking change detected for: ' + booking.Name);
                }
            }
        }
    
}