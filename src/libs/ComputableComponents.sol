// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Resource, Action, Transaction} from "../Types.sol";
import {TagLogicProofPair} from "../proving/Logic.sol";

library ComputableComponents {
    function commitment(Resource memory resource) internal pure returns (bytes32 cm) {
        cm = sha256(abi.encode(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encode(resource, nullifierKey));
    }

    function kind(Resource memory resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    function kind(bytes32 logicRef, bytes32 labelRef) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(logicRef, labelRef));
    }

    function commitmentCalldata(Resource calldata resource) internal pure returns (bytes32 cm) {
        cm = sha256(abi.encode(resource));
    }

    function nullifierCalldata(Resource calldata resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encode(resource, nullifierKey));
    }

    function kindCalldata(Resource calldata resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    function transactionHash(bytes32[] memory tags) internal pure returns (bytes32 txHash) {
        txHash = sha256(abi.encode(tags));
    }

    // TODO! MOVE ELSEWHERE
    function prepareLists(TagLogicProofPair[] calldata pairs)
        internal
        pure
        returns (bytes32[][] memory consumed, bytes32[][] memory created)
    {
        uint256 nResources = pairs.length;

        consumed = new bytes32[][](nResources);
        created = new bytes32[][](nResources);

        // Count nullifiers and commitments
        uint256 nfsCount = 0;
        uint256 cmsCount = 0;
        for (uint256 i = 0; i < nResources; ++i) {
            pairs[i].logicProof.isConsumed ? ++nfsCount : ++cmsCount;
        }

        // Populate lists
        for (uint256 i = 0; i < nResources; ++i) {
            // Initialize list lengths.
            if (pairs[i].logicProof.isConsumed) {
                consumed[i] = new bytes32[](nfsCount - 1);
                created[i] = new bytes32[](cmsCount);
            } else {
                consumed[i] = new bytes32[](nfsCount);
                created[i] = new bytes32[](cmsCount - 1);
            }

            uint256 nfsCounter = 0;
            uint256 cmsCounter = 0;

            // Store tags
            for (uint256 j = 0; j < nResources; ++j) {
                if (i != j) {
                    if (pairs[j].logicProof.isConsumed) {
                        consumed[i][++nfsCounter] = pairs[j].tag;
                    } else {
                        created[i][++cmsCounter] = pairs[j].tag;
                    }
                }
            }
        }
    }
}
