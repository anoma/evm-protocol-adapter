// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../proving/Compliance.sol";
import {Transaction, Action} from "../Types.sol";

/// @title TagUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility function to handle tags.
/// @custom:security-contact security@anoma.foundation
library TagUtils {
    using TagUtils for Action;

    error TagCountMismatch(uint256 expected, uint256 actual);

    /// @notice Collects the resource tags in an action as ordered by the compliance units.
    /// @param action The action to collect the tags frm.
    /// @return tags The collected tags.
    function collectTags(Action calldata action) internal pure returns (bytes32[] memory tags) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;

        tags = new bytes32[](complianceUnitCount * 2);

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            Compliance.Instance calldata instance = action.complianceVerifierInputs[i].instance;
            tags[(i * 2)] = instance.consumed.nullifier;
            tags[(i * 2) + 1] = instance.created.commitment;
        }
    }

    /// @notice Counts the resource tags in a transaction and checks for each action that the tag count within is
    /// twice the number of compliance units.
    /// @param transaction The transaction to count and check the tags for.
    /// @return tagCount The computed tag count.
    function countTags(Transaction calldata transaction) internal pure returns (uint256 tagCount) {
        uint256 actionCount = transaction.actions.length;

        // Count the total number of tags in the transaction.
        for (uint256 i = 0; i < actionCount; ++i) {
            tagCount += transaction.actions[i].checkedActionTagCount();
        }
    }

    /// @notice Checks and returns the action tag count that must be twice the number of compliance units.
    /// @param action The action to check and return the tag count for.
    /// @return actionTagCount The checked action tag count.
    function checkedActionTagCount(Action calldata action) internal pure returns (uint256 actionTagCount) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;
        actionTagCount = action.logicVerifierInputs.length;

        // Check that the tag count in the action and compliance units matches.
        if (actionTagCount != complianceUnitCount * 2) {
            revert TagCountMismatch({expected: actionTagCount, actual: complianceUnitCount * 2});
        }
    }
}
