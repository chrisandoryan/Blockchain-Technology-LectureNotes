// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Faucet {
    receive() external payable {}

    function withdraw(uint256 withdrawAmount) public {
        require(withdrawAmount <= 0.1 ether, "Withdraw amount exceeds the limit");

        require(address(this).balance >= withdrawAmount, "Faucet empty, try again later");

        (bool success, ) = msg.sender.call{value: withdrawAmount}("");
        require(success, "Transfer failed.");
    }

    function getFaucetBalance() public view returns (uint256) {
        return address(this).balance;
    }
}