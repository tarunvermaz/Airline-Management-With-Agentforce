public class FlightProcessingQueueable implements Queueable {
    
    private Set<Id> flightIds;
    public FlightProcessingQueueable(Set<Id> flightIds) {
        this.flightIds = flightIds;
    }
    public void execute(QueueableContext context) {
        try {
            List<Flight__c> flights = [SELECT Id, Name, Flight_Status__c
                                       FROM Flight__c
                                       WHERE Id IN :flightIds];        
            for (Flight__c flight : flights) {
                System.debug('Queueable processing Flight: ' + flight.Name + ' | Status: ' + flight.Flight_Status__c);
            }
        } catch (Exception e) {
            System.debug('Flight Queueable Error: ' + e.getMessage());
        }
    }
}