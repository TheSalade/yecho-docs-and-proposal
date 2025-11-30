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
  LBTC (Lombard) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ILBTC {
    function balanceOf(address account) external view returns (uint256);
    function getRate() external view returns (uint256);
}

contract YechoLombardLBTCHelper is Ownable {
    ILBTC public lbtc;

    event LBTCAddressUpdated(address newAddress);

    constructor(address _lbtcAddress) Ownable(msg.sender) {
        require(_lbtcAddress != address(0), "Invalid LBTC address");
        lbtc = ILBTC(_lbtcAddress);
    }

    function setLBTCAddress(address _newLBTCAddress) external onlyOwner {
        require(_newLBTCAddress != address(0), "Invalid LBTC address");
        lbtc = ILBTC(_newLBTCAddress);
        emit LBTCAddressUpdated(_newLBTCAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = lbtc.balanceOf(user);
        uint256 rate = lbtc.getRate();
        return (balance * rate) / 1e18;
    }
}