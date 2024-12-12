// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BarcelonaMultiSigToken is ERC20, Ownable {
    // List of approved signers
    mapping(address => bool) public signers;
    uint256 public constant REQUIRED_SIGNATURES = 2;
    
    // Pending transactions
    struct Transaction {
        address to;
        uint256 amount;
        bool executed;
        mapping(address => bool) confirmations;
        uint256 confirmationCount;
    }
    
    Transaction[] public pendingTransactions;

    constructor(address initialOwner) ERC20("42BarcelonaSuperTokenByNestaweb", "42BST") Ownable(initialOwner) {
        // Mint initial supply to contract creator
        _mint(initialOwner, 42000 * 10 ** decimals());
        
        // Add contract creator as initial signer
        signers[initialOwner] = true;
    }

    // Add or remove signers (only owner can do this)
    function addSigner(address _signer) public onlyOwner {
        signers[_signer] = true;
    }

    function removeSigner(address _signer) public onlyOwner {
        signers[_signer] = false;
    }

    // Create a new pending transaction
    function createTransaction(address _to, uint256 _amount) public {
        require(signers[msg.sender], "Not an authorized signer");
        
        uint256 txIndex = pendingTransactions.length;
        Transaction storage newTransaction = pendingTransactions.push();
        
        newTransaction.to = _to;
        newTransaction.amount = _amount;
        newTransaction.executed = false;
    }

    // Confirm a pending transaction
    function confirmTransaction(uint256 _txIndex) public {
        require(signers[msg.sender], "Not an authorized signer");
        Transaction storage transaction = pendingTransactions[_txIndex];
        
        require(!transaction.confirmations[msg.sender], "Already confirmed");
        transaction.confirmations[msg.sender] = true;
        transaction.confirmationCount += 1;

        // Execute if enough signatures
        if (transaction.confirmationCount >= REQUIRED_SIGNATURES && !transaction.executed) {
            _transfer(owner(), transaction.to, transaction.amount);
            transaction.executed = true;
        }
    }
}