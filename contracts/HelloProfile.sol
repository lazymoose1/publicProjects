// Update based on new contract logic
// Email/username/country are all offchain

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HelloProfile is ERC20 {
    struct Profile {
        string email;
        string username;
        string country;
    }

    mapping(address => Profile) private profiles;

    constructor() ERC20("New Profile Token", "NPT") {
    }

    function createProfile(string memory _email, string memory _username, string memory _country) external {
        Profile memory newProfile = Profile(_email, _username, _country);
        profiles[msg.sender] = newProfile;
        _mint(msg.sender, 1);
    }

    function getProfile(address _address) external view returns (string memory, string memory, string memory) {
        Profile memory profile = profiles[_address];
        return (profile.email, profile.username, profile.country);
    }
}