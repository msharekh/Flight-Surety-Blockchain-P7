
import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';


(async () => {

    let result = null;

    let contract = new Contract('localhost', () => {

        // Read transaction
        contract.isOperational((error, result) => {
            console.log(error, result);
            // ////debugger;
            display('Operational Status', 'Check if contract is operational', [{ label: 'Operational Status', error: error, value: result }]);
        });


        // Read transaction getAirlinesAdresses
        contract.getAirlinesAdresses((error, result) => {
            ////debugger;
            console.log(error, result);
            updateDDLs("selGetAirlinesAdresses", result, "airline");


        });



        // Read transaction getPassengers
        contract.getPassengersAdresses((error, result) => {
            //debugger;
            console.log(error, result);
            updateDDLs("selGetPassengersAdresses", result, "passenger");

        });

        // Read transaction getPassengers
        contract.getFlights((error, result) => {
            debugger;
            console.log(error, result);
            updateDDLs("selFlights", result, "flight");

        });

        // Read transaction getPassengers
        contract.getInsurances((error, result) => {
            //debugger;
            console.log(error, result);

            updateDDLs("selInsurances", result, "Insurances");

        });

        // Read transaction getPassengers
        contract.getBalance((error, result) => {
            //debugger;
            console.log(error, result);

            document.getElementById("result-info").innerHTML = result;

        });


    })

    //create airlines without registrations
    DOM.elid('create-airline').addEventListener('click', () => {
        let _address = DOM.elid('airlineAddress').value;
        // let _address = "0x18495d2af425d56005812644136bf68282188aea"
        let _name = `Airline - ${_address.substr(2, 4)}`
        // Write createAirline
        contract.createAirline(_address, _name, (v) => {
            // display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
            ////debugger;
            console.log('v', ':	', v);

            // Read transaction getAirlinesAdresses
            contract.getAirlinesAdresses((error, result) => {
                ////debugger;
                console.log(error, result);
                updateDDLs("selGetAirlinesAdresses", result, "airline");

            });

        });
    })
    // create-airline



    DOM.elid('create-flight').addEventListener('click', () => {

        // address airline,
        // string flight,
        // uint256 timestamp,
        // uint8 statusCode

        let flight = DOM.elid('flight').value;
        let _airline = document.querySelector("#selGetAirlinesAdresses").value
        let timestamp = Math.floor(Date.now() / 1000);
        let statusCode = 0;
        //debugger;
        contract.createFlight(_airline, flight, timestamp, statusCode, ((error, v) => {
            // display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
            //debugger;
            console.log('v', ':	', v);

            // Read transaction getPassengers
            contract.getFlights((error, result) => {
                //debugger;
                console.log(error, result);

                updateDDLs("selFlights", result, "flight");

            });
        }));


    });

    // createFlight

    DOM.elid('create-passenger').addEventListener('click', () => {
        let _address = DOM.elid('passengerAddress').value;
        contract.createPassenger(_address, (v) => {
            // display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
            ////debugger;
            console.log('v', ':	', v);

            // Read transaction getPassengers
            contract.getPassengersAdresses((error, result) => {
                //debugger;
                console.log(error, result);

                updateDDLs("selGetPassengersAdresses", result, "passenger");

            });

        });
    })
    // createPassenger



    DOM.elid('create-insurance').addEventListener('click', () => {

        debugger;
        // bytes32 flightKey,address passengerAddress,uint price
        let flightKey = document.querySelector("#selFlights").value
        let passengerAddress = document.querySelector("#selGetPassengersAdresses").value
        let price = DOM.elid('price').value;

        //debugger;
        contract.payInsurance(flightKey, passengerAddress, price, ((error, v) => {
            // display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
            debugger;
            console.log('v', ':	', v);

            // Read transaction getPassengers
            contract.getInsurances((error, result) => {
                //debugger;
                console.log(error, result);

                updateDDLs("selInsurances", result, "Insurances");

            });
        }));


    });

    // payInsurance

    DOM.elid('get-airline').addEventListener('click', () => {
        // let _address = DOM.elid('airlineAddress').value;
        let _address = document.querySelector("#selGetAirlinesAdresses").value


        contract.getAirline(_address, (error, result) => {
            // //debugger;
            console.log(error, result);
            let html = `    <h3>Information</h3>
                            <p>registered:\t\t${result[0]}</p>
                            <p>funded:\t\t${result[1]}</p>
                            <p>airline Name:\t\t${result[2]}</p>
                            <p>airline Address:\t\t${result[3].substr(0, 10)}</p>`
            document.getElementById("airline-info").innerHTML = html;



        });
        // " airline-info"


    });
    // get-airline


    DOM.elid('get-flight').addEventListener('click', () => {
        // let _address = DOM.elid('airlineAddress').value;
        let _key = document.querySelector("#selFlights").value


        contract.getFlight(_key, (error, result) => {
            // //debugger;
            console.log(error, result);
            let html = `<h3>Information</h3>
                        <p>airline:\t\t${result[0].substr(0, 10)}</p>
                        <p>flight:\t\t${result[1]}</p>
                        <p>updatedTimestamp:\t\t${result[2]}</p>
                        <p>statusCode:\t\t${result[3].substr(0, 10)}</p>
                        <p>insured:\t\t${result[4]}</p>`;
            document.getElementById("airline-info").innerHTML = html;
            document.getElementById("flight-number").value = result[1];


        });
        // " airline-info"


    });
    // get-Insurance
    DOM.elid('get-insurance').addEventListener('click', () => {
        // let _address = DOM.elid('airlineAddress').value;
        let _key = document.querySelector("#selInsurances").value


        contract.getInsurance(_key, (error, result) => {
            // //debugger;
            console.log(error, result);
            // Insurances[key].price,
            //     Insurances[key].flightKey,
            //     Insurances[key].passengerAddress,
            //     Insurances[key].isClaimed
            let html = `<h3>Information</h3>
                        <p>price:\t\t${result[0]}</p>
                        <p>flightKey:\t\t${result[1]}</p>
                        <p>passengerAddress:\t\t${result[2].substr(0, 10)}</p>
                        <p>isClaimed:\t\t${result[3]}</p>`;
            document.getElementById("airline-info").innerHTML = html;


        });
        // " airline-info"


    });
    // get-flight

    //getInsurance

    // User-submitted transaction
    DOM.elid('submit-oracle').addEventListener('click', () => {
        // let flight = DOM.elid('flight-number').value;
        let flight = document.getElementById("flight-number").value
        let address = document.querySelector("#selGetAirlinesAdresses").value

        // Write transaction
        contract.fetchFlightStatus(address, flight, (error, result) => {
            display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
        });
    })

    /************** register airline ***************/
    DOM.elid('register-airline').addEventListener('click', () => {
        // let _airlineName = DOM.elid('airlineName').value;
        let _address = document.querySelector("#selGetAirlinesAdresses").value

        // Write transaction
        contract.registerAirline(_address, (v) => {
            ////debugger;
            console.log('_address', ':	', v);
        });
    })
    // register-airline

    /************** fund airline ***************/
    DOM.elid('fund-airline').addEventListener('click', () => {
        let fundValue = DOM.elid('fundValue').value;
        let _address = document.querySelector("#selGetAirlinesAdresses").value
        //debugger;
        // Write transaction
        contract.fundAirline(_address, fundValue, (v) => {
            ////debugger;
            console.log('_address', ':	', v);
        });
    })
    // fund-airline



})();
function updateDDLs(element, result, type) {
    clearList(element);
    for (let i = 0; i < result.length; i++) {
        //debugger;
        console.log(`* ${i} - ${result[i]}`);
        showInList(element, result[i], i);
    }
}

function clearList(container) {
    // get reference to select element
    var sel = document.getElementById(container);
    var length = sel.options.length;
    for (var i = 0; i < length; i++) {
        sel.options[i] = null;
    }
}
function showInList(container, txt, idx) {
    // get reference to select element
    var sel = document.getElementById(container);

    // create new option element
    var opt = document.createElement('option');

    // create text node to add to option element (opt)
    let num = parseInt(idx) + 1;
    opt.appendChild(document.createTextNode(`${num}- ${txt.substr(0, 6)}`));

    // set value property of opt
    opt.value = txt;

    // add opt to end of select box (sel)
    sel.appendChild(opt);
}

function display(title, description, results) {
    let displayDiv = DOM.elid("display-wrapper");
    let section = DOM.section();
    section.appendChild(DOM.h2(title));
    section.appendChild(DOM.h5(description));
    results.map((result) => {
        let row = section.appendChild(DOM.div({ className: 'row' }));
        row.appendChild(DOM.div({ className: 'col-sm-4 field' }, result.label));
        row.appendChild(DOM.div({ className: 'col-sm-8 field-value' }, result.error ? String(result.error) : String(result.value)));
        section.appendChild(row);
    })
    displayDiv.append(section);

}







