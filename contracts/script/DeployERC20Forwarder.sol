// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {BaseScript} from "./Base.s.sol";

contract DeployERC20Wrapper is BaseScript {
    ProtocolAdapter internal constant _PROTOCOL_ADAPTER = ProtocolAdapter(address(0));

    address internal constant _ERC20 = address(0x1111111111111111111111111111111111111111);

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(0);

    function run() public broadcast {
        new ERC20Forwarder{salt: sha256("ERC20ForwarderExample")}({
            protocolAdapter: address(_PROTOCOL_ADAPTER),
            erc20: _ERC20,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
        });
    }
}
