// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { Time } from "@openzeppelin-contracts/utils/types/Time.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";

/// @title A common functions for arrays.
library ArrayUtils {
    /**
     * @dev Calculates bounds for the slice of the array.
     * @param arrLength An array length.
     * @param start A start index.
     * @param length A length of the slice.
     * @param limit A limit for the length.
     * @return The bounds for the slice of the array.
     */
    function calculateBounds(
        uint256 arrLength,
        uint256 start,
        uint256 length,
        uint256 limit
    )
        internal
        pure
        returns (uint256, uint256)
    {
        require(length > 0, "Length should be greater than 0");
        require(length <= limit, "Length limit exceeded");
        require(start < arrLength, "Start index out of bounds");

        uint256 end = start + length;
        if (end > arrLength) {
            end = arrLength;
        }

        return (start, end);
    }
}

/// @title A sparse merkle tree implementation, which keeps tree history.
// Note that this SMT implementation can manage duplicated roots in the history,
// which may happen when some leaf change its value and then changes it back to the original value.
// Leaves deletion is not supported, although it should be possible to implement it in the future
// versions of this library, without changing the existing state variables
// In this way all the SMT data may be preserved for the contracts already in production.
library RootStorage {
    /**
     * @dev Max return array length for SMT root history requests
     */
    uint256 public constant ROOT_INFO_LIST_RETURN_LIMIT = 1000;

    struct Data {
        RootEntry[] rootEntries;
        mapping(bytes32 root => uint256 index) rootIndices; // root => rootEntryIndex[]
    }

    /**
     * @dev Struct for SMT root internal storage representation.
     * @param root SMT root.
     * @param createdAtTimestamp A time, when the root was saved to blockchain.
     * @param createdAtBlock A number of block, when the root was saved to blockchain.
     */
    struct RootEntry {
        bytes32 root;
        uint48 createdAtTimestamp;
        uint48 createdAtBlock;
    }

    using BinarySearchSmtRoots for Data;
    using ArrayUtils for uint256[];

    /**
     * @dev Reverts if root does not exist in SMT roots history.
     * @param root SMT root.
     */
    modifier onlyExistingRoot(Data storage self, bytes32 root) {
        require(rootExists(self, root), "Root does not exist");
        _;
    }

    /**
     * @dev Get SMT root history length
     * @return SMT history length
     */
    function getRootHistoryLength(Data storage self) external view returns (uint256) {
        return self.rootEntries.length;
    }

    /**
     * @dev Get SMT root history
     * @param startIndex start index of history
     * @param length history length
     * @return results array of RootEntry structs
     */
    function getRootHistory(
        Data storage self,
        uint256 startIndex,
        uint256 length
    )
        external
        view
        returns (RootEntry[] memory results)
    {
        (uint256 start, uint256 end) =
            ArrayUtils.calculateBounds(self.rootEntries.length, startIndex, length, ROOT_INFO_LIST_RETURN_LIMIT);

        results = new RootEntry[](end - start);

        for (uint256 i = start; i < end; i++) {
            results[i - start] = _getRootInfoByIndex(self, i);
        }
    }

    function getRoot(Data storage self) public view returns (bytes32) {
        return self.rootEntries[self.rootEntries.length - 1].root;
    }

    /**
     * @dev Get root info by some historical timestamp.
     * @param timestamp The latest timestamp to get the root info for.
     * @return Root info struct
     */
    function getRootInfoByTime(Data storage self, uint48 timestamp) public view returns (RootEntry memory) {
        require(timestamp <= Time.timestamp(), "No future timestamps allowed");

        (uint256 index, bool found) = self.binarySearchTimestamp(timestamp);

        // As far as we always have at least one root entry, we should always find it
        assert(found); // TODO throw custom error

        return _getRootInfoByIndex(self, index);
    }

    /**
     * @dev Get root info by some historical block number.
     * @param blockNumber The latest block number to get the root info for.
     * @return Root info struct
     */
    // TODO why passed as storage?
    function getRootInfoByBlock(Data storage self, uint48 blockNumber) public view returns (RootEntry memory) {
        require(blockNumber <= block.number, "No future blocks allowed");

        (uint256 index, bool found) = self.binarySearchBlockNumber(blockNumber);

        // As far as we always have at least one root entry, we should always find it
        assert(found); // TODO throw error

        return _getRootInfoByIndex(self, index);
    }

    /**
     * @dev Returns root info by root
     * @param root root
     * @return Root info struct
     */
    function getRootInfo(
        Data storage self,
        bytes32 root
    )
        public
        view
        onlyExistingRoot(self, root)
        returns (RootEntry memory)
    {
        uint256 index = self.rootIndices[root];
        return _getRootInfoByIndex(self, index);
    }

    /**
     * @dev Checks if root exists
     * @param root root
     * return true if root exists
     */
    function rootExists(Data storage self, bytes32 root) public view returns (bool) {
        return self.rootIndices[root] > 0;
    }

    function _getRootInfoByIndex(Data storage self, uint256 index) internal view returns (RootEntry memory rootEntry) {
        rootEntry = self.rootEntries[index];
    }

    function _addEntry(Data storage self, bytes32 root, uint48 _timestamp, uint48 _block) internal {
        self.rootEntries.push(RootEntry({ root: root, createdAtTimestamp: _timestamp, createdAtBlock: _block }));

        self.rootIndices[root] = self.rootEntries.length - 1;
    }
}

/// @title A binary search for the sparse merkle tree root history
// Implemented as a separate library for testing purposes
library BinarySearchSmtRoots {
    function binarySearchTimestamp(
        RootStorage.Data storage self,
        uint48 timestamp
    )
        internal
        view
        returns (uint256, bool)
    {
        return _binarySearch(self, timestamp, getTimestamp);
    }

    function binarySearchBlockNumber(
        RootStorage.Data storage self,
        uint48 blockNumber
    )
        internal
        view
        returns (uint256, bool)
    {
        return _binarySearch(self, blockNumber, getBlockNumber);
    }

    /**
     * @dev Binary search method for the SMT history,
     * which searches for the index of the root entry saved by the given timestamp or block
     * @param value The timestamp or block to search for.
     * @param getter The getter function to use.
     */
    function _binarySearch(
        RootStorage.Data storage self,
        uint256 value,
        function(RootStorage.RootEntry memory) pure returns (uint256) getter
    )
        internal
        view
        returns (uint256, bool)
    {
        if (self.rootEntries.length == 0) {
            return (0, false);
        }

        uint256 min = 0;
        uint256 max = self.rootEntries.length - 1;
        uint256 mid;

        while (min <= max) {
            mid = (max + min) / 2;

            uint256 midValue = getter(self.rootEntries[mid]);
            if (midValue == value) {
                while (mid < self.rootEntries.length - 1) {
                    uint256 nextValue = getter(self.rootEntries[mid + 1]);
                    if (nextValue == value) {
                        mid++;
                    } else {
                        return (mid, true);
                    }
                }
                return (mid, true);
            } else if (value > midValue) {
                min = mid + 1;
            } else if (value < midValue && mid > 0) {
                // mid > 0 is to avoid underflow
                max = mid - 1;
            } else {
                // This means that value < midValue && mid == 0. So we found nothing.
                return (0, false);
            }
        }

        // The case when the searched value does not exist and we should take the closest smaller value
        // Index in the "max" var points to the root entry with max value smaller than the searched value
        return (max, true);
    }

    /**
     * @dev Returns the timestamp from the root entry struct
     * depending on the search type
     * @param rti The root entry to get the timestamp from.
     */
    // TODO use calldata
    function getTimestamp(RootStorage.RootEntry memory rti) internal pure returns (uint256) {
        return rti.createdAtTimestamp;
    }

    /**
     * @dev Returns the block number from the root entry struct
     * depending on the search type
     * @param rti The root entry to get the block number from.
     */
    // TODO use calldata
    function getBlockNumber(RootStorage.RootEntry memory rti) internal pure returns (uint256) {
        return rti.createdAtBlock;
    }
}
