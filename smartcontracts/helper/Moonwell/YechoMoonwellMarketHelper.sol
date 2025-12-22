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
  Lending (Moonwell market) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IMToken {
    function balanceOf(address account) external view returns (uint256);
    function exchangeRateStored() external view returns (uint256);  
}

contract YechoMoonwellMarketHelper is Ownable {
    IMToken public mToken;
    uint256 public scale = 1e18;

    event MTokenAddressUpdated(address newAddress);
    event ScaleUpdated(uint256 newScale);

    constructor(address _mTokenAddress) Ownable(msg.sender) {
        require(_mTokenAddress != address(0), "Invalid mToken address");
        mToken = IMToken(_mTokenAddress);
    }

    function setMTokenAddress(address _newMTokenAddress) external onlyOwner {
        require(_newMTokenAddress != address(0), "Invalid mToken address");
        mToken = IMToken(_newMTokenAddress);
        emit MTokenAddressUpdated(_newMTokenAddress);
    }

    function setScale(uint256 _newScale) external onlyOwner {
        require(_newScale > 0, "Invalid scale");
        scale = _newScale;
        emit ScaleUpdated(_newScale);
    }

    function getHelper(address user) external view returns (uint256 userBalance) {
        uint256 balance = mToken.balanceOf(user);
        uint256 rate = mToken.exchangeRateStored(); 
        return (balance * rate) / scale;
    }
}