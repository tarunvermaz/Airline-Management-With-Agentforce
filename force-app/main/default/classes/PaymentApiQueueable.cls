public with sharing class PaymentApiQueueable implements Queueable, Database.AllowsCallouts {
    
    // Booking number being processed
    private String bookingNumber;
    // Retry counter
    private Integer retryCount; 
    // First execution
    public PaymentApiQueueable(String bookingNumber) {
        this.bookingNumber = bookingNumber;
        this.retryCount = 0;
    }
    
    // Retry execution
    public PaymentApiQueueable(String bookingNumber, Integer retryCount){
        this.bookingNumber = bookingNumber;
        this.retryCount = retryCount;
    }
    
    public void execute(QueueableContext context) {
        
        try {
            // STEP 1: Call External Payment API
            String response = PaymentApiClient.processPayment(bookingNumber);
            // STEP 2: Parse Payment API Response
            String paymentStatus = PaymentApiClient.parsePaymentResponse(response);
            
            System.debug('Payment API Status: ' + paymentStatus);
            // STEP 3: Update Salesforce Booking
            PaymentApiClient.updateBookingPaymentStatus(bookingNumber,paymentStatus);
            
            System.debug('Booking Payment Status Updated: ' + bookingNumber);
            
        }
        catch (Exception e) {
            System.debug('Payment API Queueable Error: ' + e.getMessage());
            // STEP 4: Retry Once If Payment API Fails
            if (retryCount < 1) {
                System.debug('Payment API retry queued.');
                
                System.enqueueJob(new PaymentApiQueueable(bookingNumber, retryCount + 1));
            } 
            else {
                System.debug('Payment API failed after retry.');
            }
        }
    }
}