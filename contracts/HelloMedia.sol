// CREATE NEW CONTRACT
// Update this contract based on notes; in the contract, users should only have the ID stored in chain, likes and shares stored locally offchain (adalo). 
// Voting logic should be based on the community in which a user belongs, if a user exchanges tokens the user then gets access to the offchain information.
// Cost is now based on the bytes on the other side of the token and the weighted value of your community. 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract ContentMinting {
    struct File {
        uint256 id;
        uint256 size; // Size in bytes
        string comments;
        uint256 likes;
        uint256 shares;
        address minter;
    }

    struct User {
        uint256 likesGiven;
        bool hasVotingRights;
    }

    uint256 public fileCounter;
    mapping(uint256 => File) public files;
    mapping(address => User) public users;

    // Cost parameters
    uint256 public constant BASE_COST = 0.01 ether; // Base cost for minting
    uint256 public constant BYTE_COST = 0.00001 ether; // Cost per byte
    uint256 public constant CHAR_COST = 0.00002 ether; // Cost per character in comments

    // Event for file minting
    event FileMinted(uint256 fileId, address minter);

    // Mint a new file
    function mintFile(uint256 _size, string memory _comments) external payable {
        uint256 commentLength = bytes(_comments).length;
        uint256 cost = BASE_COST + (_size * BYTE_COST) + (commentLength * CHAR_COST);
        require(msg.value >= cost, "Insufficient funds sent for minting");

        fileCounter++;
        files[fileCounter] = File(fileCounter, _size, _comments, 0, 0, msg.sender);

        emit FileMinted(fileCounter, msg.sender);
    }

    // Like a file
    function likeFile(uint256 _fileId) external {
        File storage file = files[_fileId];
        file.likes++;
        User storage user = users[msg.sender];
        user.likesGiven++;

        // Grant voting rights if user has liked more than 100 times
        if (user.likesGiven > 100 && !user.hasVotingRights) {
            user.hasVotingRights = true;
        }
    }

    // Function to allow voting (details to be implemented)
    function vote(uint256 /*_fileId*/) external view {
        require(users[msg.sender].hasVotingRights, "You do not have voting rights");
        // Voting logic to be implemented
    }

    // Utility function to check the cost for minting a file
    function checkMintingCost(uint256 _size, string memory _comments) public pure returns (uint256) {
        uint256 commentLength = bytes(_comments).length;
        return BASE_COST + (_size * BYTE_COST) + (commentLength * CHAR_COST);
    }
}
