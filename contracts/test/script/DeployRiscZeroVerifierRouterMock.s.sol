// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Script} from "forge-std/Script.sol";

bytes4 constant _MOCK_VERIFIER_SELECTOR = bytes4(0xFFFFFFFF);

contract DeployRiscZeroVerifierRouterMock is Script {
    RiscZeroVerifierRouter internal _router;
    RiscZeroMockVerifier internal _verifier;

    function run() public returns (RiscZeroVerifierRouter router, RiscZeroMockVerifier verifier) {
        (, address _defaultSender,) = vm.readCallers();

        vm.startBroadcast();

        verifier = new RiscZeroMockVerifier(_MOCK_VERIFIER_SELECTOR);
        _verifier = verifier;

        router = new RiscZeroVerifierRouter({admin: _defaultSender});
        router.addVerifier({selector: _MOCK_VERIFIER_SELECTOR, verifier: _verifier});
        _router = router;

        vm.stopBroadcast();
    }
}
