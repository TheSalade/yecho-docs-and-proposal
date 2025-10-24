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
  DVV (Lido) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IDVstETH {
    function maxWithdraw(address account) external view returns (uint256);
}

interface IwstETH {
    function getStETHByWstETH(uint256 _wstETHAmount) external view returns (uint256);
}

contract YechoLidoDVVHelper is Ownable {
    IDVstETH public DVstETH;
    IwstETH public wstETH;

    event WstETHAddressUpdated(address newAddress);
    event DVstETHAddressUpdated(address newAddress);

    constructor(address _DVstETHAddress, address _wstETHAddress) Ownable(msg.sender) {
        require(_DVstETHAddress != address(0), "Invalid DVVstETH address");
        require(_wstETHAddress != address(0), "Invalid wstETH address");
        DVstETH = IDVstETH(_DVstETHAddress);
        wstETH = IwstETH(_wstETHAddress);
    }

    function setDVstETHAddress(address _newDVstETHAddress) external onlyOwner {
        require(_newDVstETHAddress != address(0), "Invalid DVstETH address");
        DVstETH = IDVstETH(_newDVstETHAddress);
        emit DVstETHAddressUpdated(_newDVstETHAddress);
    }

    function setWstETHAddress(address _newWstETHAddress) external onlyOwner {
        require(_newWstETHAddress != address(0), "Invalid wstETH address");
        wstETH = IwstETH(_newWstETHAddress);
        emit WstETHAddressUpdated(_newWstETHAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 wstBalance = DVstETH.maxWithdraw(user);
        return wstETH.getStETHByWstETH(wstBalance);
    }
}
