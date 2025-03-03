// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Create2 } from "@openzeppelin-contracts/utils/Create2.sol";

import { BaseScript } from "./Base.s.sol";

import { ERC20Wrapper } from "../src/ERC20Wrapper.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

import { console } from "forge-std/console.sol";

contract DeployWrapper is BaseScript {
    bytes32 internal constant DUMMY_SALT = bytes32(0);

    ProtocolAdapter internal constant PROTOCOL_ADAPTER = ProtocolAdapter(address(0));
    address internal constant ERC20 = address(0);

    function run() public broadcast {
        bytes32 wrapperLogicRef; // TODO
        bytes32 wrappedKind; // TODO

        ERC20Wrapper wrapper = new ERC20Wrapper{ salt: DUMMY_SALT }({
            protocolAdapter: address(PROTOCOL_ADAPTER),
            erc20: ERC20,
            wrapperLogicRef: wrapperLogicRef,
            wrappedKind: wrappedKind
        });

        PROTOCOL_ADAPTER.createWrapperContractResource({ untrustedWrapperContract: wrapper });

        // address detAddr = Create2.computeAddress({ salt: bytes32(0), bytecodeHash: keccak256(bytecode), deployer:  });
        // //function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer)
        // address addr = Create2.deploy({ amount: 0, salt: salt, bytecode: bytecode });
    }
}
