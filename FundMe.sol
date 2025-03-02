// OBJECTIVES

// get funds from users 
// Withdraw funds
// set a minimum funding value in USD 

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * (10 ** 18);
    // update since getConversionRate returns number with 18 decimal places 
    // other options: 5e18 or 5 * 1e18
    // convention for constant variables is all caps 
    // using constant variables saves gas

    address[] public funders;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    // does not need the words "funder" and "amountFunded", it could just be:
    // mapping (address => uint256) public addressToAmountFunded; however,
    // this makes it easier to read
    
    address public immutable i_owner;
    // convention for immutable variables is using i_ at the beginning 
    // to signalize that they are immutable 
    // using immutable saves gas 

    constructor(){
        i_owner = msg.sender;
    }

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


        require(msg.value.getConversionRate() >= MINIMUM_USD, "not enough ETH");
        funders.push(msg.sender);
        // msg.sender is whoever called the function/transaction

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

    }

    function withdraw() public onlyOwner {
        // onlyOwner is a modifier
        //require(msg.sender == owner, "Must be owner");
        // not ncessary when using modifiers; see below this function 

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        // resetting list


        // transfer
        payable(msg.sender).transfer(address(this).balance);
        // msg.sender is of type "address"
        // payable(msg.sender) is of type payable address 
        // "this" refers to the entire contract 
        // to send tokens in Solidity, only payable addresses can be used 
        // if "transfer" fails, throws an error and reverts transaction

        // send 
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // if "send" fails, returns a boolean
        require(sendSuccess, "Send failed");
        // without "require", "send" would not revert the transaction 

        // call 
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        // call allows us to call functions --> if these functions return data, we need to store that data
        // such data is going to be stored in dataReturned; dataReturned is therefore an array
        // and requires memory as a keyword
        // callSuccess is automatically returned; if the functions was successfully called = true 
        // since we do not call a function in this example, we could also use:
        // (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // modifiers permit the creation of keywords for function declerations
    modifier onlyOwner {
        require(msg.sender == i_owner, "Must be owner");
        _;
        // first onlyOwner is called when the original function is called, 
        // and the the _; means that the original function can execute 
        // whatever is left in its body 
        // ORDER matters: if reversed, it would execute the function first 
        // and then check is user has permission 
    }

    receive(){
        fund();
    }

    fallback(){
        fund();
    }

    // if user fails to use fund(), for example by using "call"
    // using their wallet, it is re-driected to fund() anyways
}