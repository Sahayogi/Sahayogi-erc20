// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Sahayogi is AccessControl {
    using SafeMath for uint256;
    //events
    // event ClaimedToken();
    // event ClaimApproved();
    // event IssuedToken(
    //     bytes32 indexed projectId,
    //     bytes32 indexed email,
    //     uint256 amount
    // );
    // event claimAcquiredToken();

    //ROLES
    bytes32 public constant AGENCY_ROLE = keccak256("AGENCY");
    bytes32 public constant VENDOR_ROLE = keccak256("VENDOR");
    bytes32 public constant CREATE_CLAIM = keccak256("createClaim");

    struct claim {
        uint256 amount;
        bytes32 code;
        bool isReleased;
        uint256 date;
    }
    //vendor=> email => claim
    mapping(address => mapping(bytes32 => claim)) public recentTokenClaims;
    
    
    //STATE
    SahayogiToken public erc20;


    //track total tokens of each bene
    mapping(bytes32=>uint256) public erc20Issued;


    //track balance of each bene
    //email=>balance
    mapping(bytes32=>uint256)public erc20Balance;



    //track project tokens
    // bytes32[] public projectId;
    // mapping()
   
    //CONSTRUCTOR
    constructor(SahayogiToken _erc20, address _admin) {
        _setupRole(DEFAULT_ADMIN_ROLE, tx.origin);
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setRoleAdmin(AGENCY_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(VENDOR_ROLE, DEFAULT_ADMIN_ROLE);
        grantRole(AGENCY_ROLE, msg.sender);
        erc20 = _erc20;
    }

    //MODIFIERS
    modifier OnlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), " MUST BE ADMIN");
        _;
    }

    modifier OnlyAgency() {
        require(hasRole(AGENCY_ROLE, msg.sender), "MUST BE AGENCY");
        _;
    }
     //FUNCTIONS
    //access control management
    function addVendor(address _account) public OnlyAgency {
        grantRole(VENDOR_ROLE, _account);
    }


    //create project 
    //called by aidagency 
    function addProjects(bytes32 _projectId, uint256 _projectBudget) external{
        // projectId.add(_projectId);
    } 

}
