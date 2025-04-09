// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ERC20Wrapper } from "../src/ERC20Wrapper.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

import { BaseScript } from "./Base.s.sol";

contract DeployWrapper is BaseScript {
    ProtocolAdapter internal constant _PROTOCOL_ADAPTER =
        ProtocolAdapter(address(0x02158F6963cEacb9018684C27d1848bAf974818A));
    address internal constant _ERC20 = address(0x1111111111111111111111111111111111111111);

    function run() public broadcast {
        bytes32 wrapperLogicRef; // TODO
        bytes32 wrappingKind; // TODO

        ERC20Wrapper wrapper = new ERC20Wrapper{ salt: sha256("WrapperExample1") }({
            protocolAdapter: address(_PROTOCOL_ADAPTER),
            erc20: _ERC20,
            wrapperLogicRef: wrapperLogicRef,
            wrappingKind: wrappingKind
        });

        _PROTOCOL_ADAPTER.createWrapperContractResource({ untrustedWrapperContract: wrapper });
    }
}
