// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//we want this contract to be able to accept some form of payment
contract FundMe{
    //we need to keep track of who sends us some funds
    //in that case we need a mapping of value to address
    mapping(address=>uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    //Constructor: function that gets called instantly when your contract gets created
    constructor() {
        owner = msg.sender;
    }

    //function that accepts some form of payment
    function fund()public payable{

        uint256 minimumUSD = 50 *10**18;
        require(getConversionRate(msg.value)>=minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        //what the ETH -> USD conversion
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer* 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*ethAmount)/1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner{
     require(msg.sender==owner);
     _;
    }
    function withdraw() payable onlyOwner public{
        //only want contract admin or owner to be able to withdraw all the funds
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex< funders.length; funderIndex++) 
        {
            addressToAmountFunded[funders[funderIndex]]=0;
        }
        funders= new address[](0);

    }

}