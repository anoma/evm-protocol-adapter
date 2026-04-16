// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierSelectors} from "anoma-risc0-deployments-1.0.0-rc.1/src/RiscZeroVerifierSelectors.sol";
import {SupportedNetworks} from "anoma-risc0-deployments-1.0.0-rc.1/src/SupportedNetworks.sol";
import {Script} from "forge-std-1.15.0/src/Script.sol";
import {LibString} from "solady-0.1.26/src/utils/LibString.sol";

import {Versioning} from "../src/libs/Versioning.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

/// @title DeployProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice A script to deploy protocol adapter contracts on supported networks.
/// @custom:security-contact security@anoma.foundation
contract DeployProtocolAdapter is SupportedNetworks, Script {
    using LibString for bytes32;

    /// @notice Initializes the supported networks and associated RISC Zero verifier router addresses
    /// (see https://dev.risczero.com/api/3.0/blockchain-integration/contracts/verifier).
    constructor() SupportedNetworks() {}

    /// @notice Deploys the protocol adapter contract on supported networks and allows for test deployments.
    /// @param isTestDeployment Whether the deployment is a test deployment or not. If set to `false`, the protocol
    /// adapter is deployed deterministically.
    /// @param emergencyStopCaller The emergency stop caller that can stop the protocol adapter in an emergency.
    /// @dev If `isTestDeployment` is set to `false`, the protocol adapter is deployed deterministically.
    function run(bool isTestDeployment, address emergencyStopCaller) public returns (address protocolAdapter) {
        // Lookup the RISC Zero router address from the supported networks.
        SupportedNetworks.Data memory data = getRouterData();

        vm.startBroadcast();

        if (isTestDeployment) {
            // Deploy regularly.
            protocolAdapter = address(
                new ProtocolAdapter({
                    riscZeroVerifierRouter: data.router,
                    riscZeroVerifierSelector: RiscZeroVerifierSelectors._GROTH16_VERIFIER_SELECTOR,
                    emergencyStopCaller: emergencyStopCaller
                })
            );
        } else {
            // Deploy deterministically.
            protocolAdapter = address(
                new ProtocolAdapter{
                    salt: keccak256(
                        bytes(string.concat("ProtocolAdapter", Versioning._PROTOCOL_ADAPTER_VERSION.fromSmallString()))
                    )
                }({
                    riscZeroVerifierRouter: data.router,
                    riscZeroVerifierSelector: RiscZeroVerifierSelectors._GROTH16_VERIFIER_SELECTOR,
                    emergencyStopCaller: emergencyStopCaller
                })
            );
        }

        vm.stopBroadcast();
    }
}
