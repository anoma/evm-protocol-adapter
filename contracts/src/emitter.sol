// src/Emitter.sol
pragma solidity ^0.8.0;

import {TransactionExample} from "../test/examples/Transaction.e.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

contract Emitter {
    uint256 internal _txCount;
    
    function seedTransactionExecutedEvent(string calldata tag, string calldata ciphertext) external {            
        emit IProtocolAdapter.TransactionExecuted({id: _txCount++, transaction: TransactionExample.transaction(), newRoot: TransactionExample.treeRoot()});
        
    }
}
