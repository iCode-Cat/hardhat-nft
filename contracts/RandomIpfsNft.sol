// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RandomIpsNft is VRFConsumerBaseV2, ERC721 {
    // When we mint and NFT, we will trigger a Chainlink VRF call to get us a random number
    // using that number, we will get a random NFT
    // Pug, Shiba Inu, St. Bernard

    // users have to pay to mint an NFT
    // the owner of the contract can withdraw the ETH

    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable NUM_WORDS;

    // VRF Helpers
    mapping(uint256 => address) public s_requestIdToSender;

    // NFT variables
    uint256 public s_tokenCounter;

    constructor(
        address vrfCoordinatorV2,
        uint64 subscriptionId,
        bytes32 gasLane,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721("Random IPFS NFT", "RIN") {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_subscriptionId = subscriptionId;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
    }

    function requestNft() public returns (uint256 requestId) {
        requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        s_requestIdToSender[requestId] = msg.sender;
    }

    function fullfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal {
        address dogOwner = s_requestIdToSender[requestId];
        uint256 newTokenId = s_tokenCounter;
        _safeMint(dogOwner, newTokenId);
    }

    function tokenURI(uint256) public view override returns (string memory) {}
}
