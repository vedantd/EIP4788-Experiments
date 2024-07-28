// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MockEIP4788 {
    mapping(uint256 => bytes32) private beaconBlockRoots;
    uint256 private currentBlockNumber;

    function setBeaconBlockRoot(uint256 blockNumber, bytes32 root) external {
        beaconBlockRoots[blockNumber] = root;
    }

    function getBeaconBlockRoot(
        uint256 blockNumber
    ) external view returns (bytes32) {
        require(
            blockNumber <= currentBlockNumber &&
                blockNumber > currentBlockNumber - 8192,
            "Block number out of range"
        );
        return beaconBlockRoots[blockNumber];
    }

    function setCurrentBlockNumber(uint256 blockNumber) external {
        currentBlockNumber = blockNumber;
    }
}
