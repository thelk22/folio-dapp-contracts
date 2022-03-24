// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Vault.sol";

contract TestPortfolio is ERC20 {
    Vault vault;
    uint256 public ethToTokenRatio;
    address[] public tokenAddresses;
    uint256[] public percentageHoldings;

    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {
        ethToTokenRatio = 1000;
        tokenAddresses.push(0xc778417E063141139Fce010982780140Aa0cD5Ab);
        percentageHoldings.push(100);
        vault = new Vault(tokenAddresses);
    }

    function buy() public payable {
        uint256 tokensToMint = msg.value * ethToTokenRatio;
        vault.deposit(
            0xc778417E063141139Fce010982780140Aa0cD5Ab,
            msg.sender,
            msg.value
        );
        _mint(msg.sender, tokensToMint);
    }

    function sell(uint256 tokensToSell) public {
        uint256 ethToWithdraw = tokensToSell / ethToTokenRatio;
        vault.withdraw(
            0xc778417E063141139Fce010982780140Aa0cD5Ab,
            msg.sender,
            ethToWithdraw
        );
        _burn(msg.sender, tokensToSell);
    }
}
