/**
 *Submitted for verification at snowtrace.io on 2021-11-29
*/

// File contracts/types/Ownable.sol

pragma solidity 0.7.5;

contract Ownable {

    address public policy;

    constructor () {
        policy = msg.sender;
    }

    modifier onlyPolicy() {
        require( policy == msg.sender, "Ownable: caller is not the owner" );
        _;
    }
    
    function transferManagment(address _newOwner) external onlyPolicy() {
        require( _newOwner != address(0) );
        policy = _newOwner;
    }
}


// File contracts/SnowbankProMaxFactoryStorage.sol

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

contract SnowbankProMaxFactoryStorage is Ownable {
    
    /* ======== STRUCTS ======== */

    struct BondDetails {
        address _principalToken;
        address _treasuryAddress;
        address _bondAddress;
        address _initialOwner;
        uint[] _tierCeilings;
        uint[] _fees;
    }
    
    /* ======== STATE VARIABLS ======== */
    BondDetails[] public bondDetails;

    address public snowbankProMaxFactory;

    mapping(address => uint) public indexOfBond;

    /* ======== EVENTS ======== */

    event BondCreation(address treasury, address bond, address _initialOwner);
    
    /* ======== POLICY FUNCTIONS ======== */
    
    /**
        @notice pushes bond details to array
        @param _principalToken address
        @param _customTreasury address
        @param _customBond address
        @param _initialOwner address
        @param _tierCeilings uint[]
        @param _fees uint[]
        @return _treasury address
        @return _bond address
     */
    function pushBond(address _principalToken, address _customTreasury, address _customBond, address _initialOwner, uint[] calldata _tierCeilings, uint[] calldata _fees) external returns(address _treasury, address _bond) {
        require(snowbankProMaxFactory == msg.sender, "Not Snowbank Pro Max Factory");

        indexOfBond[_customBond] = bondDetails.length;
        
        bondDetails.push( BondDetails({
            _principalToken: _principalToken,
            _treasuryAddress: _customTreasury,
            _bondAddress: _customBond,
            _initialOwner: _initialOwner,
            _tierCeilings: _tierCeilings,
            _fees: _fees
        }));

        emit BondCreation(_customTreasury, _customBond, _initialOwner);
        return( _customTreasury, _customBond );
    }

    /**
        @notice changes snowbank pro factory address
        @param _factory address
     */
    function setFactoryAddress(address _factory) external onlyPolicy() {
        snowbankProMaxFactory = _factory;
    }
    
}