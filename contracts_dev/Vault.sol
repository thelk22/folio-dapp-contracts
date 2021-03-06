// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// Needs to track which coins exist inside a portfolio

contract Vault {
    // assetQuantities: token address => total quantity owned
    mapping(address => uint256) public assetQuantities;
    address portfolioAddress;

    constructor(address[] memory tokenAddresses) {
        portfolioAddress = msg.sender;
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            assetQuantities[tokenAddresses[i]] = 0;
        }
    }

    modifier isPortfolio() {
        require(msg.sender == portfolioAddress);
        _;
    }

    function deposit(address tokenAddress, uint256 amount)
        external
        isPortfolio
    {
        assetQuantities[tokenAddress] += amount;
    }

    function withdraw(
        address tokenAddress,
        address recipient,
        uint256 amount
    ) external isPortfolio {
        assetQuantities[tokenAddress] -= amount;
        IERC20(tokenAddress).transfer(recipient, amount);
    }
}
