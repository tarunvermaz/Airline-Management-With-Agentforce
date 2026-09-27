import { LightningElement } from 'lwc';
import createCase from '@salesforce/apex/CaseWorkbenchController.createCase';

export default class CaseWorkbench extends LightningElement {

    passengerId = '';
    bookingReference = '';
    issueCategory = '';
    subject = '';
    description = '';

    successMessage = '';
    errorMessage = '';

    issueCategoryOptions = [
        { label: 'Booking Issue', value: 'Booking Issue' },
        { label: 'Flight Issue', value: 'Flight Issue' },
        { label: 'Payment Issue', value: 'Payment Issue' },
        { label: 'Baggage Issue', value: 'Baggage Issue' },
        { label: 'Cancellation', value: 'Cancellation' },
        { label: 'Refund', value: 'Refund' },
        { label: 'Other', value: 'Other' }
    ];

    handlePassengerChange(event) {
        this.passengerId = event.target.value;
    }

    handleBookingReferenceChange(event) {
        this.bookingReference = event.target.value;
    }

    handleIssueCategoryChange(event) {
        this.issueCategory = event.detail.value;
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleCreateCase() {

        this.successMessage = '';
        this.errorMessage = '';

        if (!this.passengerId || !this.issueCategory || !this.subject) {
            this.errorMessage =
                'Passenger, Issue Category, and Subject are required.';
            return;
        }

        createCase({
            passengerId: this.passengerId,
            bookingReference: this.bookingReference,
            issueCategory: this.issueCategory,
            subject: this.subject,
            description: this.description
        })
            .then(result => {

                this.successMessage =
                    'Case created successfully: ' + result;

                this.bookingReference = '';
                this.issueCategory = '';
                this.subject = '';
                this.description = '';
            })
            .catch(error => {

                this.errorMessage =
                    error.body?.message || 'Unable to create Case.';
            });
    }
}