// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.8.2;
pragma experimental ABIEncoderV2;

import "./Auction.sol";

/// @title Factory contract for Auction deployment
/// @author Andrea Perrichon-Chrétien & Nicolas Six
/// @notice Only deploy this contract once (change it when using another metadata file) - use it to deploy auctions
contract Factory { 

    uint uniqueIdCounter = 0;
    
    //ARRAY
    address[] public auctionAddresses;
    // ontologyURI is an IPFS URI
    string ontologyURI;
    mapping (uint => Auction) auctionStore;    

    event auctionCreated(address auctionContract, address owner, uint auctionID);
    
    /// @param _ontologyURI an IPFS URI to a base ontology file that describes expected requirements from the user
    /// @notice comparison between the base ontology file and expected requirements is done off-chain; the contract only stores the reference
    constructor(string memory _ontologyURI) {
        require(bytes(_ontologyURI).length == 53, "Ontology IPFS URI must be a string of length 53 (ipfs:// + 46 char hash)");
        ontologyURI = _ontologyURI;
    }

    /// @notice Creates an Auction contract and keeps + returns the address of the contract
    /// @param _maxPrice maximum price allowed for a bid
    /// @param _currency a currency sigle (eg. "EUR")
    /// @param _ipfsURI an IPFS URI to expected auction requirements
    /// @param _requirementsHash a hash of those requirements
    /// @param _duration Auction duration (in minutes)
    /// @return auctionAddress deployed Auction address
    function createAuction(uint _maxPrice, string memory _currency, string memory _ipfsURI, string memory _requirementsHash, uint _duration) public returns (address auctionAddress) {
        
        uint newId = generateUniqueId();

        Auction auctionObject = new Auction(
                _maxPrice,
                _currency,
                _ipfsURI,
                _requirementsHash,
                msg.sender,
                _duration
            );
            
        auctionStore[newId] = auctionObject; //mapping or array ? 
        auctionAddresses.push(address(auctionObject));
        emit auctionCreated(address(auctionObject), msg.sender, auctionAddresses.length); //send event
        
        return address(auctionObject);
    }
    
    function generateUniqueId() private returns(uint) {
        uniqueIdCounter++;
        return uniqueIdCounter;
    }
    
    function getAuction(uint _auctionId) public view returns (Auction) {
        //Ajouter un require
        return auctionStore[_auctionId];
    }
}
