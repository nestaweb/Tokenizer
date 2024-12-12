import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const MyToken = await ethers.getContractFactory("BarcelonaSuperTokenByNestaweb42");
  const token = await MyToken.deploy();

  await token.waitForDeployment();
  const contractAddress = await token.getAddress();

  console.log("BarcelonaSuperTokenByNestaweb42 deployed to:", contractAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});