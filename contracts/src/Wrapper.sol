// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";

import {StateTransition, Parameters} from "./StateTransition.sol";

contract Wrapper is ReentrancyGuardTransient {
    using SafeERC20 for IERC20;

    StateTransition internal immutable stateTransitioner;

    mapping(IERC20 allowed => bool) allowedTokens;

    mapping(IERC20 token => mapping(address depositor => uint256)) deposits;

    event Deposited(IERC20 token, address indexed user, uint256 amount);

    constructor(StateTransition _stateTransition) {
        stateTransitioner = _stateTransition;
    }

    function deposit(IERC20 token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than zero");

        token.safeTransferFrom(msg.sender, address(this), amount);

        deposits[token][msg.sender] += amount;

        emit Deposited(token, msg.sender, amount);
    }

    function emergencyWithdraw(IERC20 token) external {
        if (block.timestamp < stateTransitioner.lastUpdate() + Parameters.EMERGENCY_MODE_ACTIVATION_DELAY) {
            revert("too early TODO error");
        }

        uint256 depositedAmount = deposits[token][msg.sender];
        depositedAmount = 0;

        token.safeTransfer({to: msg.sender, value: depositedAmount});
    }
}
