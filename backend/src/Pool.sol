// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

/**
 * @title Pool
 * @author ReeFLk
 */
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Pool is Ownable {
    error Pool__CollectIsFinished();
    error Pool__CollectIsNotFinished();
    error Pool__GoalAlreadyReached();
    error Pool__FailedToSendEther();
    error Pool__NoContribution();
    error Pool__NotEnoughEther();

    uint256 private endDate;
    uint256 private goal;
    uint256 private totalCollected;

    mapping(address => uint256) private contributions;

    event Contribution(address indexed contributor, uint256 amount);

    constructor(uint256 _duration, uint256 _goal) Ownable(msg.sender) {
        endDate = block.timestamp + _duration;
        goal = _goal;
    }
    //* @notice Allows to contribute to the pool

    function contribute() external payable {
        if (block.timestamp > endDate) {
            revert Pool__CollectIsFinished();
        }
        if (msg.value == 0) {
            revert Pool__NoContribution();
        }
        contributions[msg.sender] += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    function withdraw() external view onlyOwner {
        if (block.timestamp < endDate || totalCollected < goal) {
            revert Pool__CollectIsNotFinished();
        }
    }
}
