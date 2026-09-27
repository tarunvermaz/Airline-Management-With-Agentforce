import { LightningElement } from 'lwc';

export default class FlightSeatMap extends LightningElement {

    flightNumber = '';
    selectedSeat = '';

    seats = [
        { number: '1A', occupied: false },
        { number: '1B', occupied: true },
        { number: '1C', occupied: false },
        { number: '1D', occupied: false },
        { number: '2A', occupied: false },
        { number: '2B', occupied: false },
        { number: '2C', occupied: true },
        { number: '2D', occupied: false },
        { number: '3A', occupied: true },
        { number: '3B', occupied: false },
        { number: '3C', occupied: false },
        { number: '3D', occupied: false },
        { number: '4A', occupied: false },
        { number: '4B', occupied: true },
        { number: '4C', occupied: false },
        { number: '4D', occupied: false }
    ];

    get seatList() {
    return this.seats.map(seat => ({
        ...seat,
        cssClass: seat.occupied
            ? 'seat occupied'
            : seat.number === this.selectedSeat
                ? 'seat selected'
                : 'seat available'
    }));
}

    handleFlightChange(event) {
        this.flightNumber = event.target.value;
    }

    handleSeatSelection(event) {
        this.selectedSeat = event.currentTarget.dataset.seat;
    }
}