// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Exchange {
    using SafeMath for uint256;
    SahayogiToken public erc20;
    uint256 public rate = 1 ether;

    constructor(SahayogiToken _erc20) {
        erc20 = _erc20;
    }

    //adding fallback function

    //give ether => get token
    function getTokens() public payable {
        //calculate num of tokens
        uint256 tokenAmount = msg.value / rate;
        //reuire that exchange has enough tokens
        require(
            erc20.balanceOf(address(this)) >= tokenAmount,
            "doesnot have enough tokens to exchange"
        );
        //transfer tokens to users
        erc20.transfer(msg.sender, tokenAmount);
    }

    // amount
    //give token=> get ether
    function getEther(uint256 _amount) public {
        require(
            erc20.balanceOf(msg.sender) >= _amount,
            "doesnot have sufficient token to exchange it "
        );
        //calculate amount of ether
        uint256 etherAmount = _amount * rate;
        //must have enough ether
        require(
            address(this).balance >= etherAmount,
            "doesnot have enough ether"
        );
        erc20.transferFrom(msg.sender, address(this), _amount);
        //sends ether to person calling this func
        payable(msg.sender).transfer(etherAmount);
    }
}
