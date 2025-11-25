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
  dEURO Savings (dEURO) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IdEUROSavings {
    function savings(address user) external view returns (uint192 saved, uint64 ticks);
    function accruedInterest(address user) external view returns (uint192);
}

contract YechodEUROSavingsHelper is Ownable {
    IdEUROSavings public dEUROSavings;

    event DEUROSavingsAddressUpdated(address newAddress);

    constructor(address _dEUROSavingsAddress) Ownable(msg.sender) {
        require(_dEUROSavingsAddress != address(0), "Invalid dEURO Savings address");
        dEUROSavings = IdEUROSavings(_dEUROSavingsAddress);
    }

    function setDEUROSavingsAddress(address _newDEUROSavingsAddress) external onlyOwner {
        require(_newDEUROSavingsAddress != address(0), "Invalid dEURO Savings address");
        dEUROSavings = IdEUROSavings(_newDEUROSavingsAddress);
        emit DEUROSavingsAddressUpdated(_newDEUROSavingsAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint192 pending = dEUROSavings.accruedInterest(user);
        (uint192 saved, ) = dEUROSavings.savings(user);
        return pending + saved;
    }
}