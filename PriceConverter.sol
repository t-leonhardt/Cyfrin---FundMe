pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice() internal view returns(uint256){
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

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        // devide by 1e18 necessary since both numbers are in 1e18
        // and 1e18 * 1e18 = 1e36; also, in Solidity always first 
        // multiply and then divide 

        return ethAmountInUSD;
    }
}