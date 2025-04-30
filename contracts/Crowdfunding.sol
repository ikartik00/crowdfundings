// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleCrowdfunding {
    address public owner;
    uint public fundingGoal;
    uint public deadline;
    uint public totalRaised;

    mapping(address => uint) public contributions;

    constructor(uint _goalInWei, uint _durationInSeconds) {
        owner = msg.sender;
        fundingGoal = _goalInWei;
        deadline = block.timestamp + _durationInSeconds;
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

        payable(owner).transfer(address(this).balance);
    }
}

