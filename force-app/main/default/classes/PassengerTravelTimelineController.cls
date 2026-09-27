public with sharing class PassengerTravelTimelineController {
    
    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getPassengerBookings(Id passengerId) {
        if (passengerId == null) {
            return new List<Booking__c>();
        }
        
        return [SELECT Id, Name, Seat_Number__c, Booking_Status__c, Booking_Date__c, Flight__c, 
                Flight__r.Name, Flight__r.Departure_Airport__c, Flight__r.Arrival_Airport__c, Flight__r.Departure_Date_Time__c
                FROM Booking__c
                WHERE Contact__c = :passengerId
                ORDER BY Flight__r.Departure_Date_Time__c ASC];
    }
}