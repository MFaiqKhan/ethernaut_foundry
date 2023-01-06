// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import "../src/coinflip.sol";
import "../src/CoinflipAttack.sol";

contract CoinFliptest is Test {

    CoinFlip public victimContract; // the victim contract
    CoinFlipAttack public attackerContract; // the attacker contract
    address attacker = address(0x1338);

    function setUp() public {
        // create a new instance of the victim contract
        victimContract = new CoinFlip();
        vm.prank(attacker);
        // create a new instance of the victim contract and pass the address of the victim contract
        attackerContract = new CoinFlipAttack(address(victimContract)); 
    }

    function test_returnBool() public {
        vm.prank(attacker);

        // check if flip function returns true or false
        bool result = attackerContract.flip();
        assertTrue(result == true || result == false);

    }

    // test that attacker contract call victim contract through flip function 
    // and check if the consecutiveWin is incremented
    function test_consecutiveWin() public {
        vm.prank(attacker);
        attackerContract.flip();
        assertEq(victimContract.consecutiveWins(), 1);
    }

    // test multiple consecutiveWin
    function test_multipleConsecutiveWin() public {
        vm.prank(attacker);
        for (uint i = 0; i < 10; i++) {
            // we are incrementing by 1 + i because the whole test function is executed in a single block 
            // and if we increment the block number by 1 + i(first block would be zero if we put i) then the block number will be the same for all the transaction
            vm.roll(1 + i); // we are first incrementing the block number and then passing it to the roll function
            // because the block number is incremented after the transaction is mined
            // but if we pass here the block number after the flip function is called then the block number will be the same
            // and the result of the flip function will be the same and it will give error as block number is not incremented
            attackerContract.flip();
        }
        assertEq(victimContract.consecutiveWins(), 10);
    }
}