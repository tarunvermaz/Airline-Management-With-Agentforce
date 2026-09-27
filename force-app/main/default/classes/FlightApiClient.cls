public with sharing class FlightApiClient {
    
    public static String getFlights() {
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Airline_Flight_API/v1/flights?access_key=76f47abce1b2d8caf0bfbd0e86c696a2');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('Flight API Status: ' + response.getStatusCode());
        System.debug('Flight API Response: ' + response.getBody());
        
        if (response.getStatusCode() < 200 ||response.getStatusCode() >= 300) {
            throw new CalloutException('Flight API request failed. HTTP Status: ' + response.getStatusCode());
        }
        return response.getBody();
    }
    
    public static void parseFlights(String responseBody) {
        if (String.isBlank(responseBody)) {
            System.debug('Flight API returned an empty response.');
            return;
        }
        
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        if (response.containsKey('error')) {
            System.debug('Flight API Error: ' + String.valueOf(response.get('error')));
            return;
        }
        if (!response.containsKey('data')) {
            System.debug('Flight API response does not contain data.');
            return;
        }
        
        List<Object> flights =(List<Object>) response.get('data');
        System.debug('Total flights received: ' + flights.size());
        
        for (Object flightObject : flights) {
            Map<String, Object> flight = (Map<String, Object>) flightObject;
            Map<String, Object> flightInfo =(Map<String, Object>) flight.get('flight');
            Map<String, Object> departure = (Map<String, Object>) flight.get('departure');
            Map<String, Object> arrival =(Map<String, Object>) flight.get('arrival');
            
            System.debug('Flight Number: ' + String.valueOf(flightInfo.get('number')));
            System.debug('Departure: ' + String.valueOf(departure.get('iata')));
            System.debug('Arrival: ' + String.valueOf(arrival.get('iata')));
            System.debug('Status: ' + String.valueOf(flight.get('flight_status')));
        }
    }
    
    public static List<Flight__c> buildFlightRecords(String responseBody) {
        List<Flight__c> flightsToSave = new List<Flight__c>();
        if (String.isBlank(responseBody)) {
            return flightsToSave;
        }
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        
        if (response.containsKey('error')) {
            System.debug('Flight API Error: ' + String.valueOf(response.get('error')));
            return flightsToSave;
        }
        
        List<Object> flights = (List<Object>) response.get('data');
        if (flights == null || flights.isEmpty()) {
            return flightsToSave;
        }
        
        for (Object flightObject : flights) {
            Map<String, Object> flight = (Map<String, Object>) flightObject;
            Map<String, Object> flightInfo = (Map<String, Object>) flight.get('flight');
            Map<String, Object> departure = (Map<String, Object>) flight.get('departure');
            Map<String, Object> arrival = (Map<String, Object>) flight.get('arrival');
            
            if (flightInfo == null || departure == null || arrival == null) {
                continue;
            }
            
            Flight__c newFlight = new Flight__c();
            
            newFlight.Name = String.valueOf(flightInfo.get('number'));
            newFlight.Departure_Airport__c = String.valueOf(departure.get('iata'));
            newFlight.Arrival_Airport__c = String.valueOf(arrival.get('iata'));
            newFlight.Flight_Status__c = mapFlightStatus(String.valueOf(flight.get('flight_status')));
            
            String departureScheduled = String.valueOf(departure.get('scheduled'));
            String arrivalScheduled = String.valueOf(arrival.get('scheduled'));
            
            if (departureScheduled != 'null') {
                newFlight.Departure_Date_Time__c = parseApiDateTime(departureScheduled);
            }
            if (arrivalScheduled != 'null') {
                newFlight.Arrival_Date_Time__c = parseApiDateTime(arrivalScheduled);
            }
            flightsToSave.add(newFlight);
        }
        return flightsToSave;
    }
    private static Datetime parseApiDateTime(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        value = value.replace('T', ' ');
        value = value.replace('Z', '');
        if (value.length() >= 19) {
            value = value.substring(0, 19);
        }
        return Datetime.valueOf(value);
    }
    private static String mapFlightStatus(String apiStatus) {
        
        if (String.isBlank(apiStatus)) {
            return 'Scheduled';
        }
        switch on apiStatus.toLowerCase() {
            when 'scheduled' {
                return 'Scheduled';
            }
            when 'boarding' {
                return 'Boarding';
            }
            when 'departed' {
                return 'Departed';
            }
            when 'landed' {
                return 'Arrived';
            }
            when 'arrived' {
                return 'Arrived';
            }
            when 'cancelled' {
                return 'Cancelled';
            }
            when 'delayed' {
                return 'Delayed';
            }
            when else {
                return 'Scheduled';
            }
        }
    }
}