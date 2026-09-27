public with sharing class PaymentApiClient {
    
    public static String testConnection(){
        HttpRequest request = new HttpRequest();     
        request.setEndpoint('callout:Payment_API/test');     
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('Payment API Status: ' + response.getStatusCode());
        System.debug('Payment API Response: ' + response.getBody());
        return response.getBody();
    }
    
    
    public static String processPayment(String bookingNumber) {
        if (String.isBlank(bookingNumber)) {
            throw new CalloutException('Booking Number is required.');
        }
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Payment_API/carts/1');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('Payment API Status: ' + response.getStatusCode());
        System.debug('Payment API Response: ' + response.getBody());
        
        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw new CalloutException('Payment API request failed. HTTP Status: ' +response.getStatusCode());
        }
        return response.getBody();
    }
    
    public static String parsePaymentResponse(String responseBody) {
        if (String.isBlank(responseBody)) {
            return 'Failed';
        }  
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        if (response.containsKey('error')) {
            System.debug('Payment API Error: ' + String.valueOf(response.get('error')));
            return 'Failed';
        }
        if (response.containsKey('id')) {
            System.debug('Payment Transaction ID: ' + String.valueOf(response.get('id')));
            return 'Paid';
        }
        return 'Failed';
    }
    
    public static Id updateBookingPaymentStatus(String bookingNumber, String paymentStatus){    
        if (String.isBlank(bookingNumber)) {
            throw new AuraHandledException('Booking Number is required.');
        }
        
        if (paymentStatus != 'Paid' &&
            paymentStatus != 'Failed' &&
            paymentStatus != 'Refunded' &&
            paymentStatus != 'Pending') {              
                throw new AuraHandledException('Invalid payment status.');
            }
        
        Booking__c booking = [SELECT Id, Name, Payment_Status__c
                              FROM Booking__c
                              WHERE Name = :bookingNumber
                              LIMIT 1];
        
        booking.Payment_Status__c = paymentStatus;
        update booking;
        return booking.Id;
    }
}