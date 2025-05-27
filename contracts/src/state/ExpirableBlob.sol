// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice An enum representing the supported blob deletion criteria.
enum DeletionCriterion {
    Immediately,
    Never
}

/// @notice A blob with a deletion criterion attached.
/// @param deletionCriterion The deletion criterion.
/// @param blob The bytes-encoded blob data.
struct ExpirableBlob {
    DeletionCriterion deletionCriterion;
    bytes blob;
}

// TODO make lib
