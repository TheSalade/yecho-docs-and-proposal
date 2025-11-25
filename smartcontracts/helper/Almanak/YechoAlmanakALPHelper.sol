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
  AUTONOMOUS LIQUIDITY PLUS (Almanak) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IAlmanak {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoAlmanakALPHelper is Ownable {
    IAlmanak public almanak;

    event AlmanakAddressUpdated(address newAddress);

    constructor(address _almanakAddress) Ownable(msg.sender) {
        require(_almanakAddress != address(0), "Invalid Almanak address");
        almanak = IAlmanak(_almanakAddress);
    }

    function setAlmanakAddress(address _newAlmanakAddress) external onlyOwner {
        require(_newAlmanakAddress != address(0), "Invalid Almanak address");
        almanak = IAlmanak(_newAlmanakAddress);
        emit AlmanakAddressUpdated(_newAlmanakAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = almanak.balanceOf(user);
        return almanak.convertToAssets(shares);
    }
}