import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';

export default class Contract {
    constructor(network, callback) {

        let config = Config[network];
        this.web3 = new Web3(new Web3.providers.HttpProvider(config.url));
        this.flightSuretyApp = new this.web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);
        this.initialize(callback);
        this.owner = null;
        this.airlines = [];
        this.passengers = [];
    }

    initialize(callback) {
        this.web3.eth.getAccounts((error, accts) => {

            this.owner = accts[0];

            let counter = 1;

            while (this.airlines.length < 5) {
                this.airlines.push(accts[counter++]);
            }

            while (this.passengers.length < 5) {
                this.passengers.push(accts[counter++]);
            }

            callback();
        });
    }

    isOperational(callback) {
        let self = this;
        //TODO: TO CONFIGURE flightSuretyData.isOperational
        //DONE
        self.flightSuretyApp.methods
            .isOperational()
            .call({ from: self.owner }, callback);
    }
    // bool,uint256,string,address
    getAirline(_address, callback) {
        let self = this;
        debugger;
        self.flightSuretyApp.methods
            .getAirline(_address)
            .call({ from: self.owner }, callback);
        // .send({ from: self.owner }, (error, result) => {
        //     callback(result);
        // });
        //     .call({ from: self.owner }, callback);
        // callback();
    }

    getAirlinesAdresses(callback) {
        let self = this;
        //debugger;

        //TODO: TO CONFIGURE flightSuretyData.getAirlinesAdresses

        self.flightSuretyApp.methods
            .getAirlinesAdresses()
            .call({ from: self.owner }, callback);

    }
    createAirline(_address, _name, callback) {
        let self = this;
        //debugger;
        self.flightSuretyApp.methods
            // .registerAirline(v1, { from: self.owner });
            .createAirline(_address, _name)
            .send({ from: self.owner, gas: 5555555 }, (error, result) => {
                callback(_address);
            });
        // .registerAirline.call(_airlineAddress, callback(_airlineAddress));
        //callback(_address);
    }



    registerAirline(_address, callback) {
        let self = this;
        //debugger;
        self.flightSuretyApp.methods
            // .registerAirline(v1, { from: self.owner });
            .registerAirline(_address)
            .send({ from: self.owner, gas: 5555555 }, (error, result) => {
                callback(_address);
            });
        // .registerAirline.call(_airlineAddress, callback(_airlineAddress));
        //callback(_address);
    }

    fetchFlightStatus(flight, callback) {
        let self = this;
        //TODO: TO CONFIGURE flightSuretyData.fetchFlightStatus

        let payload = {
            airline: self.airlines[0],
            flight: flight,
            timestamp: Math.floor(Date.now() / 1000)
        }
        self.flightSuretyApp.methods
            .fetchFlightStatus(payload.airline, payload.flight, payload.timestamp)
            .send({ from: self.owner }, (error, result) => {
                callback(error, payload);
            });
    }
}