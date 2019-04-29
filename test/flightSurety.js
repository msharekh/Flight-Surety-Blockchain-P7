
var Test = require('../config/testConfig.js');
var BigNumber = require('bignumber.js');

// Available Accounts
// ==================
// (0) 0x68f48429f451934fd1032ba63be0f72eb10424eb (~100 ETH)
// (1) 0x18495d2af425d56005812644136bf68282188aea (~100 ETH)
// (2) 0xc61c9dadd04970bcd7802ecebf758f87b1e35d15 (~100 ETH)
// (3) 0xa513e91f2aaa5ec9b9b4815f44494fb323ae8a08 (~100 ETH)
// (4) 0xd64f959e7f9060e034c0fc9d61c5bc0b71e0d38c (~100 ETH)
// (5) 0x5e432600a3a158fbd90e9bce14089d1551b60007 (~100 ETH)
// (6) 0xd1e7d7e8468e83282f5b506bc57cac3c380e38e9 (~100 ETH)
// (7) 0x6de39a2aad3e1aab5e26d272c749224c39643ac9 (~100 ETH)
// (8) 0xf29001bf5449022cdc7111e2f18d99395f61819c (~100 ETH)
// (9) 0xfbedee2f31462596681a486e6e91f4cf00c69f1f (~100 ETH)

contract('Flight Surety Tests', async (accounts) => {

    var config;
    before('setup contract', async () => {
        config = await Test.Config(accounts);
        await config.flightSuretyData.authorizeCaller(config.flightSuretyApp.address);
    });

    /****************************************************************************************/
    /* Operations and Settings                                                              */
    /****************************************************************************************/


    it(`(1)(multiparty) has correct initial isOperational() value`, async function () {

        // Get operating status
        // let status = await config.flightSuretyData.isOperational.call();
        let status = await config.flightSuretyApp.isOperational.call();
        assert.equal(status, true, "Incorrect initial operating status value");

    });

    it(`(2)(multiparty) can block access to setOperatingStatus() for non-Contract Owner account`, async function () {

        // Ensure that access is denied for non-Contract Owner account
        let accessDenied = false;
        try {
            await config.flightSuretyData.setOperatingStatus(false, { from: config.testAddresses[2] });
        }
        catch (e) {
            accessDenied = true;
        }
        assert.equal(accessDenied, true, "Access not restricted to Contract Owner");

    });


    it(`(3)(multiparty) can allow access to setOperatingStatus() for Contract Owner account`, async function () {

        // Ensure that access is allowed for Contract Owner account
        let accessDenied = false;
        try {
            await config.flightSuretyData.setOperatingStatus(false);
        }
        catch (e) {
            accessDenied = true;
        }
        assert.equal(accessDenied, false, "Access not restricted to Contract Owner");

    });


    it(`(4)(multiparty) can block access to functions using requireIsOperational when operating status is false`, async function () {

        await config.flightSuretyData.setOperatingStatus(false);

        let reverted = false;
        try {
            await config.flightSurety.setTestingMode(true);
        }
        catch (e) {
            reverted = true;
        }
        assert.equal(reverted, true, "Access not blocked for requireIsOperational");

        // Set it back for other tests to work
        await config.flightSuretyData.setOperatingStatus(true);

    });


    it('(5)(airline) can register an Airline using registerAirline()', async () => {

        // ARRANGE
        let newAirline = accounts[2];


        //register accounts[2] :	 0xC61C9DaDd04970bCD7802eCEBF758F87B1E35D15
        console.log('newAirline', ':	', accounts[2]);
        console.log('config.firstAirline', ':	', config.firstAirline); //firstAirline = accounts[1]
        // await config.flightSuretyApp.registerAirline(newAirline, { from: config.firstAirline });
        // let reg = await config.flightSuretyApp.registerAirline(newAirline);
        // let reg = await config.flightSuretyData.registerAirline(newAirline, { from: config.firstAirline });
        await config.flightSuretyApp.registerAirline(newAirline, { from: config.firstAirline });


        let getAirlineresult = await config.flightSuretyData.getAirline.call(newAirline);
        console.log('getAirlineresult', ':	', getAirlineresult);

        // ASSERT
        // assert.equal(reg, true, "airline is not registered!");
    });



    it('(6)(airline) is Airline using isAirline()', async () => {
        let newAirline = accounts[2];

        // ACT
        // console.log('newAirline', ':	', newAirline);
        let result = await config.flightSuretyData.isAirline(newAirline);
        // console.log('airline', ':	', airline);
        // console.log('airline[0]', ':	', airline[0]);
        // result = airline[0];
        // airline = JSON.parse(airline)
        // console.log('airline.isRegistered', ':	', airline.isRegistered);
        // console.log('result', ':	', result);

        // ASSERT
        assert.equal(result, true, "airline is not registered!");

    });


    it('(7)(airline) cannot register an Airline using registerAirline() if it is not funded', async () => {

        // ARRANGE
        let newAirline = accounts[2];
        console.log('accounts[2]', ':	', accounts[2]);



        // ACT
        try {
            await config.flightSuretyApp.registerAirline(newAirline, { from: config.firstAirline });
        }
        catch (e) {

        }
        let result = await config.flightSuretyData.isAirline.call(newAirline);

        // ASSERT
        assert.equal(result, false, "Airline should not be able to register another airline if it hasn't provided funding");

    });


});
