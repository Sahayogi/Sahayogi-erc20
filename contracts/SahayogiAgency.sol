// SPDX-License-Identifier: MIT

///manages Rahat Token and projects
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "./SahayogiAdmin.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SahayogiAgency is AccessControl {
  bytes32 public constant AGENCY_ROLE = keccak256("AGENCY");

   event Create(
       uint256 id,
       string projectName,
       uint256 totalFunds
   );
   event Update (
       uint256 id,
       uint256 totalFunds
   );

    struct Project {
        // address agencyAddress;
        string  projectName;
        // address[] vendor;
        uint256 totalFunds;
        // bytes32 merkleRoot;
        bool running;

    }
    //id=>Project
    mapping(uint256 => Project) public projects;
    uint256 public count;
    address public Bank;
    
    //calling admin contract 
    FundRaising public FundRaisingContract;

    modifier OnlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), " MUST BE ADMIN");
        _;
    }
     modifier OnlyAgency() {
        require(hasRole(AGENCY_ROLE, msg.sender), " MUST BE AGENCY");
        _;
    }
    constructor(address _FundRaisingContract, address _admin){
        Bank = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
        FundRaisingContract =  FundRaising(_FundRaisingContract); 
        _setupRole(DEFAULT_ADMIN_ROLE,_admin);
        _setRoleAdmin(AGENCY_ROLE, DEFAULT_ADMIN_ROLE);
         grantRole(AGENCY_ROLE, msg.sender);     
    }
      //add aidAgency 
    function addAgency(address _account) public OnlyAdmin {
        grantRole(AGENCY_ROLE, _account);
    }

    //project List
    //check if project exist or not
    //assign budgets to project
   
    //merkle distributor implementaion
    //diff merkle for different projects
    //after funding ends fund nikalnu

    //FUNCTIONS
       function createProject(
      // address[] _vendor,
        uint256 _totalFunds,
         string calldata _projectName
    ) public OnlyAgency {
        count += 1;
        projects[count] = Project({
            totalFunds:_totalFunds,
             projectName:_projectName,
             running: true
        });
        emit Create(count, _projectName, _totalFunds);
    }

    function updateFund( uint256 _id,uint256 _amount) public OnlyAgency {
     Project storage project = projects[_id];
     require(project.running,"Project is not available");
     project.totalFunds += _amount;
     emit Update(_id,_amount);
    }
   
    function claimFunds(uint256 _id) public OnlyAgency {
    // RaiseFund storage raiseFund = raiseFunds[_id];
    


    }
}
