// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.8.2;
pragma experimental ABIEncoderV2;

import "./Auction.sol";

//Factory est un répertoire contenant toutes les Auction ==> de manière à pouvoir y accéder plus tard 
contract Factory { 

    uint uniqueIdCounter = 0;
    
    //ARRAY
    address[] public auctionAddresses;
    // ontologyURI is an IPFS URI
    string ontologyURI;
    mapping (uint => Auction) auctionStore;    

    event auctionCreated(address auctionContract, address owner, uint auctionID);
    
    
    constructor(string memory _ontologyURI) public {
        require(bytes(_ontologyURI).length == 53, "Ontology IPFS URI must be a string of length 53 (ipfs:// + 46 char hash)");
        ontologyURI = _ontologyURI;
    }

    
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
