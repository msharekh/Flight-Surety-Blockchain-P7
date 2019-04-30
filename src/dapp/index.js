
import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';


(async () => {

    let result = null;

    let contract = new Contract('localhost', () => {

        // Read transaction
        contract.isOperational((error, result) => {
            console.log(error, result);
            // debugger;
            display('Operational Status', 'Check if contract is operational', [{ label: 'Operational Status', error: error, value: result }]);
        });


        // Read transaction getAirlinesAdresses
        contract.getAirlinesAdresses((error, result) => {
            debugger;
            console.log(error, result);
            clearList("selGetAirlinesAdresses");
            for (let i = 0; i < result.length; i++) {
                console.log(` ${i} - ${result[i]}`);
                showInList("selGetAirlinesAdresses", result[i], i);
            }

        });

        // User-submitted transaction
        DOM.elid('submit-oracle').addEventListener('click', () => {
            let flight = DOM.elid('flight-number').value;
            // Write transaction
            contract.fetchFlightStatus(flight, (error, result) => {
                display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
            });
        })

        // register airline
        DOM.elid('register-airline').addEventListener('click', () => {
            // let _airlineName = DOM.elid('airlineName').value;
            let _airlineAddress = DOM.elid('airlineAddress').value;
            debugger;


            // function registerAirline(_airlineAddress, (v) => {
            // });


            // Write transaction
            contract.registerAirline(_airlineAddress, (v) => {
                // display('Oracles', 'Trigger oracles', [{ label: 'Fetch Flight Status', error: error, value: result.flight + ' ' + result.timestamp }]);
                debugger;
                contract.registerAirline
                console.log('_airlineAddress', ':	', v);

                // Read transaction getAirlinesAdresses
                contract.getAirlinesAdresses((error, result) => {
                    debugger;
                    console.log(error, result);
                    clearList("selGetAirlinesAdresses");
                    for (let i = 0; i < result.length; i++) {
                        debugger;
                        console.log(` ${i} - ${result[i]}`);
                        showInList("selGetAirlinesAdresses", result[i], i);
                    }

                });

            });
        })

    });


})();

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







