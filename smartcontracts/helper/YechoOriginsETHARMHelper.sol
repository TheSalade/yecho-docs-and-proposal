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
  stETH ARM (Origin) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IstETHARM {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoOriginsETHARMHelper is Ownable {
    IstETHARM public stETHARM;

    event stETHARMAddressUpdated(address newAddress);

    constructor(address _stETHARMAddress) Ownable(msg.sender) {
        require(_stETHARMAddress != address(0), "Invalid stETHARM address");
        stETHARM = IstETHARM(_stETHARMAddress);
    }

    function setstETHARMAddress(address _newstETHARMAddress) external onlyOwner {
        require(_newstETHARMAddress != address(0), "Invalid stETHARM address");
        stETHARM = IstETHARM(_newstETHARMAddress);
        emit stETHARMAddressUpdated(_newstETHARMAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = stETHARM.balanceOf(user);
        return stETHARM.convertToAssets(shares);
    }
}