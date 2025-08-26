// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @custom:security-contact mhakim@lazymoose.co
contract TinyCoins is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, AccessControlUpgradeable, ERC20PermitUpgradeable {

    constructor() {
        _disableInitializers();
    }

    function initialize(address initialAuthority) public initializer {
        __ERC20_init("Tiny Coins", "LMC");
        __ERC20Burnable_init();
        __AccessControl_init();
        __ERC20Permit_init("Tiny Coins");

        // Grant admin role to the initializer
        _grantRole(DEFAULT_ADMIN_ROLE, initialAuthority);

        // Mint 1 million tokens to the deployer
        _mint(initialAuthority, 1_000_000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(to, amount);
    }
}
