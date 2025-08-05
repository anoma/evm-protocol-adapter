// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

uint256 constant INPUT_VALUE = 123;
uint256 constant OUTPUT_VALUE = INPUT_VALUE + 1;
bytes constant INPUT = abi.encodeCall(ForwarderTargetExample.increment, INPUT_VALUE);
bytes constant EXPECTED_OUTPUT = abi.encode(OUTPUT_VALUE);

contract ForwarderTargetExample {
    event CallReceived(uint256 input, uint256 output);

    function increment(uint256 value) external returns (uint256 incrementedValue) {
        incrementedValue = value + 1;
        emit CallReceived({input: value, output: incrementedValue});
    }
}
