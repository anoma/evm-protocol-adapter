// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IRiscZeroVerifier } from "@risc0-ethereum/IRiscZeroVerifier.sol";

import { BaseScript } from "./Base.s.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

contract Deploy is BaseScript {
    function run() public broadcast returns (address) {
        string memory path = "script/constructor-args.txt";

        IRiscZeroVerifier trustedSepoliaVerifier = IRiscZeroVerifier(vm.parseAddress(vm.readLine(path)));

        bytes32 logicCircuitID = vm.parseBytes32(vm.readLine(path));

        bytes32 complianceCircuitID = vm.parseBytes32(vm.readLine(path));

        uint8 treeDepth = uint8(vm.parseUint(vm.readLine(path)));

        return address(
            new ProtocolAdapter{ salt: sha256("ProtocolAdapter") }({
                riscZeroVerifier: trustedSepoliaVerifier,
                logicCircuitID: logicCircuitID,
                complianceCircuitID: complianceCircuitID,
                treeDepth: treeDepth
            })
        );
    }
}
