// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleCrowdfunding {
    address public owner;
    uint public fundingGoal;
    uint public deadline;
    uint public totalRaised;
    bool public withdrawn;

    mapping(address => uint) public contributions;

    constructor(uint _goalInWei, uint _durationInSeconds) {
        owner = msg.sender;
        fundingGoal = _goalInWei;
        deadline = block.timestamp + _durationInSeconds;
        withdrawn = false;
    }

    // Contribute to the crowdfunding campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Must send some Ether");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    // Withdraw funds if goal is met after deadline
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Deadline not reached");
        require(totalRaised >= fundingGoal, "Goal not reached");
        require(!withdrawn, "Funds already withdrawn");

        withdrawn = true;
        payable(owner).transfer(address(this).balance);
    }

    // Refund contributors if goal not met
    function refund() external {
        require(block.timestamp >= deadline, "Deadline not reached");
        require(totalRaised < fundingGoal, "Goal was met");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Get campaign info
    function getCampaignInfo() external view returns (
        address _owner,
        uint _goal,
        uint _deadline,
        uint _raised,
        bool _withdrawn
    ) {
        return (owner, fundingGoal, deadline, totalRaised, withdrawn);
    }
}

