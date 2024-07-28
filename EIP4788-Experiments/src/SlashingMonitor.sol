// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SlashingMonitor {
    address constant BEACON_ROOTS_ADDRESS =
        0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02;

    struct SlashingEvent {
        uint256 timestamp;
        bytes32 beaconStateRoot;
        uint256 slashedValidatorsCount;
    }

    SlashingEvent[] public slashingEvents;
    uint256 public totalSlashedValidators;
    uint256 public lastCheckedTimestamp;

    event NewSlashingEvent(uint256 timestamp, uint256 slashedValidatorsCount);

    constructor() {
        lastCheckedTimestamp = block.timestamp;
    }

    function checkForSlashingEvents() public {
        bytes32 currentStateRoot = getLatestBeaconStateRoot();
        uint256 newSlashedValidators = getSlashedValidatorsCount(
            currentStateRoot
        );

        if (newSlashedValidators > totalSlashedValidators) {
            uint256 slashedInThisEvent = newSlashedValidators -
                totalSlashedValidators;
            slashingEvents.push(
                SlashingEvent(
                    block.timestamp,
                    currentStateRoot,
                    slashedInThisEvent
                )
            );
            totalSlashedValidators = newSlashedValidators;

            emit NewSlashingEvent(block.timestamp, slashedInThisEvent);
        }

        lastCheckedTimestamp = block.timestamp;
    }

    function getLatestBeaconStateRoot() public view returns (bytes32) {
        (bool success, bytes memory data) = BEACON_ROOTS_ADDRESS.staticcall(
            abi.encode(block.timestamp)
        );
        require(success, "Failed to fetch beacon root");
        return abi.decode(data, (bytes32));
    }

    // This function is a placeholder and would require off-chain data to work correctly
    function getSlashedValidatorsCount(
        bytes32 stateRoot
    ) public pure returns (uint256) {
        // In a real implementation, this would use the stateRoot to verify
        // off-chain data about the number of slashed validators
        // For this example, we'll return a mock value
        return uint256(uint8(stateRoot[0])); // Just for demonstration
    }

    function getSlashingEventsCount() public view returns (uint256) {
        return slashingEvents.length;
    }

    function getSlashingEvent(
        uint256 index
    ) public view returns (SlashingEvent memory) {
        require(index < slashingEvents.length, "Index out of bounds");
        return slashingEvents[index];
    }

    function getSlashingRate() public view returns (uint256) {
        if (block.timestamp <= lastCheckedTimestamp) return 0;
        uint256 timePeriod = block.timestamp - lastCheckedTimestamp;
        return (totalSlashedValidators * 1e18) / timePeriod; // Slashings per second, scaled by 1e18
    }
}
