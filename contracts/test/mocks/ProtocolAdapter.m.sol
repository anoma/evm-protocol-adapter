// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";

import {_MOCK_VERIFIER_SELECTOR} from "../script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMock is ProtocolAdapter {
    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter) ProtocolAdapter(riscZeroVerifierRouter) {}

    function getRiscZeroVerifierSelector() public pure override returns (bytes4 verifierSelector) {
        verifierSelector = _MOCK_VERIFIER_SELECTOR;
    }
}
