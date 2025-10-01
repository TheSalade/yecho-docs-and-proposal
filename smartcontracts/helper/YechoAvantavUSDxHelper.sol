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
  avUSDx (Avant) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IAvUSDxPricing {
    function lastPrice() external view returns (uint256 price, uint256 timestamp);
}

contract YechoAvantavUSDxHelper is Ownable {
    IERC20 public avUSDx;
    IAvUSDxPricing public pricing;

    event AvUSDxAddressUpdated(address newAddress);
    event PricingAddressUpdated(address newAddress);

    constructor(address _avUSDxAddress, address _pricingAddress) Ownable(msg.sender) {
        require(_avUSDxAddress != address(0), "Invalid avUSDx address");
        require(_pricingAddress != address(0), "Invalid pricing address");
        avUSDx = IERC20(_avUSDxAddress);
        pricing = IAvUSDxPricing(_pricingAddress);
    }

    function setAvUSDxAddress(address _newAvUSDxAddress) external onlyOwner {
        require(_newAvUSDxAddress != address(0), "Invalid avUSDx address");
        avUSDx = IERC20(_newAvUSDxAddress);
        emit AvUSDxAddressUpdated(_newAvUSDxAddress);
    }

    function setPricingAddress(address _newPricingAddress) external onlyOwner {
        require(_newPricingAddress != address(0), "Invalid pricing address");
        pricing = IAvUSDxPricing(_newPricingAddress);
        emit PricingAddressUpdated(_newPricingAddress);
    }

     function getHelper(address user) external view returns (uint256) {
        uint256 userBalance = avUSDx.balanceOf(user);
        (uint256 price, ) = pricing.lastPrice();
        return (userBalance * price) / 1e18;
    }
}