// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IRiscZeroVerifier, Receipt as RiscZeroReceipt } from "@risc0-ethereum/IRiscZeroVerifier.sol";

import { BaseScript } from "./Base.s.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

contract DeployProtocolAdapter is BaseScript {
    IRiscZeroVerifier internal constant _TRUSTED_SEPOLIA_VERIFIER =
        IRiscZeroVerifier(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));
    bytes32 internal constant _LOGIC_CIRCUIT_ID = bytes32(0);
    bytes32 internal constant _COMPLIANCE_CIRCUIT_ID = bytes32(0);
    uint8 internal constant _TREE_DEPTH = 32;

    function run() public broadcast {
        new ProtocolAdapter({
            riscZeroVerifier: _TRUSTED_SEPOLIA_VERIFIER,
            logicCircuitID: _LOGIC_CIRCUIT_ID,
            complianceCircuitID: _COMPLIANCE_CIRCUIT_ID,
            treeDepth: _TREE_DEPTH
        });
    }
}
