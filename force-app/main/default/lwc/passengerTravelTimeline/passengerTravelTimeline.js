import { LightningElement } from 'lwc';
import getPassengerBookings from '@salesforce/apex/PassengerTravelTimelineController.getPassengerBookings';

export default class PassengerTravelTimeline extends LightningElement {

    passengerId = '';
    bookings = [];

    handlePassengerIdChange(event) {
        this.passengerId = event.target.value;
        this.loadBookings();
    }

    loadBookings() {
        if (!this.passengerId) {
            this.bookings = [];
            return;
        }

        getPassengerBookings({
            passengerId: this.passengerId
        })
            .then(result => {
                this.bookings = result;
            })
            .catch(error => {
                console.error('Error loading passenger bookings:', error);
                this.bookings = [];
            });
    }

    get hasBookings() {
        return this.bookings.length > 0;
    }

    get timelineBookings() {
        return this.bookings.map(booking => ({
            id: booking.Id,
            flightNumber: booking.Flight__r
                ? booking.Flight__r.Name
                : 'No Flight',
            route: booking.Flight__r
                ? `${booking.Flight__r.Departure_Airport__c} → ${booking.Flight__r.Arrival_Airport__c}`
                : 'Route unavailable',
            seatNumber: booking.Seat_Number__c,
            bookingStatus: booking.Booking_Status__c,
            travelDate: booking.Flight__r
                ? booking.Flight__r.Departure_Date_Time__c
                : 'Not available'
        }));
    }
}