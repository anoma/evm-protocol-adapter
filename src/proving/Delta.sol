// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

struct DeltaInstance {
    bytes32 delta; // DeltaHash
    uint256 expectedBalance; // Balance // pre-image // Balanced transactions have delta pre-image 0 for all involved kinds, for unbalanced transactions expectedBalance is a non-zero value
}
