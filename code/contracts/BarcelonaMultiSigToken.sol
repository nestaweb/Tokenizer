// SPDX-License-Identifier: MIT
// Specifies the license under which the contract is released. The MIT License is permissive, allowing reuse with minimal restrictions.

pragma solidity ^0.8.0;
// Specifies the Solidity compiler version to use. This contract is compatible with version 0.8.0 and above, but not including 0.9.0.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Imports the ERC20 standard implementation from OpenZeppelin, providing a secure base for creating ERC20 tokens.

import "@openzeppelin/contracts/access/Ownable.sol";
// Imports the Ownable contract from OpenZeppelin, which provides basic authorization control functions, simplifying user permissions.

contract BarcelonaMultiSigToken is ERC20, Ownable {
// Declares a new contract named `BarcelonaMultiSigToken` that inherits from both `ERC20` and `Ownable`, allowing it to use functionalities from both contracts.

    // List of approved signers
    mapping(address => bool) public signers;
    // A mapping to keep track of addresses that are authorized to sign transactions.

    uint256 public requiredSignatures = 2;
    // A constant that specifies the number of signatures required to execute a transaction.

    event TransactionCreated(uint256 indexed txIndex, address indexed to, uint256 amount);
    event TransactionConfirmed(uint256 indexed txIndex, address indexed signer);
    event TransactionExecuted(uint256 indexed txIndex, address indexed to, uint256 amount);


    // Pending transactions
    struct Transaction {
        address to; // The recipient address of the transaction.
        uint256 amount; // The amount of tokens to be transferred.
        bool executed; // A flag indicating whether the transaction has been executed.
        mapping(address => bool) confirmations; // A mapping to track which signers have confirmed the transaction.
        uint256 confirmationCount; // The number of confirmations received for this transaction.
    }
    
    Transaction[] public pendingTransactions;
    // An array to store all pending transactions that have been created but not yet executed.

    constructor(address initialOwner) ERC20("42BarcelonaSuperTokenByNestaweb", "42BST") Ownable(initialOwner) {
    // The constructor initializes the token and sets up ownership.
    // It calls the ERC20 constructor with the token's name and symbol.
    // It also calls the Ownable constructor to set the initial owner.

        // Mint initial supply to contract creator
        _mint(initialOwner, 42000 * 10 ** decimals());
        // Mints 42,000 tokens to the initial owner's address.

        // Add contract creator as initial signer
        signers[initialOwner] = true;
        // Adds the initial owner to the list of authorized signers.
    }

    // Add or remove signers (only owner can do this)
    function addSigner(address _signer) public onlyOwner {
        signers[_signer] = true;
        // Allows the owner to add a new signer by setting their address in the `signers` mapping to true.
    }

    function removeSigner(address _signer) public onlyOwner {
        signers[_signer] = false;
        // Allows the owner to remove a signer by setting their address in the `signers` mapping to false.
    }

    // Create a new pending transaction
    function createTransaction(address _to, uint256 _amount) public {
        require(signers[msg.sender], "Not an authorized signer");

        Transaction storage newTransaction = pendingTransactions.push();
        newTransaction.to = _to;
        newTransaction.amount = _amount;
        newTransaction.executed = false;

        emit TransactionCreated(pendingTransactions.length - 1, _to, _amount);
    }

    // Confirm a pending transaction
    function confirmTransaction(uint256 _txIndex) public {
        require(signers[msg.sender], "Not an authorized signer");
        // Ensures that only authorized signers can confirm transactions.

        Transaction storage transaction = pendingTransactions[_txIndex];
        // Retrieves the transaction from the array using its index.

        require(!transaction.confirmations[msg.sender], "Already confirmed");
        // Checks if this signer has already confirmed this transaction.

        transaction.confirmations[msg.sender] = true;
        transaction.confirmationCount += 1;
        // Marks this transaction as confirmed by this signer and increments the confirmation count.

        emit TransactionConfirmed(_txIndex, msg.sender);
        // Execute if enough signatures
        if (transaction.confirmationCount >= requiredSignatures && !transaction.executed) {
            _transfer(owner(), transaction.to, transaction.amount);
            transaction.executed = true;
            // Transfers tokens if enough confirmations are received and marks it as executed.
            emit TransactionExecuted(_txIndex, transaction.to, transaction.amount);
        }
    }

    function getPendingTransactionCount() public view returns (uint256) {
        return pendingTransactions.length;
    }

    function executeTransaction(uint256 _txIndex) public {
        require(signers[msg.sender], "Not an authorized signer");
        Transaction storage transaction = pendingTransactions[_txIndex];
        require(!transaction.executed, "Transaction already executed");
        require(transaction.confirmationCount >= requiredSignatures, "Not enough confirmations");

        _transfer(owner(), transaction.to, transaction.amount);
        transaction.executed = true;

        emit TransactionExecuted(_txIndex, transaction.to, transaction.amount);
    }

    function setRequiredSignatures(uint256 _signatures) public onlyOwner {
        require(_signatures > 0, "Signatures must be greater than zero");
        requiredSignatures = _signatures;
    }
}
