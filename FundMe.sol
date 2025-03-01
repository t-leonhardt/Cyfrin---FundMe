// OBJECTIVES

// get funds from users 
// Withdraw funds
// set a minimum funding value in USD 

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

contract FundMe {

    uint256 public minimumUSD = 5;
    
    function fund() public payable{ 
        // payable keyword is necessary for the 
        // function to hold/interact with funds 

        //require(msg.value > 1e18); // requires user to spend at least 1 ETH
        // msg.value = numbe of wei sent with the message 

        require(msg.value > 1e18, "not enough ETH");
        // "require" requires user to what is in the parentheses; 
        // it also works like a if/else statement: if it said 
        // require(msg.value > 1e18, "not enough ETH") and the 
        // user entered more than 1 ETH, the first part would apply/continue
        // if the user failed the condition, the second part would continue, meamimg "not enough ETH" print
        // if the condition is not fulfilled: this is also known as a revert
        // revert undos any actions that have been dione, and send the remaining gas back
        
        // 1e18 = 1 ETH casue 1 ETH = 1 * 10 ** 18 Wei 
        // in solidity ** means to the power 
    }

    function withdraw() public {

    }
}