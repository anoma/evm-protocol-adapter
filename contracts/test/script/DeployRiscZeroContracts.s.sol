// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ControlID, RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";

contract DeployRiscZeroContracts is Script {
    /// @notice Deploys the RISC Zero router, verifier, and emergency stop contract of the current RISC Zero version.
    /// @param admin The address that can add new verifier contracts.
    /// @param guardian The address that can emergency stop the verifier.
    function run(address admin, address guardian)
        public
        returns (
            RiscZeroVerifierRouter router,
            RiscZeroVerifierEmergencyStop emergencyStop,
            RiscZeroGroth16Verifier groth16Verifier
        )
    {
        vm.startBroadcast(msg.sender);

        groth16Verifier = new RiscZeroGroth16Verifier(ControlID.CONTROL_ROOT, ControlID.BN254_CONTROL_ID);

        emergencyStop = new RiscZeroVerifierEmergencyStop({_verifier: groth16Verifier, guardian: guardian});

        router = new RiscZeroVerifierRouter({admin: msg.sender});
        router.addVerifier({selector: groth16Verifier.SELECTOR(), verifier: emergencyStop});

        // Transfer the router ownership from the deployer to the admin.
        router.transferOwnership(admin);

        vm.stopBroadcast();
    }
}
