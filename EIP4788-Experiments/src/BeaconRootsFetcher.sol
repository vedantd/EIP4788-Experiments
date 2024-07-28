// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BeaconRootsFetcher {
    address constant BEACON_ROOTS_ADDRESS =
        0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02;

    event BeaconRootFetched(uint256 timestamp, bytes32 root);

    function getBeaconBlockRoot(uint256 timestamp) public returns (bytes32) {
        require(timestamp > 0, "Timestamp must be greater than 0");

        (bool success, bytes memory data) = BEACON_ROOTS_ADDRESS.staticcall(
            abi.encode(timestamp)
        );
        require(success, "Failed to fetch beacon root");

        bytes32 root = abi.decode(data, (bytes32));
        emit BeaconRootFetched(timestamp, root);
        return root;
    }

    function getLatestBeaconBlockRoot() public returns (bytes32) {
        return getBeaconBlockRoot(block.timestamp);
    }

    function getMultipleRoots(
        uint256[] memory timestamps
    ) public returns (bytes32[] memory) {
        bytes32[] memory roots = new bytes32[](timestamps.length);
        for (uint i = 0; i < timestamps.length; i++) {
            roots[i] = getBeaconBlockRoot(timestamps[i]);
        }
        return roots;
    }

    function getCurrentBlockDetails()
        public
        view
        returns (uint256 timestamp, uint256 blockNumber)
    {
        return (block.timestamp, block.number);
    }
}
