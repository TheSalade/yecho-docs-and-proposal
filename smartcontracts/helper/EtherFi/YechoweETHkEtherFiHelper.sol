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
  weETHk (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IweETHk {
    function balanceOf(address account) external view returns (uint256);
}

interface IweETHkPrice {
    function getRate() external view returns (uint256);
}

contract YechoweETHkEtherFiHelper is Ownable {
    IweETHk public weETHk;
    IweETHkPrice public pricer;

    event weETHkAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _weETHkAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_weETHkAddress != address(0), "Invalid weETHk address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        weETHk = IweETHk(_weETHkAddress);
        pricer = IweETHkPrice(_pricerAddress);
    }

    function setweETHkAddress(address _newweETHkAddress) external onlyOwner {
        require(_newweETHkAddress != address(0), "Invalid weETHk address");
        weETHk = IweETHk(_newweETHkAddress);
        emit weETHkAddressUpdated(_newweETHkAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IweETHkPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = weETHk.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e18;
    }
}