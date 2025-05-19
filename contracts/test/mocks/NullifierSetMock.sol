// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {NullifierSet} from "../../src/state/NullifierSet.sol";

contract NullifierSetMock is NullifierSet {
    function addNullifier(bytes32 nullifier) external {
        _addNullifier(nullifier);
    }

    function addNullifierUnchecked(bytes32 nullifier) external {
        _addNullifierUnchecked(nullifier);
    }

    function checkNullifierNonExistence(bytes32 nullifier) external view {
        _checkNullifierNonExistence(nullifier);
    }
}
