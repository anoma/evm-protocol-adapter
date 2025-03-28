// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library Reference {
    function toRef(address addr) internal pure returns (bytes32 ref) {
        ref = sha256(abi.encode(addr));
    }

    function toRef(bytes calldata data) internal pure returns (bytes32 ref) {
        ref = sha256(data);
    }

    function toRefCalldata(bytes memory data) internal pure returns (bytes32 ref) {
        ref = sha256(data);
    }
}
