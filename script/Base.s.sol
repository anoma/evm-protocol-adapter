// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Script } from "forge-std/Script.sol";

abstract contract BaseScript is Script {
    /// @dev Included to enable compilation of the script without a $MNEMONIC environment variable.
    string internal constant TEST_MNEMONIC = "test test test test test test test test test test test junk";

    /// @dev The address of the transaction broadcaster.
    address internal broadcaster;

    /// @dev Used to derive the broadcaster's address.
    string internal mnemonic;

    /// @dev Initializes the transaction broadcaster.
    /// If $MNEMONIC is not defined, default to a test mnemonic.
    constructor() {
        mnemonic = vm.envOr({ name: "MNEMONIC", defaultValue: TEST_MNEMONIC });
        (broadcaster,) = deriveRememberKey({ mnemonic: mnemonic, index: 0 });
    }

    modifier broadcast() {
        vm.startBroadcast(broadcaster);
        _;
        vm.stopBroadcast();
    }
}
