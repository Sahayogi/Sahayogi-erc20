// SPDX-License-Identifier: MIT

///manages Rahat Token and projects
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SahayogiAgency is AccessControl {
    struct Project {
        uint256 id;
        bool running;
        uint256 totalFunds;
        bytes32 merkleRoot;
    }

    address public bank;

    // @var : array, holds all running project id
    address[] runningProjectsId;

    //project List
    //check if project exist or not
    //assign budgets to project
    // @mapping: maps, id=>project
    mapping(uint256 => bool) public projectAvilable;
    mapping(bytes32 => uint256) public projectToken;

    //merkle distributor implementaion
    //diff merkle for diffect projects
    //after funding ends fund nikalnu

    //FUNCTIONS
    function addBeneficiary() public {}

    function addVendor() public {}

    function addProject() public {}

    // function addBank() public {}
    function claimAid() public {}

    function claimFunds() public {}
}
