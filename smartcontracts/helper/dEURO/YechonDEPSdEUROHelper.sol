// SPDX-License-Identifier: BSL 1.1
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

/*
  ██    ██ ███████  ██████ ██   ██  ██████  
   ██  ██  ██      ██      ██   ██ ██    ██ 
    ████   █████   ██      ███████ ██    ██ 
     ██    ██      ██      ██   ██ ██    ██ 
     ██    ███████  ██████ ██   ██  ██████  

  Yecho - Know Your Yield
  nDEPS Equity (dEURO) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface InDEPS {
    function balanceOf(address account) external view returns (uint256);
    function price() external view returns (uint256); // retourne le prix avec 18 décimales
}

contract YechonDEPSdEUROHelper is Ownable {
    InDEPS public nDEPS;

    event NDEPSAddressUpdated(address newAddress);

    constructor(address _nDEPS) Ownable(msg.sender) {
        require(_nDEPS != address(0), "Invalid nDEPS address");
        nDEPS = InDEPS(_nDEPS);
    }

    function setNDEPSAddress(address _newNDEPS) external onlyOwner {
        require(_newNDEPS != address(0), "Invalid nDEPS address");
        nDEPS = InDEPS(_newNDEPS);
        emit NDEPSAddressUpdated(_newNDEPS);
    }

    function getHelper(address user) external view returns (uint256 valueInDEURO) {
        uint256 balance = nDEPS.balanceOf(user);
        uint256 price18 = nDEPS.price();

        valueInDEURO = (balance * price18) / 1e18;
    }
}