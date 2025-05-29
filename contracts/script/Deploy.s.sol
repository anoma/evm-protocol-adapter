// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {BaseScript} from "./Base.s.sol";

contract Deploy is BaseScript {
    function run() public broadcast returns (address protocolAdapter) {
        string memory path = "script/constructor-args.txt";

        IRiscZeroVerifier trustedSepoliaVerifier = IRiscZeroVerifier(vm.parseAddress(vm.readLine(path)));

        uint8 commitmentTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        uint8 actionTagTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        protocolAdapter = address(
            new ProtocolAdapter{salt: sha256("ProtocolAdapterDraft")}({
                riscZeroVerifier: trustedSepoliaVerifier,
                commitmentTreeDepth: commitmentTreeDepth,
                actionTagTreeDepth: actionTagTreeDepth
            })
        );
    }
}
