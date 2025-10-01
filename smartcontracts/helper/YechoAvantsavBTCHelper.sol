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
  savBTC(Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ISavBTC {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoAvantsavBTCHelper is Ownable {
    ISavBTC public savBTC;

    event savBTCAddressUpdated(address newAddress);

    constructor(address _savBTCAddress) Ownable(msg.sender) {
        require(_savBTCAddress != address(0), "Invalid savBTC address");
        savBTC = ISavBTC(_savBTCAddress);
    }

    function setSavBTCAddress(address _newSavBTCAddress) external onlyOwner {
        require(_newSavBTCAddress != address(0), "Invalid savBTC address");
        savBTC = ISavBTC(_newSavBTCAddress);
        emit savBTCAddressUpdated(_newSavBTCAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = savBTC.balanceOf(user);
        return savBTC.convertToAssets(shares);
    }
}