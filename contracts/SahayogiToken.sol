// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SahayogiToken is ERC20{
    address public admin;
    constructor() ERC20("SahayogiToken", "SYT") {
        _mint(msg.sender, 1000000*10**18);
        admin = msg.sender;
    }
    
    function mint(address to, uint amount) external {
        require(msg.sender == admin,"Only to admin");
        _mint(to,amount);
    }
    
    

}