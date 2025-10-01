// SPDX-License-Identifier: BSL 1.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/*
  ██    ██ ███████  ██████ ██   ██  ██████  
   ██  ██  ██      ██      ██   ██ ██    ██ 
    ████   █████   ██      ███████ ██    ██ 
     ██    ██      ██      ██   ██ ██    ██ 
     ██    ███████  ██████ ██   ██  ██████  

  Yecho - Know Your Yield
  savUSD(Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ISavUSD {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoAvantsavUSDHelper is Ownable {
    ISavUSD public savUSD;

    event savUSDAddressUpdated(address newAddress);

    constructor(address _savUSDAddress) Ownable(msg.sender) {
        require(_savUSDAddress != address(0), "Invalid savUSD address");
        savUSD = ISavUSD(_savUSDAddress);
    }

    function setSavUSDAddress(address _newSavUSDAddress) external onlyOwner {
        require(_newSavUSDAddress != address(0), "Invalid savUSD address");
        savUSD = ISavUSD(_newSavUSDAddress);
        emit savUSDAddressUpdated(_newSavUSDAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = savUSD.balanceOf(user);
        return savUSD.convertToAssets(shares);
    }
}