import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.provider.getBalance(deployer.address)).toString());

  // Deploy the multisig token contract
  const MultiSigToken = await ethers.getContractFactory("BarcelonaMultiSigToken");
  const multisigToken = await MultiSigToken.deploy(deployer.address);
  await multisigToken.waitForDeployment();
  console.log("Multisig Token deployed to:", await multisigToken.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });