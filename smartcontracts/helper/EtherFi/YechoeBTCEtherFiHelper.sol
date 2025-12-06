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
  eBTC (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IeBTC {
    function balanceOf(address account) external view returns (uint256);
}

interface IeBTCPrice {
    function getRate() external view returns (uint256);
}

contract YechoeBTCEtherFiHelper is Ownable {
    IeBTC public eBTC;
    IeBTCPrice public pricer;

    event eBTCAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _eBTCAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_eBTCAddress != address(0), "Invalid eBTC address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        eBTC = IeBTC(_eBTCAddress);
        pricer = IeBTCPrice(_pricerAddress);
    }

    function seteBTCAddress(address _neweBTCAddress) external onlyOwner {
        require(_neweBTCAddress != address(0), "Invalid eBTC address");
        eBTC = IeBTC(_neweBTCAddress);
        emit eBTCAddressUpdated(_neweBTCAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IeBTCPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = eBTC.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e8;
    }
}