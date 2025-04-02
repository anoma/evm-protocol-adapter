// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { BaseScript } from "./Base.s.sol";

import { ERC20Wrapper } from "../src/ERC20Wrapper.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

contract DeployWrapper is BaseScript {
    ProtocolAdapter internal constant PROTOCOL_ADAPTER = ProtocolAdapter(address(0));
    address internal constant ERC20 = address(0);

    function run() public broadcast {
        bytes32 wrapperLogicRef; // TODO
        bytes32 wrappingKind; // TODO

        ERC20Wrapper wrapper = new ERC20Wrapper{ salt: sha256("WrapperExample") }({
            protocolAdapter: address(PROTOCOL_ADAPTER),
            erc20: ERC20,
            wrapperLogicRef: wrapperLogicRef,
            wrappingKind: wrappingKind
        });

        PROTOCOL_ADAPTER.createWrapperContractResource({ untrustedWrapperContract: wrapper });
    }
}
