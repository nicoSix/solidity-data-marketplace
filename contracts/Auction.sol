// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.8.2;
pragma experimental ABIEncoderV2;
import "./Factory.sol";

/// @title Auction contract for a specific user request
/// @author Nicolas Six & Andrea Perrichon-Chrétien
/// @notice Contract only deployed by the corresponding Factory
contract Auction {

    // FIELDS
    address factoryAddress;
    address auctionOwner;
    AuctionStatus currentState;
    uint duration;
    uint timeAtStartContract;
    uint maxPrice;
    uint uniqueIdCounter = 0;
    string requirementsURI; // Requirements URI is an IPFS URI
    string requirementsHash;
    string currency; 
    Winners winners;

    // ARRAYS MAPPINGS
    mapping (address => Bid ) addressToBid; 
    mapping (uint => address[]) assetToProviders;//Enum is converted to uint as Enum cannot be used as key
    BidHistoryPoint[] bidHistory;
    
    // ENUM
    enum AuctionStatus {Available, inCourse, Finished}
    enum ProviderAsset {Data, Algorithm, Infrastructure}
    
    // STRUCT DEFINITION
    struct Bid {
        uint price;
        ProviderAsset asset;
        address ownerBid;
        uint id;
        bool exists;
    }
    
    struct BidHistoryPoint {
        uint price;
        ProviderAsset asset;
        address ownerBid;
    }
    
    struct Winners {
        address dataWinner;
        address infrastructureWinner;
        address algorithmWinner;
        uint infrastructurePrice;
        uint dataPrice;
        uint algorithmPrice;
    }

    // MODIFIERS
    modifier isOwnerOfContract() {
        require(msg.sender == auctionOwner, "msg.sender not owner of contract."); //the one creating the auction instance in Factory 
        _;
    }
    
    modifier notFinished() {
        require(block.timestamp < timeAtStartContract + duration, "Auction is finished (timeout).");
        require(currentState != AuctionStatus.Finished, "Auction is finished.");
        _;
    }

    /// @notice Creates an Auction contract with default values, explained here
    /// @param _maxPrice maximum price allowed for a bid
    /// @param _currency a currency sigle (eg. "EUR")
    /// @param _requirementsURI an IPFS URI to expected auction requirements
    /// @param _requirementsHash a hash of those requirements
    /// @param _auctionOwner the owner of this auction (able to adjudicate)
    /// @param _duration Auction duration (in minutes)
    constructor(uint _maxPrice, string memory _currency, string memory _requirementsURI, string memory _requirementsHash, address _auctionOwner, uint _duration) public {
        require(bytes(_requirementsURI).length == 53, "IPFS URI must be a string of length 53 (ipfs:// + 46 char hash)");
        require(bytes(_requirementsHash).length == 64, "Requirements hash must be a string of length 64 (kekkak256(str))");
        timeAtStartContract = block.timestamp;
        factoryAddress = msg.sender; 
        auctionOwner = _auctionOwner;
        duration = _duration * 1 minutes;
        currency = _currency;
        maxPrice = _maxPrice;
        requirementsURI = _requirementsURI;
        requirementsHash = _requirementsHash;
    }

    /// @notice Place a new bid from a provider, if it does not exist yet, and stores references to the bid
    /// @param _price bid price
    /// @param _pa which asset is proposed by the provider. 3 possibilities defined in the corresponding enum.
    function placeBid(uint _price, ProviderAsset _pa) public notFinished { 
        require (!addressToBid[msg.sender].exists, "Bid already exists.");
        uint pId = uint(_pa);
        if(assetToProviders[pId].length > 0) {
            (,uint lowestBid) = getAssetWinner(_pa);
            require(lowestBid > _price, "A better bid already exists.");
        }
        uint idBid = generateUniqueId();
        Bid memory firstBid = Bid(
            _price,
            _pa,
            msg.sender,
            idBid,
            true
        );
        addressToBid[msg.sender] = firstBid;
        assetToProviders[pId].push(msg.sender);
        bidHistory.push(BidHistoryPoint(_price, _pa, msg.sender));
    }
        
    function modifyBid(uint _price) public notFinished {
        Bid storage bid = addressToBid[msg.sender];
        (address lowestAddress, uint lowestBid) = getAssetWinner(bid.asset);
        if (lowestAddress != msg.sender || lowestBid > _price) {
            bid.price = _price;
            bidHistory.push(BidHistoryPoint(_price, bid.asset, msg.sender));
        }
    }

    /// @notice Computes the current for a specific asset, revert if there is no bidding yet.
    /// @param _pa the asset in question    
    function getAssetWinner(ProviderAsset _pa) public view returns(address, uint) {
        uint lowestBid;
        uint pId = uint(_pa);
        address lowestAddress;
        
        require(assetToProviders[pId].length > 0, "No providers yet for provided data type.");
        lowestBid = addressToBid[assetToProviders[pId][0]].price;
        lowestAddress = addressToBid[assetToProviders[pId][0]].ownerBid;
        for (uint i = 0; i < assetToProviders[pId].length; i++) {
            Bid memory _bid = addressToBid[assetToProviders[pId][i]];
            if(_bid.price < lowestBid) {
                lowestBid = _bid.price;
                lowestAddress = _bid.ownerBid;
            }
        }
            
        return (lowestAddress, lowestBid);
    }
        
        
    function generateUniqueId() private returns(uint) {
        uniqueIdCounter++;
        return uniqueIdCounter;
    }
    
    function getCurrentWinners() public view returns(Winners memory) {
        (address dataWinner, uint dataPrice) = getAssetWinner(ProviderAsset.Data);
        (address infrastructureWinner, uint infrastructurePrice) = getAssetWinner(ProviderAsset.Infrastructure);
        (address algorithmWinner, uint algorithmPrice) = getAssetWinner(ProviderAsset.Algorithm);
        
        Winners memory currentWinners = Winners(
            dataWinner,
            infrastructureWinner,
            algorithmWinner,
            dataPrice,
            infrastructurePrice,
            algorithmPrice
        );
        
        return currentWinners;
    }
    
    /// @notice this function adjudicates the auction. Only possible if auction duration has elapsed.
    /// @return Winners of the auction, as a struct
    function adjudicate() public isOwnerOfContract returns (Winners memory) { //terminer l'enchère + set winnerAuction + transfer funds 
        require(currentState != AuctionStatus.Finished, "Auction is already finished.");
        //require(block.timestamp > timeAtStartContract + duration, "Adjudication cannot be performed yet (no timeout).");
        currentState = AuctionStatus.Finished; //Finish Auction
        Winners memory finalWinners = getCurrentWinners();
        winners = finalWinners;
        return finalWinners;
    }

    // GETTERS
    
    function getBidUser(address _ownerAddress) public view returns (Bid memory) {
        return addressToBid[_ownerAddress];
    }
    
    function getBidHistory() public view returns (BidHistoryPoint[] memory) {
        return bidHistory;
    }
    
    function getAuctionOwner() public view returns(address) {
        return auctionOwner;
    }
    
    function getFactoryAddress() public view returns(address) {
        return factoryAddress;
    }
}

