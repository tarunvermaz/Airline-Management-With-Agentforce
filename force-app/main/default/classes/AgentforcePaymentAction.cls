public with sharing class AgentforcePaymentAction {
    
    public class Request {
        @InvocableVariable(required=true)
        public String bookingNumber;
    }
    public class Response {
        @InvocableVariable
        public String paymentStatus;
        @InvocableVariable
        public String message;
    }
    @InvocableMethod(
        label='Process Booking Payment'
        description='Processes payment for an airline booking using the existing Payment API integration.')
    
    public static List<Response> processPayment(List<Request> requests) {
        List<Response> results = new List<Response>();
        
        for (Request request : requests) {
            Response result = new Response();
            if (request == null || String.isBlank(request.bookingNumber)) {
                result.paymentStatus = 'Failed';
                result.message = 'Booking number is required.';
                results.add(result);
                continue;
            }
            
            try {
                String response =PaymentApiClient.processPayment(request.bookingNumber);
                String paymentStatus =PaymentApiClient.parsePaymentResponse(response);
                
                PaymentApiClient.updateBookingPaymentStatus(request.bookingNumber,paymentStatus);
                result.paymentStatus = paymentStatus;
                result.message ='Payment processing completed and the booking payment status was updated.';
            } 
            catch (Exception e) {
                result.paymentStatus = 'Failed';
                result.message ='Payment processing failed: ' +e.getMessage();
            }
            results.add(result);
        }
        return results;
    }
}