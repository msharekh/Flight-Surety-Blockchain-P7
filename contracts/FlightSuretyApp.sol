pragma solidity ^0.4.25;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

/************************************************** */
/* FlightSurety Smart Contract                      */
/************************************************** */
contract FlightSuretyApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    FlightSuretyData flightSuretyData;


// region xxx
/* ..........................................*/

/* ..........................................*/
// endregion


// region OTHER
/* ..........................................*/
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;

    address private contractOwner;          // Account used to deploy contract

 
    function getBalance() public returns(uint){
        return address(this).balance;
    }
 
    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
         // Modify to call data contract's status
         
        require(flightSuretyData.isOperational(), "Contract is currently not operational");  
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireOnlyExistingAirlineRegisterNewAirline(address _address) //Multiparty Consensus
    {
        bool airlineExists = false;
        if(flightSuretyData.getAirlineCount() < 4)
        {
            if(flightSuretyData.isAirline(_address)){
                airlineExists=true;
            }
        }
            
        require(airlineExists,"valid airline can only register a new airline.");
        _;
    }

    

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    /**
    * @dev Contract constructor
    *
    */
    constructor
                                (
                                    address dataAddress
                                ) 
                                public 
    {
        contractOwner = msg.sender;
        // create object of flightSuretyData
        flightSuretyData = FlightSuretyData(dataAddress);
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
       //  TODO: Modify to call data contract's status
        // return true;
        // return true;
        // bool result = flightSuretyData.isOperational();
        return flightSuretyData.isOperational();
     }


    // function fetchAirlines() 
    //                         public 
    //                         view 
    //                         returns(bool) 
    // {
    //    //  TODO: Modify to call data contract's status
    //     // return true;
    //     // return true;
    //     // bool result = flightSuretyData.isOperational();
    //     return flightSuretyData.isOperational();
    //  }
    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/


/* ..........................................*/
// endregion
   


// region AIRLINE
/* ..........................................*/
    /**
    * @dev Add an airline with isRegister = false
    *
    */   
    function createAirline
                            (  
                                address _address ,
                                string _name 
                            )
                            external                              
    {
         // return   true;
        flightSuretyData.createAirline(_address,_name);
        // return (success, 0);
    }

    function fundAirline(address _address ,uint256 fundValue) external payable{
        flightSuretyData.fundAirline(_address,fundValue);
    }
  
   /**
    * @dev Add an airline to the registration queue
    *
    */   
    function registerAirline
                            (  
                                address _address 
                            )
                            external  
                            requireOnlyExistingAirlineRegisterNewAirline(_address)               
                            // returns(bool success, uint256 votes)
                            // view
                            // returns(bool)
    {
         // return   true;
        flightSuretyData.registerAirline(_address);
        // return (success, 0);
    }

    /* function fundAirline
                            (   
                                address _address ,uint256 fundValue
                            )
                            external
    {
        flightSuretyData.fundAirline( _address , fundValue);
    } */

    function getAirlinesAdresses() external view returns (address[]) {
         return flightSuretyData.getAirlinesAdresses();
    }

    function getAirline
                    (
                        address _address
                    )
                    external
                    view                     
                    returns (bool,uint256,string,address) {

     return   flightSuretyData.getAirline(_address);
    }
/* ..........................................*/
// endregion

 
// region PASSENGER
/* ..........................................*/
    
    address[] passengersAdresses;

    function createPassenger
                            (  
                                address _address 
                            )
                            external                              
    {
        passengersAdresses.push(_address);
    }

    function getPassengersAdresses() external view returns (address[]) {
         return passengersAdresses;
    }

/* ..........................................*/
// endregion


// region FLIGHT
/* ..........................................*/

    uint8 numberOfFlights;
    struct Flight {
        bool isRegistered;
        string flight;
        uint8 statusCode;
        uint256 updatedTimestamp;        
        address airline;
        bool isInsured;
    }
    mapping(bytes32 => Flight) private flights;

    bytes32[] flightsList;

    function createFlight
                            (                                  
                                address airline,
                                string flight,
                                uint256 timestamp,
                                uint8 statusCode
                            )
                            external                              
    {
        bytes32 key = keccak256(abi.encodePacked(airline, flight, timestamp)); 

        flights[key].flight=flight;
        flights[key].statusCode=STATUS_CODE_UNKNOWN;
        flights[key].updatedTimestamp=timestamp;
        flights[key].airline=airline;
        flights[key].isInsured=false;

        numberOfFlights += 1;
        flightsList.push(key);
    }

    function getFlights() external view returns (bytes32[]) {
         return flightsList;
    }

    function getFlight
                    (
                        bytes32 key
                    )
                    external
                    view                     
                    // returns (bool,uint256,string,address)
                    returns (address ,
                                string ,
                                uint256 ,
                                uint8,
                                bool )
    {
        
        return  
            (
                flights[key].airline,
                flights[key].flight,
                flights[key].updatedTimestamp,
                flights[key].statusCode,
                flights[key].isInsured

            );
        // return true; 
        // return false;
    }

    /**
    * @dev Register a future flight for insuring.
    *
    */  
    function registerFlight
                                (
                                )
                                external
                                pure
    {

    }

   /**
    * @dev Called after oracle has updated flight status
    *
    */  
    function processFlightStatus
                                (
                                    address airline,
                                    string memory flight,
                                    uint256 timestamp,
                                    uint8 statusCode
                                )
                                internal
                                pure
    {
    }


    // Generate a request for oracles to fetch flight information
    function fetchFlightStatus
                        (
                            address airline,
                            string flight,
                            uint256 timestamp                            
                        )
                        external
    {
        uint8 index = getRandomIndex(msg.sender);

        // Generate a unique key for storing the request
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp));
        oracleResponses[key] = ResponseInfo({
                                                requester: msg.sender,
                                                isOpen: true
                                            });

        emit OracleRequest( index,
                            airline,
                            flight,
                            timestamp
           );
    } 
/* ..........................................*/
// endregion


// region INSURANCE
/* ..........................................*/

    uint8 numberOfInsurances;
    struct Insurance {
        bytes32 flightKey;
        address passengerAddress;
        uint256 price;
        bool isClaimed;
    }
    mapping(bytes32 => Insurance) private Insurances;
    bytes32[] InsurancesList;

    
    function payInsurance(
                bytes32 _flightKey,
                address _passengerAddress,
                uint256 _price
        ) external payable {

        bytes32 key = keccak256(abi.encodePacked(
            _flightKey, 
            _passengerAddress
            )); 

		Insurances[key].price=_price;
		Insurances[key].flightKey=_flightKey;
		Insurances[key].passengerAddress=_passengerAddress;
		Insurances[key].isClaimed=false;

        flights[_flightKey].isInsured=true;


        numberOfInsurances += 1;
        InsurancesList.push(key);
 	}

     function getInsurances() external view returns (bytes32[]) {
         return InsurancesList  ;
    }

    function getInsurance
                    (
                        bytes32 key
                    )
                    external
                    view                     
                    returns (uint256 ,
                                bytes32 ,
                                address ,
                                bool )
    {
        
        return  
            (
                Insurances[key].price,
                Insurances[key].flightKey,
                Insurances[key].passengerAddress,
                Insurances[key].isClaimed
            );
        // return true; 
        // return false;
    }
/* ..........................................*/
// endregion

// region ORACLE MANAGEMENT
/* ..........................................*/
    // Incremented to add pseudo-randomness at various points
    uint8 private nonce = 0;    

    // Fee to be paid when registering oracle
    uint256 public constant REGISTRATION_FEE = 1 ether;

    // Number of oracles that must respond for valid status
    uint256 private constant MIN_RESPONSES = 3;


    struct Oracle {
        bool isRegistered;
        uint8[3] indexes;        
    }

    // Track all registered oracles
    mapping(address => Oracle) private oracles;

    // Model for responses from oracles
    struct ResponseInfo {
        address requester;                              // Account that requested status
        bool isOpen;                                    // If open, oracle responses are accepted
        mapping(uint8 => address[]) responses;          // Mapping key is the status code reported
                                                        // This lets us group responses and identify
                                                        // the response that majority of the oracles
    }

    // Track all oracle responses
    // Key = hash(index, flight, timestamp)
    mapping(bytes32 => ResponseInfo) private oracleResponses;

    // Event fired each time an oracle submits a response
    event FlightStatusInfo(address airline, string flight, uint256 timestamp, uint8 status);

    event OracleReport(address airline, string flight, uint256 timestamp, uint8 status);

    // Event fired when flight status request is submitted
    // Oracles track this and if they have a matching index
    // they fetch data and submit a response
    event OracleRequest(uint8 index, address airline, string flight, uint256 timestamp);


    // Register an oracle with the contract
    function registerOracle
                            (
                            )
                            external
                            payable
    {
        // Require registration fee
        require(msg.value >= REGISTRATION_FEE, "Registration fee is required");

        uint8[3] memory indexes = generateIndexes(msg.sender);

        oracles[msg.sender] = Oracle({
                                        isRegistered: true,
                                        indexes: indexes
                                    });
    }

    function getMyIndexes
                            (
                            )
                            view
                            external
                            returns(uint8[3])
    {
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }




    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitOracleResponse
                        (
                            uint8 index,
                            address airline,
                            string flight,
                            uint256 timestamp,
                            uint8 statusCode
                        )
                        external
    {
        require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");


        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp)); 
        require(oracleResponses[key].isOpen, "Flight or timestamp do not match oracle request");

        oracleResponses[key].responses[statusCode].push(msg.sender);

        // Information isn't considered verified until at least MIN_RESPONSES
        // oracles respond with the *** same *** information
        emit OracleReport(airline, flight, timestamp, statusCode);
        if (oracleResponses[key].responses[statusCode].length >= MIN_RESPONSES) {

            emit FlightStatusInfo(airline, flight, timestamp, statusCode);

            // Handle flight status as appropriate
            processFlightStatus(airline, flight, timestamp, statusCode);
        }
    }


    function getFlightKey
                        (
                            address airline,
                            string flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    // Returns array of three non-duplicating integers from 0-9
    function generateIndexes
                            (                       
                                address account         
                            )
                            internal
                            returns(uint8[3])
    {
        uint8[3] memory indexes;
        indexes[0] = getRandomIndex(account);
        
        indexes[1] = indexes[0];
        while(indexes[1] == indexes[0]) {
            indexes[1] = getRandomIndex(account);
        }

        indexes[2] = indexes[1];
        while((indexes[2] == indexes[0]) || (indexes[2] == indexes[1])) {
            indexes[2] = getRandomIndex(account);
        }

        return indexes;
    }

    // Returns array of three non-duplicating integers from 0-9
    function getRandomIndex
                            (
                                address account
                            )
                            internal
                            returns (uint8)
    {
        uint8 maxValue = 10;

        // Pseudo random number...the incrementing nonce adds variation
        uint8 random = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - nonce++), account))) % maxValue);

        if (nonce > 250) {
            nonce = 0;  // Can only fetch blockhashes for last 256 blocks so we adapt
        }

        return random;
    }

/* ..........................................*/
// endregion

}   

contract FlightSuretyData{

    function isOperational() public view returns(bool);
        function registerAirline
                            (   
                                address _address
                            )                             
                            external;
    function getAirlinesAdresses() external view returns (address[]);
    function createAirline(address _address,string _name) external;
    function getAirline(address _address) external view returns (bool,uint256,string,address);
    function fundAirline(address _address ,uint256 fundValue) external payable;
    function getAirlineCount()  external view returns (uint256);
    function isAirline
                    (
                        address _address
                    )
                    external
                    view                     
                    returns (bool);
}