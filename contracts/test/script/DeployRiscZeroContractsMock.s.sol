// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Script} from "forge-std/Script.sol";

bytes4 constant _MOCK_VERIFIER_SELECTOR = bytes4(0xFFFFFFFF);

contract DeployRiscZeroContractsMock is Script {
    function run()
        public
        returns (
            RiscZeroVerifierRouter router,
            RiscZeroVerifierEmergencyStop emergencyStop,
            RiscZeroMockVerifier mockVerifier
        )
    {
        vm.startBroadcast(msg.sender);

        mockVerifier = new RiscZeroMockVerifier(_MOCK_VERIFIER_SELECTOR);

        emergencyStop = new RiscZeroVerifierEmergencyStop({_verifier: mockVerifier, guardian: msg.sender});

        router = new RiscZeroVerifierRouter({admin: msg.sender});
        router.addVerifier({selector: mockVerifier.SELECTOR(), verifier: emergencyStop});

        vm.stopBroadcast();
    }
}
