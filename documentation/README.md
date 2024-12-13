### **Documentation**

# **42BarcelonaSuperToken with Multisignature Security**

## **Overview**
The **42BarcelonaSuperTokenByNestaweb42 (42BST)** is an ERC20-compliant token deployed on the Ethereum Sepolia Testnet. It includes a **multisignature system** to enhance security for sensitive transactions, requiring multiple authorized signers to approve before execution.

This project was developed as part of the 42 School's "Tokenizer" exercise, showcasing blockchain development skills using Solidity, Hardhat, and OpenZeppelin libraries.

---

## **Features**
1. **ERC20 Token Standard**:
   - Fully compliant with the ERC20 standard for compatibility with wallets and exchanges.
   - Initial supply of **42,000 tokens** minted to the deployer's address.

2. **Multisignature System**:
   - Transactions require at least **two signatures** from authorized signers before execution.
   - Owners can add or remove signers dynamically.

3. **Security**:
   - Built using OpenZeppelin's audited libraries for robust and secure smart contract implementation.
   - Includes checks to prevent unauthorized access and double-spending.

4. **Deployment**:
   - Deployed on the Ethereum Sepolia Testnet for testing purposes.
   - Verified on Etherscan for transparency and accessibility.

---

## **Technical Details**
- **Token Name**: 42BarcelonaSuperTokenByNestaweb
- **Token Symbol**: 42BST
- **Decimals**: 18
- **Initial Supply**: 42,000 tokens
- **Blockchain Network**: Ethereum Sepolia Testnet
- **Contract Address**: `0xaA04Ff5deB3A37df577d85A20E60CbBd292718a3`
- [View on Etherscan](https://sepolia.etherscan.io/address/0xaA04Ff5deB3A37df577d85A20E60CbBd292718a3)

---

## **Folder Structure**
```
├── code/
│   ├── contracts/
│   │   ├── BarcelonaSuperTokenByNestaweb42.sol
│   │   ├── BarcelonaMultiSigToken.sol
│   ├── tests/
│   │   ├── BarcelonaSuperTokenByNestaweb42.ts
│   ├── scripts/
│       ├── deploy.ts
├── deployment/
│   ├── hardhat.config.ts
├── documentation/
│   ├── README.md
```

---

## **How It Works**
### Token Contract (ERC20)
- The `BarcelonaSuperTokenByNestaweb42` contract mints an initial supply of 42,000 tokens to the deployer's address upon deployment.
- The token uses OpenZeppelin's ERC20 implementation for standard functionality like transfers, approvals, and balances.

### Multisignature Contract
- The `BarcelonaMultiSigToken` contract allows only authorized signers to propose and confirm transactions.
- Transactions are executed only when at least two signers approve them.

---

## **Steps to Use**
1. Clone the repository and install dependencies:
    ```bash
    git clone <repository-url>
    cd <repository-folder>
    pnpm install
    ```

2. Compile the contracts:
    ```bash
    npx hardhat compile
    ```

3. Run tests to ensure functionality:
    ```bash
    npx hardhat test
    ```

4. Deploy the contract (see deployment README).

5. Interact with the deployed contract using Hardhat scripts or directly via Etherscan.