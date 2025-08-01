// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ForwarderTarget {
    event CallReceived(uint256 input, uint256 output);

    function increment(uint256 value) external returns (uint256 incrementedValue) {
        incrementedValue = value + 1;
        emit CallReceived({input: value, output: incrementedValue});
    }
}
