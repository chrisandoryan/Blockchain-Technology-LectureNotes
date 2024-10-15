// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Faucet.sol";

contract FaucetReceiver {
    receive() external payable {}
    
    Faucet _faucet;

    constructor(address payable _f) {
        _faucet = Faucet(_f);
    }

    function absorbToken() public {
        _faucet.withdraw(1000000000);
    }
}