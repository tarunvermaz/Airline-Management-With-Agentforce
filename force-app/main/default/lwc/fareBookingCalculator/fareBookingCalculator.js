import { LightningElement } from 'lwc';

export default class FareBookingCalculator extends LightningElement {

    baseFare = 0;
    passengerType = 'Adult';

    passengerTypeOptions = [
        { label: 'Adult', value: 'Adult' },
        { label: 'Child', value: 'Child' },
        { label: 'Infant', value: 'Infant' }
    ];

    handleBaseFareChange(event) {
        this.baseFare = Number(event.target.value) || 0;
    }

    handlePassengerTypeChange(event) {
        this.passengerType = event.detail.value;
    }

    get taxRate() {
        if (this.passengerType === 'Child') {
            return 0.05;
        }

        if (this.passengerType === 'Infant') {
            return 0.02;
        }

        return 0.05;
    }

    get taxAmount() {
        return (this.baseFare * this.taxRate).toFixed(2);
    }

    get totalFare() {
        return (this.baseFare + Number(this.taxAmount)).toFixed(2);
    }
}