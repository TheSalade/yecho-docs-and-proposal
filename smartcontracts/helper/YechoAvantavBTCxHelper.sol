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
  avBTCx (Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IAvBTCxPricing {
    function lastPrice() external view returns (uint256 price, uint256 timestamp);
}

contract YechoAvantavBTCxHelper is Ownable {
    IERC20 public avBTCx;
    IAvBTCxPricing public pricing;

    event AvBTCxAddressUpdated(address newAddress);
    event PricingAddressUpdated(address newAddress);

    constructor(address _avBTCxAddress, address _pricingAddress) Ownable(msg.sender) {
        require(_avBTCxAddress != address(0), "Invalid avBTCx address");
        require(_pricingAddress != address(0), "Invalid pricing address");
        avBTCx = IERC20(_avBTCxAddress);
        pricing = IAvBTCxPricing(_pricingAddress);
    }

    function setAvBTCxAddress(address _newAvBTCxAddress) external onlyOwner {
        require(_newAvBTCxAddress != address(0), "Invalid avBTCx address");
        avBTCx = IERC20(_newAvBTCxAddress);
        emit AvBTCxAddressUpdated(_newAvBTCxAddress);
    }

    function setPricingAddress(address _newPricingAddress) external onlyOwner {
        require(_newPricingAddress != address(0), "Invalid pricing address");
        pricing = IAvBTCxPricing(_newPricingAddress);
        emit PricingAddressUpdated(_newPricingAddress);
    }

     function getHelper(address user) external view returns (uint256) {
        uint256 userBalance = avBTCx.balanceOf(user);
        (uint256 price, ) = pricing.lastPrice();
        return (userBalance * price) / 1e18;
    }
}