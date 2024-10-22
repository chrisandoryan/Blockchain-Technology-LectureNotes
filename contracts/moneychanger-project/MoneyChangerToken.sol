// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MoneyChangerToken is ERC20, Ownable {
    constructor() ERC20("MoneyChangerToken", "MCT") {
        uint256 initialSupply = 1_000_000 * (10 ** decimals()); // 1,000,000 tokens with 18 decimals
        _mint(msg.sender, initialSupply); // Mint the entire supply to the contract owner
    }
}
