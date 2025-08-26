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
  wstETH(Lido) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IwstETH {
    function balanceOf(address account) external view returns (uint256);
    function getStETHByWstETH(uint256 _wstETHAmount) external view returns (uint256);
}

contract YechoLidoWSTETHHelper is Ownable {
    IwstETH public wstETH;

    event WstETHAddressUpdated(address newAddress);

    constructor(address _wstETHAddress) Ownable(msg.sender) {
        require(_wstETHAddress != address(0), "Invalid wstETH address");
        wstETH = IwstETH(_wstETHAddress);
    }

    function setWstETHAddress(address _newWstETHAddress) external onlyOwner {
        require(_newWstETHAddress != address(0), "Invalid wstETH address");
        wstETH = IwstETH(_newWstETHAddress);
        emit WstETHAddressUpdated(_newWstETHAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 wstBalance = wstETH.balanceOf(user);
        return wstETH.getStETHByWstETH(wstBalance);
    }
}
