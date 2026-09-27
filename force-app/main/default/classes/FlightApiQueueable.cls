public with sharing class FlightApiQueueable implements Queueable, Database.AllowsCallouts {
    
    // Retry counter
    private Integer retryCount;
    // First execution
    public FlightApiQueueable(){
        this.retryCount = 0;
    }
    // Retry execution
    public FlightApiQueueable(Integer retryCount) {
        this.retryCount = retryCount;
    }
    
    public void execute(QueueableContext context) {
        try {
            // STEP 1: Call External Flight API
            String response = FlightApiClient.getFlights();
            
            // STEP 2: Convert API response into Flight records  
            List<Flight__c> apiFlights = FlightApiClient.buildFlightRecords(response);
            System.debug('Flights mapped from API: ' + apiFlights.size());
            if (apiFlights.isEmpty()) {
                System.debug('No flight records received.');
                return;
            }
            
            // STEP 3: Collect Flight Numbers
            Set<String> flightNumbers = new Set<String>();
            for (Flight__c flight : apiFlights) {
                if (String.isNotBlank(flight.Name)) {
                    flightNumbers.add(flight.Name);
                }
            }
            
            // STEP 4: Find Existing Salesforce Flights
            Map<String, Flight__c> existingFlights = new Map<String, Flight__c>();
            for (Flight__c existingFlight : [SELECT Id, Name 
                                             FROM Flight__c 
                                             WHERE Name IN :flightNumbers]){
                                                 existingFlights.put(existingFlight.Name, existingFlight);
                                             }
            
            // STEP 5: Prepare Insert and Update Lists
            List<Flight__c> recordsToInsert = new List<Flight__c>();
            List<Flight__c> recordsToUpdate =new List<Flight__c>();
            Integer skippedFlights = 0;
            
            // STEP 6: Process API Flight Records
            for (Flight__c apiFlight : apiFlights) {
                
                // Skip invalid flight timings
                if (
                    apiFlight.Departure_Date_Time__c == null ||
                    apiFlight.Arrival_Date_Time__c == null ||
                    apiFlight.Arrival_Date_Time__c <= apiFlight.Departure_Date_Time__c){
                        skippedFlights++;
                        System.debug('Skipping invalid flight timing: ' + apiFlight.Name);
                        continue;
                    }
                
                // UPDATE EXISTING FLIGHT
                if (existingFlights.containsKey(apiFlight.Name)){
                    Flight__c existingFlight = existingFlights.get(apiFlight.Name);
                    existingFlight.Departure_Airport__c = apiFlight.Departure_Airport__c;
                    existingFlight.Arrival_Airport__c = apiFlight.Arrival_Airport__c;
                    existingFlight.Departure_Date_Time__c = apiFlight.Departure_Date_Time__c;
                    existingFlight.Arrival_Date_Time__c = apiFlight.Arrival_Date_Time__c;
                    existingFlight.Flight_Status__c = apiFlight.Flight_Status__c;
                    recordsToUpdate.add(existingFlight);
                }
                
                // INSERT NEW FLIGHT
                else {
                    // Temporary defaults because
                    // Aviationstack does not provide
                    // these required Salesforce fields
                    
                    apiFlight.Total_Seats__c = 180;
                    apiFlight.Available_Seats__c = 180;
                    apiFlight.Base_Fare__c = 5000;
                    recordsToInsert.add(apiFlight);
                }
            }
            
            // STEP 7: Insert New Flights
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
            
            // STEP 8: Update Existing Flights
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
            
            // STEP 9: Logging
            System.debug('New Flights Inserted: ' + recordsToInsert.size());
            System.debug('Existing Flights Updated: ' + recordsToUpdate.size());
            System.debug('Invalid Flights Skipped: ' + skippedFlights);
        }
        catch (Exception e) {
            System.debug('Flight API Queueable Error: ' + e.getMessage());
            
            // STEP 10: Retry Once If API Fails
            if (retryCount < 1) {
                System.debug('Flight API retry queued.');
                System.enqueueJob(new FlightApiQueueable(retryCount + 1));
            } else {
                System.debug('Flight API failed after retry.');
            }
        }
    }
}