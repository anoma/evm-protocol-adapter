// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std-1.14.0/src/Script.sol";
import {RiscZeroVerifierEmergencyStop} from "risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "risc0-ethereum-3.0.1/contracts/src/test/RiscZeroMockVerifier.sol";

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
