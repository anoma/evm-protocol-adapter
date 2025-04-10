// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ERC20Forwarder } from "../src/ERC20Forwarder.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

import { BaseScript } from "./Base.s.sol";

contract DeployERC20Wrapper is BaseScript {
    ProtocolAdapter internal constant _PROTOCOL_ADAPTER =
        ProtocolAdapter(address(0x02158F6963cEacb9018684C27d1848bAf974818A));
    address internal constant _ERC20 = address(0x1111111111111111111111111111111111111111);

    function run() public broadcast {
        bytes32 calldataCarrierLogicRef; // TODO
        bytes32 wrappingKind; // TODO

        ERC20Forwarder forwarder = new ERC20Forwarder{ salt: sha256("WrapperExample1") }({
            protocolAdapter: address(_PROTOCOL_ADAPTER),
            erc20: _ERC20,
            calldataCarrierLogicRef: calldataCarrierLogicRef,
            wrappingKind: wrappingKind
        });

        _PROTOCOL_ADAPTER.createCalldataCarrierResource({ untrustedForwarder: forwarder });
    }
}
