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
  stUSDS (Spark) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IStUsds {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoSparkStUsdsHelper is Ownable {
    IStUsds public stUsds;

    event StUsdsAddressUpdated(address newAddress);

    constructor(address _stUsdsAddress) Ownable(msg.sender) {
        require(_stUsdsAddress != address(0), "Invalid stUsds address");
        stUsds = IStUsds(_stUsdsAddress);
    }

    function setStUsdsAddress(address _newStUsdsAddress) external onlyOwner {
        require(_newStUsdsAddress != address(0), "Invalid stUsds address");
        stUsds = IStUsds(_newStUsdsAddress);
        emit StUsdsAddressUpdated(_newStUsdsAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = stUsds.balanceOf(user);
        return stUsds.convertToAssets(shares);
    }
}