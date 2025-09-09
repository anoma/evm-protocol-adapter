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
}
