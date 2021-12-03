// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";

contract ExchangeEthForSahayogiToken {
    SahayogiToken public sahayogitoken;
    uint256 public rate = 1;

    constructor(SahayogiToken _sahayogitoken) public {
        sahayogitoken = _sahayogitoken;
    }

    //adding fallback function

    //give ether => get token
    function getTokens() public payable {
        //calculate num of tokens
        uint256 tokenAmount = (msg.value / (10**18)) * rate;
        //reuire that exchange has enough tokens
        require(
            sahayogitoken.balanceOf(address(this)) >= tokenAmount,
            "doesnot have enough tokens to exchange"
        );
        //transfer tokens to users
        sahayogitoken.transfer(msg.sender, tokenAmount);
    }
    // amount 
    //give token=> get ether
    function getEther(uint256 _amount) public {
        require(sahayogitoken.balanceOf(msg.sender) >= _amount,"doesnot have sufficient token to exchange");
        //calculate amount of ether
        uint256 etherAmount = _amount / rate;
        //must have enough ether
        require(
            address(this).balance >= etherAmount,
            "doesnot have enough ether"
        );
        sahayogitoken.transferFrom(msg.sender, address(this), _amount);
        //sends ether to person calling this func
        msg.sender.transfer(etherAmount);
    }
}
