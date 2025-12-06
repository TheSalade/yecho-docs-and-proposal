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
  vkHYPE (Kinetiq) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IvkHYPE {
    function balanceOf(address account) external view returns (uint256);
}

interface IvkHYPEPrice {
    function getRate() external view returns (uint256);
}

contract YechovkHYPEKinetiqHelper is Ownable {
    IvkHYPE public vkHYPE;
    IvkHYPEPrice public pricer;

    event vkHYPEAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _vkHYPEAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_vkHYPEAddress != address(0), "Invalid vkHYPE address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        vkHYPE = IvkHYPE(_vkHYPEAddress);
        pricer = IvkHYPEPrice(_pricerAddress);
    }

    function setvkHYPEAddress(address _newvkHYPEAddress) external onlyOwner {
        require(_newvkHYPEAddress != address(0), "Invalid vkHYPE address");
        vkHYPE = IvkHYPE(_newvkHYPEAddress);
        emit vkHYPEAddressUpdated(_newvkHYPEAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IvkHYPEPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = vkHYPE.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e18;
    }
}