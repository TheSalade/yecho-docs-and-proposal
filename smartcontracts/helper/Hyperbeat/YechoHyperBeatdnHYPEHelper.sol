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
  dnHYPE (HyperBeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IdnHYPE {
    function balanceOf(address account) external view returns (uint256);
}

interface IdnHYPEPrice {
    function lastAnswer() external view returns (uint256);
}

contract YechoHyperBeatdnHYPEHelper is Ownable {
    IdnHYPE public dnHYPE;
    IdnHYPEPrice public pricer;

    event dnHYPEAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _dnHYPEAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_dnHYPEAddress != address(0), "Invalid dnHYPE address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        dnHYPE = IdnHYPE(_dnHYPEAddress);
        pricer = IdnHYPEPrice(_pricerAddress);
    }

    function setdnHYPEAddress(address _newdnHYPEAddress) external onlyOwner {
        require(_newdnHYPEAddress != address(0), "Invalid dnHYPE address");
        dnHYPE = IdnHYPE(_newdnHYPEAddress);
        emit dnHYPEAddressUpdated(_newdnHYPEAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = IdnHYPEPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = dnHYPE.balanceOf(user);
        uint256 price = pricer.lastAnswer();
        return (balance * price) / 1e8;
    }
}