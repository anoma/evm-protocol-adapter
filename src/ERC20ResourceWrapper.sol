// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { Resource, Map } from "./Types.sol";

contract ERC20ResourceWrapper is Ownable {
    using Map for Map.KeyValuePair[];

    IERC20 public immutable TOKEN;
    uint256 public nonce;

    constructor(IERC20 _erc20, address protocolAdapter) Ownable(protocolAdapter) {
        TOKEN = _erc20;
    }

    function wrap(Resource memory resource, Map.KeyValuePair[] memory appData) external onlyOwner {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN.transferFrom({ from: _owner, to: address(this), value: resource.quantity });
    }

    function unwrap(Resource memory resource, Map.KeyValuePair[] memory appData) external onlyOwner {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN.transfer({ to: _owner, value: resource.quantity });
    }
}
