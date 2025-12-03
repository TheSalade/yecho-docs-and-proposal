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
  dnPUMP (HyperBeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IdnPUMP {
    function balanceOf(address account) external view returns (uint256);
}

interface IdnPUMPPrice {
    function lastAnswer() external view returns (uint256);
}

contract YechoHyperBeatdnPUMPHelper is Ownable {
    IdnPUMP public dnPUMP;
    IdnPUMPPrice public pricer;

    event dnPUMPAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _dnPUMPAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_dnPUMPAddress != address(0), "Invalid dnPUMP address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        dnPUMP = IdnPUMP(_dnPUMPAddress);
        pricer = IdnPUMPPrice(_pricerAddress);
    }

    function setdnPUMPAddress(address _newdnPUMPAddress) external onlyOwner {
        require(_newdnPUMPAddress != address(0), "Invalid dnPUMP address");
        dnPUMP = IdnPUMP(_newdnPUMPAddress);
        emit dnPUMPAddressUpdated(_newdnPUMPAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IdnPUMPPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = dnPUMP.balanceOf(user);
        uint256 price = pricer.lastAnswer();
        return (balance * price) / 1e8;
    }
}