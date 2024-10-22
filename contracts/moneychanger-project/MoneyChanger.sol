// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./MoneyChangerToken.sol"; 

contract MoneyChanger {
    address public owner;
    MoneyChangerToken public token;
    uint public exchangeRate;

    event Exchanged(address indexed user, uint ethAmount, uint tokenAmount);
    event ExchangeRateUpdated(uint newRate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier hasSufficientTokens(uint tokenAmount) {
        require(token.balanceOf(address(this)) >= tokenAmount, "Insufficient tokens available for exchange.");
        _;
    }

    constructor(MoneyChangerToken _token, uint _exchangeRate) {
        owner = msg.sender;
        token = _token;
        exchangeRate = _exchangeRate;
    }

    function exchange() external payable hasSufficientTokens(msg.value * exchangeRate) {
        require(msg.value > 0, "You must send some Ether to exchange.");

        uint tokenAmount = msg.value * exchangeRate;

        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");

        emit Exchanged(msg.sender, msg.value, tokenAmount);
    }

    function updateExchangeRate(uint _newRate) external onlyOwner {
        exchangeRate = _newRate;
        emit ExchangeRateUpdated(_newRate);
    }

    function withdrawEther(uint _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Insufficient Ether balance.");
        payable(owner).transfer(_amount);
    }

    function withdrawTokens(uint _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount, "Insufficient token balance.");
        require(token.transfer(owner, _amount), "Token transfer failed");
    }

    receive() external payable {}
}
