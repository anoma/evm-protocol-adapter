// src/Emitter.sol
pragma solidity ^0.8.0;

contract Emitter {
    event TransactionExecuted(bytes discoveryPayload, bytes resourcePayload, bytes tag);

    function emitEvents(string calldata discoveryPayload, string calldata resourcePayload, string calldata tag) external {
        emit TransactionExecuted(bytes(discoveryPayload), bytes(resourcePayload), bytes(tag));
    }
}
