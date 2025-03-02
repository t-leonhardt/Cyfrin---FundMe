pragma solidity ^0.8.16;

contract FallbackExample{
    uint256 public result;

    receive() external payable{
        // receive is a special function that does not require
        // the "function" keyword 
        // this function gets triggered when there is a transaction
        // to this contract as long as ther is no data associated with it 

        result = 1; 

    }

    fallback() external payable{
        // works the same as receive with the only difference
        // that it also works with data
    }

    // if an external account sends funds by not using the functions 
    // we specifically implemented, it automatically calls "receive"; however,
    // only if there is no data associated with the transaction. If data is 
    // associated with the transaction, it looks for a another function than receive
    // This is where fallback comes into play. if reeive does not work, fallback is 
    // automatically called 
    // 
}