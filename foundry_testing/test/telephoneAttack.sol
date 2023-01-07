// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import "../src/telephone.sol";

contract TelephoneTest is Test {

    Telephone public victimContract; // the victim contract
    TelephoneAttack public attackerContract; // the attacker contract
    address attacker = address(0x1338);

    function setUp() public {
        // create a new instance of the victim contract
        victimContract = new Telephone();
        vm.prank(attacker);
        // create a new instance of the victim contract and pass the address of the victim contract
        attackerContract = new TelephoneAttack(address(victimContract)); 
    }

    function test_changeOwner() public {
        vm.prank(attacker);
        attackerContract.attack(attacker);
        assertEq(victimContract.owner(), attacker);
    }
}