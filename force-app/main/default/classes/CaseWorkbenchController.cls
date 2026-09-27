public with sharing class CaseWorkbenchController {
    
    @AuraEnabled
    public static String createCase(
        Id passengerId,
        String bookingReference,
        String issueCategory,
        String subject,
        String description){
            
            if (passengerId == null) {
                throw new AuraHandledException('Passenger is required.');
            }
            if (String.isBlank(issueCategory)) {
                throw new AuraHandledException('Issue Category is required.');
            }
            if (String.isBlank(subject)) {
                throw new AuraHandledException('Subject is required.');
            }
            Case newCase = new Case(ContactId = passengerId,
                                    Booking_Reference__c = bookingReference,
                                    Issue_Category__c = issueCategory,
                                    Subject = subject,
                                    Description = description,
                                    Origin = 'Web',
                                    Status = 'New');
            
            insert newCase;
            return newCase.CaseNumber;
        }
}