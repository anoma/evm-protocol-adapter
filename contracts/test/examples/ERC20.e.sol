// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";

contract ERC20Example is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }
}
