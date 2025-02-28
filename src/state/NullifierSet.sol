// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

contract NullifierSet {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    EnumerableSet.Bytes32Set internal _nullifierSet;

    event NullifierAdded(bytes32 indexed nullifier, uint256 indexed index);

    error PreExistingNullifier(bytes32 nullifier);

    // slither-disable-next-line dead-code
    function _addNullifier(bytes32 nullifier) internal {
        (bool success) = _nullifierSet.add(nullifier);
        if (!success) {
            revert PreExistingNullifier(nullifier);
        }
        emit NullifierAdded({ nullifier: nullifier, index: _nullifierSet.length() - 1 });
    }

    function _addNullifierUnchecked(bytes32 nullifier) internal {
        // slither-disable-next-line unused-return
        _nullifierSet.add(nullifier);

        emit NullifierAdded({ nullifier: nullifier, index: _nullifierSet.length() - 1 });
    }

    function _checkNullifierNonExistence(bytes32 nullifier) internal view {
        if (_nullifierSet.contains(nullifier)) {
            revert PreExistingNullifier(nullifier);
        }
    }
}
