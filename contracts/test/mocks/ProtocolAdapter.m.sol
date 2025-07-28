// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Delta} from "../../src/proving/Delta.sol";
import {Logic} from "../../src/proving/Logic.sol";

contract ProtocolAdapterMock is ProtocolAdapter {
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;

    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter, uint8 commitmentTreeDepth, uint8 actionTagTreeDepth)
        ProtocolAdapter(riscZeroVerifierRouter, commitmentTreeDepth, actionTagTreeDepth)
    {}

    function actionTreeDepth() external view returns (uint8 depth) {
        depth = _ACTION_TAG_TREE_DEPTH;
    }

    function _verifyComplianceProof(Compliance.VerifierInput calldata input) internal view override {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: Compliance._VERIFYING_KEY,
            journalDigest: input.instance.toJournalDigest()
        });
    }

    function _verifyLogicProof(Logic.VerifierInput calldata input) internal view override {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: input.instance.toJournalDigest()
        });
    }

    function _verifyDeltaProof(bytes calldata proof, uint256[2] memory transactionDelta, bytes32[] memory tags)
        internal
        pure
        override
    {
        {
            transactionDelta;
            tags;
        }

        bool valid = abi.decode(proof, (bool));
        if (!valid) {
            revert Delta.DeltaMismatch({expected: address(type(uint160).max), actual: address(0)});
        }
    }
}
