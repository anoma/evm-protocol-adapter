// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std-1.14.0/src/Script.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";
import {LibString} from "solady-0.1.26/src/utils/LibString.sol";

import {Versioning} from "../src/libs/Versioning.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

/// @title DeployProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice A script to deploy protocol adapter contracts on supported networks.
/// @custom:security-contact security@anoma.foundation
contract DeployProtocolAdapter is Script {
    using LibString for bytes32;

    /// @notice A mapping containing the supported chain IDs and network names.
    mapping(uint256 chainId => string networkName) internal _supportedNetworks;

    /// @notice A mapping from supported network names to RISC Zero verifier routers.
    mapping(string networkName => RiscZeroVerifierRouter router) internal _riscZeroVerifierRouters;

    /// @notice Thrown when a network is not supported.
    /// @param chainId The chain ID of the unsupported network.
    error UnsupportedNetwork(uint256 chainId);

    /// @notice Initializes the supported networks and associated RISC Zero verifier router addresses
    /// (see https://dev.risczero.com/api/3.0/blockchain-integration/contracts/verifier).
    constructor() {
        _supportNetwork({
            name: "sepolia", chainId: 11155111, riscZeroVerifierRouter: 0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187
        });
        _supportNetwork({
            name: "mainnet", chainId: 1, riscZeroVerifierRouter: 0x8EaB2D97Dfce405A1692a21b3ff3A172d593D319
        });

        _supportNetwork({
            name: "arbitrum-sepolia",
            chainId: 421614,
            riscZeroVerifierRouter: 0x0b144E07A0826182B6b59788c34b32Bfa86Fb711
        });
        _supportNetwork({
            name: "arbitrum", chainId: 42161, riscZeroVerifierRouter: 0x0b144E07A0826182B6b59788c34b32Bfa86Fb711
        });

        _supportNetwork({
            name: "base-sepolia", chainId: 84532, riscZeroVerifierRouter: 0x0b144E07A0826182B6b59788c34b32Bfa86Fb711
        });
        _supportNetwork({
            name: "base", chainId: 8453, riscZeroVerifierRouter: 0x0b144E07A0826182B6b59788c34b32Bfa86Fb711
        });

        _supportNetwork({
            name: "optimism-sepolia",
            chainId: 11155420,
            riscZeroVerifierRouter: 0xB369b4dd27FBfb59921d3A4a3D23AC2fc32FB908
        });
        _supportNetwork({
            name: "optimism", chainId: 10, riscZeroVerifierRouter: 0x0b144E07A0826182B6b59788c34b32Bfa86Fb711
        });

        _supportNetwork({
            name: "aurora-testnet",
            chainId: 1313161555,
            riscZeroVerifierRouter: 0x7C1B7b8fEB636eA9Ecd32152Bce2744a0EEf39C7
        });
    }

    /// @notice Deploys the protocol adapter contract on supported networks and allows for test deployments.
    /// @param isTestDeployment Whether the deployment is a test deployment or not. If set to `false`, the protocol
    /// adapter is deployed deterministically.
    /// @param emergencyStopCaller The emergency stop caller that can stop the protocol adapter in an emergency.
    /// @dev If `isTestDeployment` is set to `false`, the protocol adapter is deployed deterministically.
    function run(bool isTestDeployment, address emergencyStopCaller) public returns (address protocolAdapter) {
        // Lookup the RISC Zero router address from the supported networks.
        RiscZeroVerifierRouter riscZeroVerifierRouter = _riscZeroVerifierRouters[_supportedNetworks[block.chainid]];

        if (address(riscZeroVerifierRouter) == address(0)) {
            revert UnsupportedNetwork({chainId: block.chainid});
        }

        vm.startBroadcast();

        if (isTestDeployment) {
            // Deploy regularly.
            protocolAdapter = address(
                new ProtocolAdapter({
                    riscZeroVerifierRouter: riscZeroVerifierRouter,
                    riscZeroVerifierSelector: Versioning._RISC_ZERO_VERIFIER_SELECTOR,
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
                    riscZeroVerifierRouter: riscZeroVerifierRouter,
                    riscZeroVerifierSelector: Versioning._RISC_ZERO_VERIFIER_SELECTOR,
                    emergencyStopCaller: emergencyStopCaller
                })
            );
        }

        vm.stopBroadcast();
    }

    /// @notice Stores the data for a network to be supported for deployment.
    /// @param name The network name.
    /// @param chainId The chain ID of the network.
    /// @param riscZeroVerifierRouter The RISC Zero verifier router address obtained from
    /// https://dev.risczero.com/api/3.0/blockchain-integration/contracts/verifier.
    /// @dev The network `name` must match the `[rpc_endpoints]` names in the `foundry.toml` file for the test in
    /// `DeployProtocolAdapter.t.sol` to succeed.
    function _supportNetwork(string memory name, uint256 chainId, address riscZeroVerifierRouter) internal {
        _supportedNetworks[chainId] = name;
        _riscZeroVerifierRouters[name] = RiscZeroVerifierRouter(riscZeroVerifierRouter);
    }
}
