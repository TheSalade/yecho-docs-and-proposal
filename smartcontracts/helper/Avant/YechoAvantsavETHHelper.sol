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
  savETH(Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ISavETH {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoAvantsavETHHelper is Ownable {
    ISavETH public savETH;

    event savETHAddressUpdated(address newAddress);

    constructor(address _savETHAddress) Ownable(msg.sender) {
        require(_savETHAddress != address(0), "Invalid savETH address");
        savETH = ISavETH(_savETHAddress);
    }

    function setSavETHAddress(address _newSavETHAddress) external onlyOwner {
        require(_newSavETHAddress != address(0), "Invalid savETH address");
        savETH = ISavETH(_newSavETHAddress);
        emit savETHAddressUpdated(_newSavETHAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = savETH.balanceOf(user);
        return savETH.convertToAssets(shares);
    }
}