// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./mocks/MockEIP4788.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract BeaconVerifier {
    MockEIP4788 public eip4788;

    constructor(address _eip4788) {
        eip4788 = MockEIP4788(_eip4788);
    }

    function verifyValidatorStatus(
        uint256 blockNumber,
        uint256 validatorIndex,
        bool isActive,
        bytes32[] calldata merkleProof
    ) external view returns (bool) {
        bytes32 beaconBlockRoot = eip4788.getBeaconBlockRoot(blockNumber);
        bytes32 leaf = keccak256(abi.encodePacked(validatorIndex, isActive));
        return MerkleProof.verify(merkleProof, beaconBlockRoot, leaf);
    }
}
