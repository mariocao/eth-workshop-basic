pragma solidity ^0.4.18;

contract HelloWorld {

    //state variable we assigned earlier
    uint256 counter = 5;

    //increases counter by 1
    function add() public {  
        counter++;
    }

    //decreases counter by 1
    function subtract() public {
        counter--;
    }

    //read the counter
    function read() public constant returns (uint256) {
        return counter;
    }
}