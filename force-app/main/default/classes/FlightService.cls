public class FlightService {
    public static Boolean hasOperationalChanges(Flight__c newFlight, Flight__c oldFlight){
        
        if (newFlight == null || oldFlight == null) {
            return false;
        } 
        return newFlight.Departure_Date_Time__c != oldFlight.Departure_Date_Time__c
            || newFlight.Arrival_Date_Time__c != oldFlight.Arrival_Date_Time__c
            || newFlight.Aircraft__c != oldFlight.Aircraft__c
            || newFlight.Flight_Status__c != oldFlight.Flight_Status__c;
    }
}