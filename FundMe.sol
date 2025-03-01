// OBJECTIVES

// get funds from users 
// Withdraw funds
// set a minimum funding value in USD 

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUSD = 5 * (10 ** 18);
    // update since getConversionRate returns number with 18 decimal places 
    // other options: 5e18 or 5 * 1e18
    
    function fund() public payable{ 
        // payable keyword is necessary for the 
        // function to hold/interact with funds 

        //require(msg.value > 1e18); // requires user to spend at least 1 ETH
        // msg.value = numbe of wei sent with the message 

        //require(msg.value > 1e18, "not enough ETH");
        // "require" requires user to what is in the parentheses; 
        // it also works like a if/else statement: if it said 
        // require(msg.value > 1e18, "not enough ETH") and the 
        // user entered more than 1 ETH, the first part would apply/continue
        // if the user failed the condition, the second part would continue, meamimg "not enough ETH" print
        // if the condition is not fulfilled: this is also known as a revert
        // revert undos any actions that have been dione, and send the remaining gas back
        
        // 1e18 = 1 ETH casue 1 ETH = 1 * 10 ** 18 Wei 
        // in solidity ** means to the power 


        require(getConversionRate(msg.value) >= minimumUSD, "not enough ETH");


    }

    // function withdraw() public {

    // }

    function getPrice() public view returns(uint256){
        address chainLinkAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306; 
        // address of decentralized network that submits ETH/USD price

        AggregatorV3Interface priceFeed = AggregatorV3Interface(chainLinkAddress);
        (uint80 roundID, int256 price, uint256 startedAt, uint256 timestamp, uint80 answeredInRound) = priceFeed.latestRoundData();
        // since we only care about price we could also do:
        // (,int256 price,,,) = priceFeed.latestRoundData();
        return uint(price * 1e10);
        // need to typecast because the types are different
        // price is a int256 while msg.value is uint256

        // need to multiply by 1e10 because the return values 
        // is going to have 8 decimal places while 
        // msg.value is going to have 18
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        // devide by 1e18 necessary since both numbers are in 1e18
        // and 1e18 * 1e18 = 1e36; also, in Solidity always first 
        // multiply and then divide 

        return ethAmountInUSD;
    }
}