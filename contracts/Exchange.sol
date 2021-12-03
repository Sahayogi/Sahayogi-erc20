// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";

contract ExchangeEthForSahayogiToken {

    SahayogiToken public sahayogitoken;
    uint public rate = 1;

    constructor(SahayogiToken _sahayogitoken) public {
        sahayogitoken = _sahayogitoken;
    }

    //adding fallback function 
    function getTokensAmount() public payable{

        //calculate num of tokens 
        uint tokenAmount = msg.value*rate;
        //reuire that exchange has enough tokens
        require(sahayogitoken.balanceOf(address(this))>=tokenAmount,"doesnot have enough tokens to exchange");
        //transfer tokens to users  
        sahayogitoken.transfer(msg.sender, tokenAmount);
    }

}
