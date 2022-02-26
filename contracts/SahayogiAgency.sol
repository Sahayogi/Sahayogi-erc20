// SPDX-License-Identifier: MIT
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
        string  projectName;
        // address[] vendor;
        uint256 initialFund;
        uint256 totalFunds;
        // bytes32 merkleRoot;
        bool running;
    }

    //id=>Project
    mapping(uint256 => Project) public projects;
    
    //calling admin contract 
    FundRaising public FundRaisingContract;

    uint256 public count;
    address public bank;

    SahayogiToken public erc20;
    
    constructor(SahayogiToken _erc20, address _FundRaisingContract, address _admin){
        bank = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
        FundRaisingContract =  FundRaising(_FundRaisingContract); 
       
        _setupRole(DEFAULT_ADMIN_ROLE,_admin);
        _setRoleAdmin(AGENCY_ROLE, DEFAULT_ADMIN_ROLE);
         grantRole(AGENCY_ROLE, msg.sender);   

         erc20 = _erc20;  
    }

    modifier OnlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "SAHAYOGI: MUST BE ADMIN");
        _;
    }
     modifier OnlyAgency() {
        require(hasRole(AGENCY_ROLE, msg.sender), "SAHAYOGI: MUST BE AGENCY");
        _;
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
    function claimFunds(uint256 _id) public OnlyAgency {
    //  FundRaisingContract.raiseFunds[_id];
    }
    function createProject(
      // address[] _vendor,
        string calldata _projectName,
        uint256 _totalFunds
    ) public OnlyAgency {
        count += 1;
        projects[count] = Project({
            projectName:_projectName,
            initialFund:0,
            totalFunds:_totalFunds,
            running: true
        });
        emit Create(count, _projectName, _totalFunds);
    }
    //project id=>amount
    mapping(uint256=>uint256) public fundedAmount;
    function updateFund( uint256 _id,uint256 _amount) public OnlyAgency {
     Project storage project = projects[_id];
     require(project.running,"Project is not available");
     project.initialFund += _amount;
     fundedAmount[_id] += _amount;
     erc20.transfer(address(this),_amount);

     emit Update(_id,_amount);
    }
   
  
}
