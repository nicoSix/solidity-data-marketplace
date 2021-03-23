// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;
import "./Factory.sol";


contract Auction {

    //FIELD 
    Factory factoryInstance;
    address factoryAddress;
    address addressSlaOwner;
    address winnerAuction; //ADDED ! 
    slaStates currentState; //ADDED ! 
    address[] winnersAuctionArray;

    uint timer = 10 minutes;
    uint timeAtStartContract;
    
    uint uniqueIdCounter = 0;

    
    //MAPPING
    //mapping(address => uint256) public lowestBidByAddress; //disons qu'on stockera le lowestBid pour une addresse 
                                                           // if (newBid < lowestBidByAddress[providerAddress]) { 
                                                           //     lowestBidByAddress[providerAddress] = newBid }
    //mapping(uint256 => Bid) public idToBid; 
    
    mapping (address => Bid ) public addressToBid; //map une addresse à un bid 
    address[] addressArray;                        //un [] d'addresse 
    

    //ENUM
    enum dataType {Image, Csv}
    enum algorithmType {MachineLearning, NeuralNetwork}
    enum InfrastructureType {Sgx, NoSgx}
    enum slaStates {Available, inCourse, Finished} //Available: didn't start Auction / InCourse: started Auction / Finished: Finished Auction 
    enum providerType {Dp, Ap, Ip}
    enum algorithmRequirement {isSgxCompatible, isNotSgxCompatible} //ADDED
    
    //STRUCT
    struct Bid {
        int price;
        providerType pt;
        address ownerBid;
        uint id;
    }
    
    /*
    struct ProviderData {
        
    }
        
    struct ProviderAlgorithm {
        isSgxCompatible, 
        isNotSgxCompatible
    }
    
    struct ProviderInfrastructure {
         
    }
    */

    //MODIFIER
    modifier isOwnerOfContract() {
        require(msg.sender == addressSlaOwner); //the one creating the auction instance in Factory 
        _;
    }


    constructor(dataType _dt, algorithmType _at, InfrastructureType _it, slaStates _slaS, uint _maxPrice, address addressAuction, address addressZero) public {
        
        timeAtStartContract = block.timestamp;
        addressSlaOwner = msg.sender; 
    }

    function placeBid(int _price, providerType _pt) public payable returns (bool success) { 
        
        require(block.timestamp < timeAtStartContract + timer);

        uint idBid = generateUniqueId();
            
            Bid memory firstBid = Bid(
                _price,
                _pt,
                msg.sender,
                idBid
            );
            
            //idToBid[idBid] = firstBid;
            //lowestBidByAddress[msg.sender] = idBid;
            
            addressToBid[msg.sender] = firstBid;
            addressArray.push(msg.sender);
        }
        
        
        
    function modifyBid(int _price) public payable returns (bool success) {
            
        require(block.timestamp < timeAtStartContract + timer);
        
        if (checkIfBestBid(_price)) {

            /*
            uint id = lowestBidByAddress[msg.sender];
            Bid storage lowestBidCurrent = idToBid[id];
            lowestBidCurrent.price = _price;
            */
            
            addressToBid[msg.sender].price =  _price; 
        }
    }
        
    function checkIfBestBid(int _newBid) public returns(bool) {
        
        /*
        uint id = lowestBidByAddress[msg.sender];
        uint lowestBidCurrent = idToBid[id].price;
        */
        
        int lowestBidCurrent = addressToBid[msg.sender].price;

        if (_newBid < lowestBidCurrent) {
                return true;
            }
        }
        
        
    function generateUniqueId() private returns(uint) {
        uniqueIdCounter++;
        return uniqueIdCounter;
    }
    
    
    function adjudicate() public isOwnerOfContract returns (address[] memory)  { //terminer l'enchère + set winnerAuction + transfer funds 
        
        require(block.timestamp <= timeAtStartContract + timer);
        
        address[] memory arrayWinner;
        
        currentState = slaStates.Finished; //Finish Auction
        arrayWinner = getWinner();

        
        return arrayWinner;
    }
    
    function getWinner() public returns (address[] memory) { //accéder paire gagnante 
        
    require(block.timestamp >= timeAtStartContract + timer);
    
    int currentPriceDataP = -1;
    address addressOfLowestPriceDataP;   
   
    int currentPriceAlgoP = -1;
    address addressOfLowestPriceAlgoP;   
    
    int currentPriceInfraP = -1;
    address addressOfLowestPriceInfraP;
     
    for (uint i = 0; i < addressArray.length; i++) {
        
        int price = addressToBid[addressArray[i]].price;

        if (addressToBid[addressArray[i]].pt == providerType.Dp) {
            if (price < currentPriceDataP) {
            currentPriceDataP = price; 
            addressOfLowestPriceDataP = addressArray[i];
            winnersAuctionArray.push(addressOfLowestPriceDataP);
        }
        }
        
        if (addressToBid[addressArray[i]].pt == providerType.Ap) {
            if (price < currentPriceDataP) {
            currentPriceAlgoP= price; 
            addressOfLowestPriceAlgoP = addressArray[i];
            winnersAuctionArray.push(addressOfLowestPriceAlgoP);
        }
        }
        
        if (addressToBid[addressArray[i]].pt == providerType.Ip) {
            if (price < currentPriceInfraP) {
            currentPriceInfraP= price; 
            addressOfLowestPriceInfraP = addressArray[i];
            winnersAuctionArray.push(addressOfLowestPriceInfraP);
        }
        }
    }
    return winnersAuctionArray;
    }
    
    function getBidUser(address _ownerAddress) public returns (Bid memory) {
        return addressToBid[_ownerAddress];
    }
}
