// SPDX-License-Identifier: MIT

///manages Rahat Token and projects
pragma solidity >=0.4.22 <0.9.0;

import "./SahayogiToken.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract FundRaising is AccessControl {

    event Create(
        uint256 id,
        bytes32 aidAgency,
        uint256 goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint256 id);
    event Pledge(
        //many user can pledged on same fundraise
        uint256 indexed id,
        address indexed caller,
        uint256 amount
    );
    struct RaiseFund {
        bytes32 aidAgency;
        // address creator;
        //total tokens to be collected
        uint256 goal;
        uint256 pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    //state
    SahayogiToken public erc20;
    //FRid=> RaiseFund
    uint256 public count;
    mapping(uint256 => RaiseFund) public raiseFunds;
    // RFid=>userAdd=>amount
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    constructor(SahayogiToken _erc20,address _admin) {
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        erc20 = _erc20;
       
    }
    modifier OnlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), " MUST BE ADMIN");
        _;
    }

    function create(
        bytes32 _aidAgency,
        uint256 _goal,
        uint32 _startAt,
        uint32 _endAt
    ) public OnlyAdmin {
        require(_startAt >= block.timestamp, "starting time is < now");
        require(_endAt >= _startAt, "ending time  < starting time ");
        count += 1;
        raiseFunds[count] = RaiseFund({
            aidAgency: _aidAgency, 
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Create(count,_aidAgency, _goal, _startAt, _endAt);
    }

    function cancel(uint256 _id) public OnlyAdmin {
        RaiseFund memory raiseFund = raiseFunds[_id];
        require(
            block.timestamp < raiseFund.startAt,
            "already started cant be canceled"
        );
        delete raiseFunds[_id];
        emit Cancel(_id);
    }

    function pledge(uint256 _id, uint256 _amount) external {
        RaiseFund storage raiseFund = raiseFunds[_id];
        require(block.timestamp >= raiseFund.startAt, "not started yet");
        require(block.timestamp <= raiseFund.endAt, "finished");

        raiseFund.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        erc20.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }
}
