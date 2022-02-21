// SPDX-License-Identifier: MIT

///manages Rahat Token and projects
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SahayogiAgency is AccessControl {

    //project List
    //check if project exist or not
    //assign budgets to project
    bytes32[] public projectId;
    mapping(bytes32 => bool) public projectAvailable;
    mapping(bytes32 => uint256) public projectToken;

    //FUNCTIONS
    function addBeneficiary() public {}

    function addVendor() public {}

    function addProject() public {}

    function addBank() public {}
}
