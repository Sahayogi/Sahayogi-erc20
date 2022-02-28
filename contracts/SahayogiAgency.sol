// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "./SahayogiAdmin.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IMerkleDistributor.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SahayogiAgency is AccessControl, IMerkleDistributor {

  bytes32 public constant AGENCY_ROLE = keccak256("AGENCY");

   event Create(
       uint256 projectId,
       string projectName
    //    uint256 totalFunds
   );
   event Update (
       uint256 projectId,
       uint256 totalFunds
   );

    struct Project {
        
        string  projectName;
        // address[] vendor;
        // uint256 initialFund;
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
    //address of token 
    SahayogiToken public erc20;
    
    constructor(
        SahayogiToken _erc20, 
        address _FundRaisingContract, 
        address _admin
        ){
        bank = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
        FundRaisingContract =  FundRaising(_FundRaisingContract); 
        _setupRole(DEFAULT_ADMIN_ROLE,_admin);  

   erc20 = _erc20;  
    }
    //     constructor(
    //     bytes32 _merkleRoot,
    //     address _contract, 
    //     address _tokenAddress
    // ) {
    //     merkleRoot = _merkleRoot;
    //     token = _tokenAddress;
    //     // _transferOwnership(_contract);
    // }
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
    function createProject(
      // address[] _vendor,
        string calldata _projectName
        // uint256 _totalFunds
    ) public OnlyAgency {
        count += 1;
        projects[count] = Project({
            projectName:_projectName,
            totalFunds:0,
            // totalFunds:_totalFunds,
            running: true
        });
        emit Create(count, _projectName);
    }
    //project id=>amount
    mapping(uint256=>uint256) public fundedAmount;
    function updateFund( uint256 _projectId,uint256 _amount) public OnlyAgency {
     Project storage project = projects[_projectId];
     require(project.running,"Project is not available"); 
     project.totalFunds += _amount;
     fundedAmount[_projectId] += _amount;
     erc20.transferFrom(msg.sender,address(this),_amount);

     emit Update(_projectId,_amount);
    }
    
    function claimFunds(uint256 _id, uint256 _projectId) public OnlyAgency {
    Project storage project = projects[_projectId];
     require(project.running,"Project is not available");
         return FundRaisingContract.claim(_id,_projectId);
     }


   //MERKLEDISTRIBUTOR


    // bytes32 public override merkleRoot;
    // address of token 
    address public immutable override token;
    // This is a packed array of booleans for verifying the claims.
    // mapping(uint256 => uint256) private claimedBitMap;
      //projectid=>merkle root 
    mapping(uint256 => bytes32) public merkleRoot;
    // This is a packed array of booleans for verifying the claims.
    mapping(uint256 =>mapping(uint256 => uint256)) private claimedBitMap;



    ///@dev set claim for the given index
    function _setClaimed(uint256 index) internal {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    ///@dev called by the user to claim the token
    ///@param index sequential index 
    ///@param account account of the claim address
    ///@param amount amount of claim 
    ///@param merkleProof merkleProof for the claim of the account
    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');

        // Mark it claimed and send the token.
        _setClaimed(index);
        IERC20(token).transfer(account, amount);

        emit Claimed(index, account, amount);
    }

    ///@dev look if already claimed or not for the index
    ///@param index index of the token
    function isClaimed(uint256 index) public view override returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    // ///@dev update merkle root 
    // ///@param _newMerkleRoot new merkle root for the distribution
    // function updateMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner{
    //     merkleRoot = _newMerkleRoot;
    // }

    ///@dev called by the owner of the contract to rescue the token from the contract
    ///@param amount amount of token to withdraw
    function withdrawToken(uint256 amount) external {
        IERC20(token).transfer(msg.sender, amount);
    }
   
  
}
