pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;
    
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false

    

 
    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;

        // TODO: REGISTER FIRST AIRLINE WHEN DEPLOYED
        //DONE
        // airlines[contractOwner].airlineAddress=contractOwner;
        
        airlines[contractOwner].isRegistered = true;
        airlines[contractOwner].isFunded = true;
        airlines[contractOwner].airlineName = "SAUDI AIRLINES";           
        airlines[contractOwner].airlineAddress = contractOwner;
        
        airlinesAdresses.push(contractOwner);
        
        // airlinesAdresses.push("0x18495d2af425d56005812644136bf68282188aea");
        // airlinesAdresses.push("0xc61c9dadd04970bcd7802ecebf758f87b1e35d15");
        // airlinesAdresses.push("0xa513e91f2aaa5ec9b9b4815f44494fb323ae8a08");
        // airlinesAdresses.push("0xd64f959e7f9060e034c0fc9d61c5bc0b71e0d38c");
         
         
        // We know the length of the array
        // uint cnt = airlinesAdresses.length;
        // for (uint i=0; i<cnt; i++) {
        //     airlines[airlinesAdresses[i]].isRegistered = false;
        //     airlines[airlinesAdresses[i]].isFunded = 0;
        //     airlines[airlinesAdresses[i]].airlineName = "Airline-" ;        
        //     airlines[airlinesAdresses[i]].airlineAddress = airlinesAdresses[i];
        // }
    
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
        require(operational, "Contract is currently not operational");
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

    modifier requireIsFunded(address _address) {
        require(airlines[_address].isFunded , "Airline should be funded");
        _;
    }
    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/
    /**
    * @dev Authorize address
    *
    */      
    function authorizeCaller(
        address flightSuretyAppAddress
    ) 
                            public 
                             
    {
        //TODO: ADD ADDRESS TO ARRAY
    }


    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

 /* -----------Airline--------------- */
    struct Airline {
        bool isRegistered;
        bool isFunded;
        string airlineName;                 
        address airlineAddress;
    }
    mapping(address => Airline) public airlines;

    address[] airlinesAdresses;

    function createAirline
                            (  
                                address _address ,
                                string _name 
                            )
                            external                              
    {
        airlines[_address].isRegistered = false;
        airlines[_address].isFunded = true;
        airlines[_address].airlineName =_name;           
        airlines[_address].airlineAddress=_address;
        
        airlinesAdresses.push(_address);
    }
   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline
                            (   
                                address _address
                            )
                            external
                             
                            
    { 
        airlines[_address].isRegistered = true;
     }

     /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function fundAirline
                            (   
                                address _address
                            )
                            external                             
                            
    { 
        airlines[_address].isFunded = true;
     }


    function getAirlinesAdresses() external view returns (address[]) {
         return airlinesAdresses;
    }

    function isAirline
                    (
                        address _address
                    )
                    external
                    view                     
                    // returns (bool,uint256,address)
                    returns (bool)
    {
        // airlines[airlineAddress].isRegistered = true;
        // airlines[airlineAddress].isFunded = 10;
        // airlines[airlineAddress].isRegistered = true;
        return airlines[_address].isRegistered;
        // return (
            // airlines[airlineAddress].isRegistered,
        //     testme,
        //     airlines[airlineAddress].isFunded,
        //     airlineAddress
        // );
        // return true; 
        // return false;
    }

    function getAirline
                    (
                        address _address
                    )
                    external
                    view                     
                    // returns (bool,uint256,string,address)
                    returns (bool,bool,string,address)
    {
        // airlines[airlineAddress].isRegistered = true;
        // airlines[airlineAddress].isFunded = 10;
        // airlines[airlineAddress].isRegistered = true;
        // return airlines[airlineAddress].isRegistered;
        return  
            (
                airlines[_address].isRegistered,
                airlines[_address].isFunded,
                airlines[_address].airlineName,                
                airlines[_address].airlineAddress
            );
        // return true; 
        // return false;
    }
   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (                             
                            )
                            external
                            payable
    {

    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                )
                                external
                                pure
    {
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            pure
    {
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund
                            (  

                            )
                            public
                            payable
    {
    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function() 
                            external 
                            payable 
    {
        fund();
    }


}


