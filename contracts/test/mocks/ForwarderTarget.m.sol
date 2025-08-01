// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ForwarderTargetMock {
    event CallReceived(bytes input, bytes output);

    function func(bytes calldata input) external returns (bytes memory output) {
        output = abi.encode(address(this));

        emit CallReceived({input: input, output: output});
    }
}
