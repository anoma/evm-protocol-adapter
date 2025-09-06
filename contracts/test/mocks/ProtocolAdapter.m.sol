// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Delta} from "../../src/proving/Delta.sol";
import {Logic} from "../../src/proving/Logic.sol";

import {_MOCK_VERIFIER_SELECTOR} from "../script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMock is ProtocolAdapter {
    using RiscZeroUtils for Compliance.Instance;
    using Delta for bytes32[];

    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter) ProtocolAdapter(riscZeroVerifierRouter) {}

    function getRiscZeroVerifierSelector() public pure override returns (bytes4 verifierSelector) {
        verifierSelector = _MOCK_VERIFIER_SELECTOR;
    }

    function _verifyComplianceProof(Compliance.VerifierInput calldata input) internal view override {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: Compliance._VERIFYING_KEY,
            journalDigest: input.instance.toJournalDigest()
        });
    }

    function _verifyLogicProof(Logic.VerifierInput calldata input, bytes32 tree, bool consumed)
        internal
        view
        override
    {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: RiscZeroUtils.toJournalDigest(input, tree, consumed)
        });
    }

    function _verifyDeltaProof(bytes calldata proof, uint256[2] memory transactionDelta, bytes32[] memory tags)
        internal
        pure
        override
    {
        if (transactionDelta[0] != transactionDelta[1]) {
            revert Delta.DeltaMismatch({expected: address(0), actual: address(0)});
        }

        if (keccak256(proof) != tags.computeVerifyingKey()) {
            revert Delta.DeltaMismatch({expected: address(type(uint160).max), actual: address(type(uint160).max)});
        }
    }

    function _addUnitDelta(uint256[2] memory transactionDelta, uint256[2] memory unitDelta)
        internal
        pure
        override
        returns (uint256[2] memory sum)
    {
        unchecked {
            sum = [transactionDelta[0] + unitDelta[0], transactionDelta[1] + unitDelta[1]];
        }
    }
}
