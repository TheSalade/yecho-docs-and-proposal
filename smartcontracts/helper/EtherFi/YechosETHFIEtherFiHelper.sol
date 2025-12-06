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
  ETHFI (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IETHFI {
    function balanceOf(address account) external view returns (uint256);
}

interface IETHFIPrice {
    function getRate() external view returns (uint256);
}

contract YechosETHFIEtherFiHelper is Ownable {
    IETHFI public ETHFI;
    IETHFIPrice public pricer;

    event ETHFIAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _ETHFIAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_ETHFIAddress != address(0), "Invalid ETHFI address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        ETHFI = IETHFI(_ETHFIAddress);
        pricer = IETHFIPrice(_pricerAddress);
    }

    function setETHFIAddress(address _newETHFIAddress) external onlyOwner {
        require(_newETHFIAddress != address(0), "Invalid ETHFI address");
        ETHFI = IETHFI(_newETHFIAddress);
        emit ETHFIAddressUpdated(_newETHFIAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IETHFIPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = ETHFI.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e18;
    }
}