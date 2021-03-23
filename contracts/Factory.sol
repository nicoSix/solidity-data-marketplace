// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "./Auction.sol";

//Factory est un répertoire contenant toutes les Auction ==> de manière à pouvoir y accéder plus tard 

contract Factory { 

    uint uniqueIdCounter = 0;
    
    //ARRAY
    address[] public slaArray;

    mapping (uint => Auction) slaStore;    

    event slaCreated(address auctionContract, address owner, uint numberSLA, address[] addressSLA);
    
    
    constructor() public {
        
    }

    
    function createAuction(Auction.dataType _td, Auction.algorithmType _at, Auction.InfrastructureType _it, uint _maxPrice) public returns (address slaAddress) {
        
        uint newId = generateUniqueId();

        Auction auctionObject = new Auction(
                _td,
                _at,
                _it,
                Auction.slaStates.Available,
                _maxPrice,
                address(this),
                address(0)
            );
            
        slaStore[newId] = auctionObject; //mapping or array ? 
        slaArray.push(address(auctionObject));
        emit slaCreated(address(auctionObject), msg.sender, slaArray.length, slaArray); //send event
        
        return address(auctionObject);
    }
    
    
    
    function generateUniqueId() private returns(uint) {
        uniqueIdCounter++;
        return uniqueIdCounter;
    }
    
    function getSLA(uint _slaId) public view returns (Auction) {
        //Ajouter un require
        return slaStore[_slaId];
    }
}
