const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BarcelonaSuperTokenByNestaweb42", function () {
    it("Should deploy with initial supply", async function () {
        const [owner] = await ethers.getSigners();
        const MyToken = await ethers.getContractFactory("BarcelonaMultiSigToken");
        const token = await MyToken.deploy(owner.address);
        
        // Use waitForDeployment() instead of .deployed()
        await token.waitForDeployment();

        // Check initial balance
        const initialSupply = 42000n * 10n ** 18n; // 42,000 tokens with 18 decimals
        expect(await token.balanceOf(owner.address)).to.equal(initialSupply);
    });
});
