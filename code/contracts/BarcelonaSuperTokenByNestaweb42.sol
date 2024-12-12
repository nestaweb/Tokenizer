// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BarcelonaSuperTokenByNestaweb42 is ERC20 {
    constructor() ERC20("BarcelonaSuperTokenByNestaweb42", "42BST") {
        _mint(msg.sender, 42000 * 10 ** decimals());
    }
}
