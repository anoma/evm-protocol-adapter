// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Vm} from "forge-std-1.14.0/src/Vm.sol";

import {Compliance} from "../../src/libs/proving/Compliance.sol";
import {Logic} from "../../src/libs/proving/Logic.sol";
import {Transaction, Action} from "../../src/Types.sol";

library Parsing {
    function toStorage(Transaction storage stored, Transaction memory parsed) internal {
        stored.deltaProof = parsed.deltaProof;
        stored.aggregationProof = parsed.aggregationProof;

        uint256 actionCount = parsed.actions.length;

        for (uint256 i = 0; i < actionCount; ++i) {
            stored.actions.push();
            Action storage storedAction = stored.actions[i];
            Action memory parsedAction = parsed.actions[i];

            uint256 logicProofCount = parsedAction.logicVerifierInputs.length;
            for (uint256 j = 0; j < logicProofCount; ++j) {
                storedAction.logicVerifierInputs.push();
                Logic.VerifierInput storage storedLp = storedAction.logicVerifierInputs[j];
                Logic.VerifierInput memory parsedLp = parsedAction.logicVerifierInputs[j];

                storedLp.tag = parsedLp.tag;
                storedLp.verifyingKey = parsedLp.verifyingKey;
                storedLp.proof = parsedLp.proof;

                uint256 payloadLength = parsedLp.appData.resourcePayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.resourcePayload.push();
                    storedLp.appData.resourcePayload[k] = parsedLp.appData.resourcePayload[k];
                }

                payloadLength = parsedLp.appData.discoveryPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.discoveryPayload.push();
                    storedLp.appData.discoveryPayload[k] = parsedLp.appData.discoveryPayload[k];
                }

                payloadLength = parsedLp.appData.externalPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.externalPayload.push();
                    storedLp.appData.externalPayload[k] = parsedLp.appData.externalPayload[k];
                }

                payloadLength = parsedLp.appData.applicationPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.applicationPayload.push();
                    storedLp.appData.applicationPayload[k] = parsedLp.appData.applicationPayload[k];
                }
            }

            uint256 complianceUnitCount = parsedAction.complianceVerifierInputs.length;
            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                storedAction.complianceVerifierInputs.push();
                Compliance.VerifierInput storage storedCu = storedAction.complianceVerifierInputs[j];
                Compliance.VerifierInput memory parsedCu = parsedAction.complianceVerifierInputs[j];

                storedCu.proof = parsedCu.proof;

                storedCu.instance.consumed.nullifier = parsedCu.instance.consumed.nullifier;
                storedCu.instance.consumed.logicRef = parsedCu.instance.consumed.logicRef;
                storedCu.instance.consumed.commitmentTreeRoot = parsedCu.instance.consumed.commitmentTreeRoot;

                storedCu.instance.created.commitment = parsedCu.instance.created.commitment;
                storedCu.instance.created.logicRef = parsedCu.instance.created.logicRef;

                storedCu.instance.unitDeltaX = parsedCu.instance.unitDeltaX;
                storedCu.instance.unitDeltaY = parsedCu.instance.unitDeltaY;
            }
        }
    }

    function parseTransaction(Vm vm, string memory path) internal view returns (Transaction memory txn) {
        string memory fullPath = string.concat(vm.projectRoot(), "/", path);
        bytes memory data = vm.readFileBinary(fullPath);

        txn = abi.decode(data, (Transaction));
    }
}
