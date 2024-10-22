// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SalaryToken is ERC20, Ownable {
    // Tax rate (in percentage, for example, 5%)
    uint256 public taxRate = 5;
    // Tax collector address
    address public taxCollector;

    // Initial supply in whole tokens, not in smallest unit (18 decimals by default)
    uint256 private constant INITIAL_SUPPLY = 1000000 * (10 ** 18);

    // Event for salary payment
    event SalaryPaid(address indexed to, uint256 netAmount, uint256 taxAmount);

    // Constructor with token name, symbol, and tax collector address
    constructor(address _taxCollector) ERC20("SalaryToken", "SLRY") Ownable(msg.sender) {
        require(_taxCollector != address(0), "Invalid tax collector address");
        _mint(msg.sender, INITIAL_SUPPLY);
        taxCollector = _taxCollector;
    }

    // Set the tax rate (only owner)
    function setTaxRate(uint256 _taxRate) external onlyOwner {
        require(_taxRate <= 100, "Tax rate cannot exceed 100%");
        taxRate = _taxRate;
    }

    // Set the tax collector address (only owner)
    function setTaxCollector(address _taxCollector) external onlyOwner {
        require(_taxCollector != address(0), "Invalid tax collector address");
        taxCollector = _taxCollector;
    }

    // Salary payment function with automatic tax deduction
    function paySalary(address to, uint256 salaryAmount) external {
        require(to != address(0), "Invalid recipient address");
        require(salaryAmount > 0, "Salary amount must be greater than zero");
        require(balanceOf(msg.sender) >= salaryAmount, "Insufficient balance");

        // Calculate the tax amount
        uint256 taxAmount = (salaryAmount * taxRate) / 100;
        uint256 netSalary = salaryAmount - taxAmount;

        // Transfer net salary to the recipient
        _transfer(msg.sender, to, netSalary);
        // Transfer tax to the tax collector
        _transfer(msg.sender, taxCollector, taxAmount);

        // Emit event
        emit SalaryPaid(to, netSalary, taxAmount);
    }
}
