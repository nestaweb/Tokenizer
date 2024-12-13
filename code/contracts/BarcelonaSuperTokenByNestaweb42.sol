// SPDX-License-Identifier: MIT
// This specifies the license under which the contract is released. The MIT License is a permissive license that allows reuse with minimal restrictions.

pragma solidity ^0.8.20;
// The pragma directive specifies the Solidity compiler version to be used. Here, it indicates compatibility with version 0.8.0 and above, but not including 0.9.0.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// This imports the ERC20 standard implementation from the OpenZeppelin library, providing a secure and community-vetted base for creating ERC20 tokens.

contract BarcelonaSuperTokenByNestaweb42 is ERC20 {
// This line declares a new contract named `BarcelonaSuperTokenByNestaweb42` that inherits from OpenZeppelin's `ERC20` contract, meaning it will have all the functionality of a standard ERC20 token.

    constructor() ERC20("BarcelonaSuperTokenByNestaweb42", "42BST") {
    // The constructor is a special function that runs once upon deployment of the contract.
    // It initializes the ERC20 token by calling the parent ERC20 constructor with the token's name and symbol.
    
        _mint(msg.sender, 42000 * 10 ** decimals());
        // This function mints 42,000 tokens to the deployer's address (`msg.sender`).
    }
}
