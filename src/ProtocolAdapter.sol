// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { AppData, Map } from "./libs/AppData.sol";
import { Delta } from "./libs/Delta.sol";

import { UNIVERSAL_NULLIFIER_KEY, WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "./Constants.sol";
import { CommitmentAccumulator } from "./CommitmentAccumulator.sol";
import { NullifierSet } from "./NullifierSet.sol";
import { RiscZeroVerifier } from "./RiscZeroVerifier.sol";

import "./Types.sol"; // TODO explicit imports
import "./ProvingSystem/Compliance.sol";
import "./ProvingSystem/Delta.sol";
import "./ProvingSystem/Logic.sol";

contract ProtocolAdapter is IProtocolAdapter, RiscZeroVerifier, CommitmentAccumulator, NullifierSet {
    using ComputableComponents for Resource;
    using AppData for Map.KeyValuePair[];
    using Delta for bytes32;
    using Address for address;

    uint256 private txCount;
    uint256 internal constant BALANCED = uint256(0);

    bytes32 internal constant COMPLIANCE_CIRCUIT_ID = bytes32(0); //TODO
    bytes32 internal constant LOGIC_CIRCUIT_ID = bytes32(0); //TODO
    bytes32 internal constant DELTA_CIRCUIT_ID = bytes32(0); //TODO

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error KindMismatch(bytes32 expected, bytes32 actual);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error NullifierMismatch(bytes32 expected, bytes32 actual);
    error DeltaMismatch(bytes32 expected, bytes32 actual);
    error BalanceMismatch(uint256 expected, uint256 actual);

    error WrongEphemerality(bytes32 tag, bool ephemeral);

    bytes32 private constant EMPTY_BYTES32 = bytes32(0);
    // solhint-disable-next-line var-name-mixedcase
    uint256[] private EMPTY_UINT256_ARR = new uint256[](0);

    constructor(
        address _riscZeroVerifier,
        uint8 _treeDepth
    )
        RiscZeroVerifier(_riscZeroVerifier)
        CommitmentAccumulator(_treeDepth)
    { }

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) public view {
        // compute delta
        bytes32 transactionDelta = 0;

        // Verify resource logics and compliance proofs.
        for (uint256 i; i < transaction.actions.length; ++i) {
            transactionDelta = transactionDelta.add(_actionDelta(transaction.actions[i]));

            _verifyAction(transaction.actions[i]);
        }

        _verifyDelta(transactionDelta, transaction.deltaProof);
    }

    function _actionDelta(Action calldata action) internal pure returns (bytes32 delta) {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            delta = delta.add(action.complianceUnits[i].refInstance.referencedComplianceInstance.unitDelta);
        }
    }

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively, and calling EVM.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external {
        verify(transaction);

        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];
            Map.KeyValuePair[] memory appData = action.appData;

            for (uint256 j = 0; j < action.nullifiers.length; ++j) {
                _addNullifier(action.nullifiers[j]);
                _attemptWrapCall(action.nullifiers[j], appData);
            }

            for (uint256 j = 0; j < action.commitments.length; ++j) {
                _addCommitment(action.commitments[j]);
                _attemptUnwrapCall(action.commitments[j], appData);
            }
        }
        emit TransactionExecuted({ id: txCount++, transaction: transaction });
    }

    function _verifyDelta(bytes32 computedDelta, bytes calldata deltaProof) internal pure {
        DeltaInstance memory instance = abi.decode(deltaProof, (DeltaInstance));

        /* Constraints (https://specs.anoma.net/latest/arch/system/state/resource_machine/data_structures/transaction/delta_proof.html#constraints)
        1. delta = sum(unit.delta() for unit in action.units for action in tx) - can be checked outside of the circuit since all values are public
        2. delta's preimage's quantity component is expectedBalance
        */

        if (instance.expectedBalance != BALANCED) {
            revert BalanceMismatch({ expected: BALANCED, actual: instance.expectedBalance });
        }

        // TODO is proof verification required? Can we use the computed delta?
        if (instance.delta != computedDelta) {
            revert DeltaMismatch({ expected: computedDelta, actual: instance.delta });
        }
        //_verifyProof({ seal: deltaProof, imageId: /*TODO*/ bytes32(0), journalDigest: delta });
    }

    function _verifyAction(Action calldata action) internal view {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            _verifyComplianceUnit(action.complianceUnits[i]);
        }

        for (uint256 i; i < action.logicProofs.length; ++i) {
            //_verifyLogicProof(action.logicProofs.at(i));
            _verifyLogicProof(action.logicProofs[i]);
        }
    }

    function _verifyComplianceUnit(ComplianceUnit calldata complianceUnit) internal view {
        ComplianceInstance memory complianceInstance = complianceUnit.refInstance.referencedComplianceInstance;

        // TODO needed?
        for (uint256 i; i < complianceInstance.consumed.length; ++i) {
            // TODO Ask Xuyang: Do we need to verify the merkle path validity
            // NOTE: We need the commitment associated with a nullifier do the nullifier check. Similarly, we need all roots.

            _checkNullifierNonExistence(complianceInstance.consumed[i].nullifierRef);
            _checkRootPreExistence(complianceInstance.consumed[i].rootRef);
            _checkMerklePath({
                root: complianceInstance.consumed[i].rootRef,
                // TODO Ask Yulia: Where can I get the commitment identifier from?
                // TODO Ask Xuyang: If merkle path validity checks happen out-of-circuit, don't we loose nullifier-commitment unlinkability? -> The merkle path check should happen in-circuit.
                commitment: sha256("WHERE TO GET THE COMMITMENT FROM?"),
                // TODO Ask Yulia: Where can I get the siblings from? Are the siblings the witness?
                siblings: new bytes32[](0)
            });
        }

        // TODO needed?
        for (uint256 i; i < complianceInstance.created.length; ++i) {
            _checkCommitmentNonExistence(complianceInstance.created[i].commitmentRef);
        }

        _verifyProofCalldata({
            seal: complianceUnit.proof,
            imageId: COMPLIANCE_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(complianceUnit))
        });
    }

    function _verifyLogicProof(LogicProofMap.TagLogicProofPair calldata tagLogicProofPair) internal view {
        // TODO
        _verifyProofCalldata({
            seal: tagLogicProofPair.pair.proof,
            imageId: LOGIC_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(tagLogicProofPair.pair))
        });
    }

    function _attemptWrapCall(bytes32 nullifier, Map.KeyValuePair[] memory appData) internal {
        // Resource object lookup from the app data
        Resource memory resource;
        {
            bool success;
            (success, resource) = appData.lookupResource({ key: nullifier ^ WRAP_MAGIC_NUMBER });
            if (!success) return;

            // Nullifier integrity check
            _checkResourceNullifierIntegrity(resource, nullifier);
        }
        // Wrapper contract lookup from the resource label reference
        IResourceWrapper wrapper;
        {
            bool success;
            (success, wrapper) = appData.lookupWrapper({ key: resource.labelRef });
            if (!success) revert Map.KeyNotFound({ key: resource.labelRef });

            _checkResourceWrapperIntegrity(resource, wrapper);
        }

        // Execute external state transition
        wrapper.wrap(nullifier, resource, appData);
        emit EVMStateChangeExecuted(wrapper, nullifier);
    }

    function _attemptUnwrapCall(bytes32 commitment, Map.KeyValuePair[] memory appData) internal {
        // Resource object lookup from the app data
        Resource memory resource;
        {
            bool success;
            (success, resource) = appData.lookupResource({ key: commitment ^ UNWRAP_MAGIC_NUMBER });
            if (!success) return;

            // Nullifier integrity check
            _checkResourceCommitmentIntegrity(resource, commitment);
        }
        // Wrapper contract lookup from the resource label reference
        IResourceWrapper wrapper;
        {
            bool success;
            (success, wrapper) = appData.lookupWrapper({ key: resource.labelRef });
            if (!success) revert Map.KeyNotFound({ key: resource.labelRef });

            _checkResourceWrapperIntegrity(resource, wrapper);
        }

        // Execute external state transition
        wrapper.unwrap(commitment, resource, appData);
        emit EVMStateChangeExecuted(wrapper, commitment);
    }

    function _checkResourceNullifierIntegrity(Resource memory resource, bytes32 nullifier) internal pure {
        bytes32 recomputedCommitment = resource.nullifier(UNIVERSAL_NULLIFIER_KEY);
        if (recomputedCommitment != nullifier) {
            revert NullifierMismatch({ expected: nullifier, actual: recomputedCommitment });
        }

        if (!resource.ephemeral) {
            revert WrongEphemerality(nullifier, resource.ephemeral);
        }
    }

    function _checkResourceCommitmentIntegrity(Resource memory resource, bytes32 commitment) internal pure {
        bytes32 recomputedCommitment = resource.commitment();
        if (recomputedCommitment != commitment) {
            revert CommitmentMismatch({ expected: commitment, actual: recomputedCommitment });
        }

        if (!resource.ephemeral) {
            revert WrongEphemerality(commitment, resource.ephemeral);
        }
    }

    /// @notice Checks the resource kind integrity.
    function _checkResourceWrapperIntegrity(Resource memory resource, IResourceWrapper wrapper) internal view {
        bytes32 resourceKind = resource.kind();
        bytes32 wrapperKind = wrapper.kind();

        if (resourceKind != wrapperKind) {
            revert KindMismatch({ expected: resourceKind, actual: wrapperKind });
        }
    }
}
