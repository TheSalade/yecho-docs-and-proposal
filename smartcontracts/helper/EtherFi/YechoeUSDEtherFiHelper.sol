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
  eUSD (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IeUSD {
    function balanceOf(address account) external view returns (uint256);
}

interface IeUSDPrice {
    function getRate() external view returns (uint256);
}

contract YechoeUSDEtherFiHelper is Ownable {
    IeUSD public eUSD;
    IeUSDPrice public pricer;

    event eUSDAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _eUSDAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_eUSDAddress != address(0), "Invalid eUSD address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        eUSD = IeUSD(_eUSDAddress);
        pricer = IeUSDPrice(_pricerAddress);
    }

    function seteUSDAddress(address _neweUSDAddress) external onlyOwner {
        require(_neweUSDAddress != address(0), "Invalid eUSD address");
        eUSD = IeUSD(_neweUSDAddress);
        emit eUSDAddressUpdated(_neweUSDAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IeUSDPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = eUSD.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e18;
    }
}