// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SahayogiToken is ERC20, AccessControl {
    modifier OnlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), " MUST BE ADMIN");
        _;
    }
    //admin is the owner of erc20 contract
    constructor(address _admin) ERC20("SahayogiToken", "SYT") {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _mint(msg.sender,1000000);

    }
        function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    //minting
    function mint(address _to, uint256 _amount) public OnlyAdmin {
        _mint(_to, _amount);
    }
 
}
