public class FlightTriggerHandler {
    
    public static void afterUpdate(List<Flight__c> newFlights, Map<Id, Flight__c> oldFlights){
        
        Set<Id> flightIds = new Set<Id>();
        for (Flight__c flight : newFlights) {
            Flight__c oldFlight = oldFlights.get(flight.Id);
            if (FlightService.hasOperationalChanges(flight, oldFlight)){
                System.debug('Important Flight change detected: ' + flight.Name);
                flightIds.add(flight.Id);
            }
        }
        if (!flightIds.isEmpty()) {
            System.enqueueJob(new FlightProcessingQueueable(flightIds));
        }
    }
}

//wow