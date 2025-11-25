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
  avETHx (Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IAvETHxPricing {
    function lastPrice() external view returns (uint256 price, uint256 timestamp);
}

contract YechoAvantavETHxHelper is Ownable {
    IERC20 public avETHx;
    IAvETHxPricing public pricing;

    event AvETHxAddressUpdated(address newAddress);
    event PricingAddressUpdated(address newAddress);

    constructor(address _avETHxAddress, address _pricingAddress) Ownable(msg.sender) {
        require(_avETHxAddress != address(0), "Invalid avETHx address");
        require(_pricingAddress != address(0), "Invalid pricing address");
        avETHx = IERC20(_avETHxAddress);
        pricing = IAvETHxPricing(_pricingAddress);
    }

    function setAvETHxAddress(address _newAvETHxAddress) external onlyOwner {
        require(_newAvETHxAddress != address(0), "Invalid avETHx address");
        avETHx = IERC20(_newAvETHxAddress);
        emit AvETHxAddressUpdated(_newAvETHxAddress);
    }

    function setPricingAddress(address _newPricingAddress) external onlyOwner {
        require(_newPricingAddress != address(0), "Invalid pricing address");
        pricing = IAvETHxPricing(_newPricingAddress);
        emit PricingAddressUpdated(_newPricingAddress);
    }

     function getHelper(address user) external view returns (uint256) {
        uint256 userBalance = avETHx.balanceOf(user);
        (uint256 price, ) = pricing.lastPrice();
        return (userBalance * price) / 1e18;
    }
}