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
  WeETH (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IWEETH {
    function balanceOf(address account) external view returns (uint256);
    function getRate() external view returns (uint256);
}

contract YechoweETHEtherfiHelper is Ownable {
    IWEETH public WEETH;

    event WEETHAddressUpdated(address newAddress);

    constructor(address _WEETHAddress) Ownable(msg.sender) {
        require(_WEETHAddress != address(0), "Invalid WEETH address");
        WEETH = IWEETH(_WEETHAddress);
    }

    function setWEETHAddress(address _newWEETHAddress) external onlyOwner {
        require(_newWEETHAddress != address(0), "Invalid WEETH address");
        WEETH = IWEETH(_newWEETHAddress);
        emit WEETHAddressUpdated(_newWEETHAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = WEETH.balanceOf(user);
        uint256 rate = WEETH.getRate();
        return (balance * rate) / 1e18;
    }
}