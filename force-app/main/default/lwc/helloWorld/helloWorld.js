import { LightningElement, track, api } from 'lwc';
export default class HelloWorld extends LightningElement {
    @track greeting = 'World';
    @track itsamatch;
    @api recordId;
    changeHandler(event) {
        this.greeting = event.target.value;
    }

    checkmatch(event) {
        if (this.greeting === event.target.value) {
            this.itsamatch = 'Yup it matches';
        }
        else {
            this.itsamatch = 'not a match';
        }
    }
}