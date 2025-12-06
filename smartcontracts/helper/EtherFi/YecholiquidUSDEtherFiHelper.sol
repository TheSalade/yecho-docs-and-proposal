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
  liquidUSD (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IliquidUSD {
    function balanceOf(address account) external view returns (uint256);
}

interface IliquidUSDPrice {
    function getRate() external view returns (uint256);
}

contract YecholiquidUSDEtherFiHelper is Ownable {
    IliquidUSD public liquidUSD;
    IliquidUSDPrice public pricer;

    event liquidUSDAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _liquidUSDAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_liquidUSDAddress != address(0), "Invalid liquidUSD address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        liquidUSD = IliquidUSD(_liquidUSDAddress);
        pricer = IliquidUSDPrice(_pricerAddress);
    }

    function setliquidUSDAddress(address _newliquidUSDAddress) external onlyOwner {
        require(_newliquidUSDAddress != address(0), "Invalid liquidUSD address");
        liquidUSD = IliquidUSD(_newliquidUSDAddress);
        emit liquidUSDAddressUpdated(_newliquidUSDAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IliquidUSDPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = liquidUSD.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e6;
    }
}