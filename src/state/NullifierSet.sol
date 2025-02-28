// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract NullifierSet {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    EnumerableSet.Bytes32Set internal nullifierSet;

    event NullifierAdded(bytes32 indexed nullifier, uint256 indexed index);

    error ExistentNullifier(bytes32 nullifier);

    function _checkNullifierNonExistence(bytes32 nullifier) internal view {
        if (nullifierSet.contains(nullifier)) {
            revert ExistentNullifier(nullifier);
        }
    }

    function _addNullifier(bytes32 nullifier) internal {
        (bool success) = nullifierSet.add(nullifier);
        if (!success) {
            revert ExistentNullifier(nullifier);
        }
        emit NullifierAdded({ nullifier: nullifier, index: nullifierSet.length() - 1 });
    }
}
