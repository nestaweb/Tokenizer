import { expect } from "chai";
import { ethers } from "hardhat";
import { BarcelonaMultiSigToken } from "../typechain-types";

describe("BarcelonaMultiSigToken", function () {
  let multiSigToken: BarcelonaMultiSigToken;
  let owner: any, signer1: any, signer2: any, signer3: any, recipient: any;

  beforeEach(async function () {
    [owner, signer1, signer2, signer3, recipient] = await ethers.getSigners();

    const MultiSigTokenFactory = await ethers.getContractFactory("BarcelonaMultiSigToken");
    multiSigToken = await MultiSigTokenFactory.deploy(owner.address) as BarcelonaMultiSigToken;

    // Add two signers
    await multiSigToken.addSigner(signer1.address);
    await multiSigToken.addSigner(signer2.address);
  });

  it("should have the correct initial supply", async function () {
    const totalSupply = await multiSigToken.totalSupply();
    expect(totalSupply).to.equal(ethers.parseUnits("42000", 18));
  });

  it("should allow the owner to add and remove signers", async function () {
    await multiSigToken.addSigner(signer3.address);
    expect(await multiSigToken.signers(signer3.address)).to.be.true;

    await multiSigToken.removeSigner(signer3.address);
    expect(await multiSigToken.signers(signer3.address)).to.be.false;
  });

  it("should allow a signer to create a transaction", async function () {
    await multiSigToken.connect(signer1).createTransaction(recipient.address, ethers.parseUnits("100", 18));

    const pendingTransactionCount = await multiSigToken.getPendingTransactionCount();
    expect(pendingTransactionCount).to.equal(1);
  });

  it("should allow signers to confirm a transaction", async function () {
    await multiSigToken.connect(signer1).createTransaction(recipient.address, ethers.parseUnits("100", 18));

    await multiSigToken.connect(signer1).confirmTransaction(0);
    const transaction = await multiSigToken.pendingTransactions(0);

    expect(transaction.confirmationCount).to.equal(1);
  });

  it("should execute a transaction once enough confirmations are received", async function () {
    const amount = ethers.parseUnits("100", 18);

    await multiSigToken.connect(signer1).createTransaction(recipient.address, amount);

    await multiSigToken.connect(signer1).confirmTransaction(0);
    await multiSigToken.connect(signer2).confirmTransaction(0);

    const transaction = await multiSigToken.pendingTransactions(0);
    expect(transaction.executed).to.be.true;

    const recipientBalance = await multiSigToken.balanceOf(recipient.address);
    expect(recipientBalance).to.equal(amount);
  });

  it("should not execute a transaction with insufficient confirmations", async function () {
    const amount = ethers.parseUnits("100", 18);

    await multiSigToken.connect(signer1).createTransaction(recipient.address, amount);
    await multiSigToken.connect(signer1).confirmTransaction(0);

    const transaction = await multiSigToken.pendingTransactions(0);
    expect(transaction.executed).to.be.false;

    const recipientBalance = await multiSigToken.balanceOf(recipient.address);
    expect(recipientBalance).to.equal(0);
  });

  it("should emit events for transaction creation, confirmation, and execution", async function () {
    const amount = ethers.parseUnits("100", 18);

    // Test transaction creation event
    await expect(multiSigToken.connect(signer1).createTransaction(recipient.address, amount))
      .to.emit(multiSigToken, "TransactionCreated")
      .withArgs(0, recipient.address, amount);

    // Test transaction confirmation event
    await expect(multiSigToken.connect(signer1).confirmTransaction(0))
      .to.emit(multiSigToken, "TransactionConfirmed");

    // Second confirmation should automatically execute the transaction
    await expect(multiSigToken.connect(signer2).confirmTransaction(0))
      .to.emit(multiSigToken, "TransactionExecuted")
      .withArgs(0, recipient.address, amount);
  });

  it("should allow the owner to update the required number of signatures", async function () {
    await multiSigToken.setRequiredSignatures(3);
    const requiredSigs = await multiSigToken.requiredSignatures();
    expect(requiredSigs).to.equal(3n);
  });

  it("should fail to execute a transaction if required signatures are not met", async function () {
    const amount = ethers.parseUnits("100", 18);

    await multiSigToken.connect(signer1).createTransaction(recipient.address, amount);
    await multiSigToken.connect(signer1).confirmTransaction(0);

    await expect(multiSigToken.executeTransaction(0)).to.be.revertedWith("Not enough confirmations");
  });
});