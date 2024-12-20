
### **Deployment**

# **Deployment Guide for 42BarcelonaSuperToken**

This guide outlines the steps required to deploy and verify the `42BarcelonaSuperTokenByNestaweb42` contract on the Ethereum Sepolia Testnet using Hardhat.

---

## **Prerequisites**
1. Clone repository and go in ```code``` folder.
2. Install Hardhat globally:
    ```bash
    pnpm install --global hardhat
    ```

3. Set up an Ethereum wallet (e.g., MetaMask) and fund it with Sepolia testnet ETH from a faucet.

4. Obtain an API key from [Alchemy](https://www.alchemy.com/) or [Infura](https://infura.io/) for Sepolia RPC access.

5. Obtain an Etherscan API key from [Etherscan Developer Portal](https://etherscan.io/apis).

6. Create a `.env` file in your project root with the following variables:
    ```
    PRIVATE_KEY=<your-wallet-private-key>
    ETHERSCAN_API_KEY=<your-etherscan-api-key>
    ```

---

## **Deployment Steps**
1. Initialize Hardhat in your project directory:
    ```bash
    npx hardhat init
    ```
    Then choose the "Create a TypeScript project" option.
    Be careful to remove Lock.sol and Lock.ts files from contracts and test folders and remove ignition folder.

2. Install dependencies:
    ```bash
    pnpm install @openzeppelin/contracts dotenv @nomicfoundation/hardhat-toolbox
    pnpm install -D @typechain/hardhat @typechain/ethers-v6 typechain
    ```

3. Set up your Hardhat configuration (`hardhat.config.ts`):
    ```typescript
    import { HardhatUserConfig } from "hardhat/config";
    import "@nomicfoundation/hardhat-toolbox";
    import "dotenv/config";
    import "@typechain/hardhat";
    import "@nomicfoundation/hardhat-ethers";
    import "@nomicfoundation/hardhat-chai-matchers";

    const config: HardhatUserConfig = {
      solidity: "0.8.20",
      networks: {
        sepolia: {
          url: "https://eth-sepolia.g.alchemy.com/v2/jQQuvRb_QQZlb75wH82me_VfiFndzTAQ",
          accounts: [process.env.PRIVATE_KEY!],
        },
      },
      etherscan: {
        apiKey: {
          sepolia: process.env.ETHERSCAN_API_KEY!
        }
      }
    };

    export default config;
    ```

4. Compile the contracts:
    ```bash
    npx hardhat compile
    ```

5. Test the contracts:
    ```bash
    npx hardhat test
    ```
   Example output:
   ```
    BarcelonaMultiSigToken
      ✔ should have the correct initial supply
      ✔ should allow the owner to add and remove signers
      ✔ should allow a signer to create a transaction
      ✔ should allow signers to confirm a transaction
      ✔ should execute a transaction once enough confirmations are received
      ✔ should not execute a transaction with insufficient confirmations
      ✔ should emit events for transaction creation, confirmation, and execution
      ✔ should allow the owner to update the required number of signatures
      ✔ should fail to execute a transaction if required signatures are not met


    9 passing (440ms)
   ```

6. Deploy the contract to Sepolia:
    ```bash
    npx hardhat run scripts/deploy.ts --network sepolia
    ```
   Example output:
   ```
   Deploying contracts with the account: 0x1212e7cF4625CE6f9E94B0dE92e5f98eF7379509
   BarcelonaSuperTokenByNestaweb42 deployed to: 0xaA04Ff5deB3A37df577d85A20E60CbBd292718a3
   ```

7. Verify the contract on Etherscan:
    ```bash
    npx hardhat verify --network sepolia 0xaA04Ff5deB3A37df577d85A20E60CbBd292718a3
    ```
   Example output:
   ```
   Successfully verified contract BarcelonaSuperTokenByNestaweb42 on Etherscan.
   https://sepolia.etherscan.io/address/0xaA04Ff5deB3A37df577d85A20E60CbBd292718a3#code
   ```

---

## **Post-Deployment**
1. Access your contract on Etherscan using the provided link.
2. Confirm that all functions (e.g., `transfer`, `balanceOf`) work as expected via Etherscan's "Write Contract" and "Read Contract" tabs.
3. Share your contract address with stakeholders or integrate it into dApps.

---

## **Common Issues**
1. *Insufficient Gas*: Ensure your wallet has enough Sepolia ETH.
2. *Verification Fails*: Double-check that your constructor arguments match those used during deployment.
3. *RPC Errors*: Verify that your `.env` file contains a valid RPC URL and private key.

---

With this guide, you should be able to deploy and verify your token seamlessly!