// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ExpirableBlob, DeletionCriterion} from "../state/ExpirableBlob.sol";

library Logic {
    error LogicProofTagNotFound(bytes32 tag); // TODO Rename
    error LogicProofIndexOutBounds(uint256 index, uint256 max); // TODO Rename

    function lookup(VerifierInput[] calldata arr, bytes32 tag) internal pure returns (VerifierInput calldata elem) {
        uint256 len = arr.length;
        for (uint256 i = 0; i < len; ++i) {
            if (arr[i].instance.tag == tag) {
                return elem = arr[i];
            }
        }
        revert LogicProofTagNotFound(tag);
    }

    /// @notice The data structure containing all information to verify the logic proof.
    /// @param proof
    /// @param instance
    /// @param verifyingKey
    /// @dev In the future and to achieve function privacy, the logic circuit validity will be proving in another circuit.
    /// This means that the logic function hash
    struct VerifierInput {
        bytes proof;
        Instance instance;
        bytes32 verifyingKey; // TODO Rename to verifying key?
    }

    /// @notice The instance of the logic proof.
    /// @param tag The nullifier or commitment of the resource depending on if the resource is consumed or not.
    /// @param isConsumed Whether the associated resource is consumed or not.
    /// @param actionTreeRoot The root of the action tree.
    /// @param ciphertext Encrypted information for the receiver of the resource that will be emitted as an event.
    /// The ciphertext contains, at least, the resource plaintext and optional other application specific data.
    /// @param appData // TODO
    struct Instance {
        bytes32 tag;
        bool isConsumed;
        bytes32 actionTreeRoot;
        bytes ciphertext;
        ExpirableBlob[] appData;
    }
}
