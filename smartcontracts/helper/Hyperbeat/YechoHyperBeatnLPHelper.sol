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
  nLP (HyperBeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface InLP {
    function balanceOf(address account) external view returns (uint256);
}

interface InLPPrice {
    function getRate() external view returns (uint256);
}

contract YechoHyperBeatnLPHelper is Ownable {
    InLP public nlp;
    InLPPrice public pricer;

    event NLPAddressUpdated(address newAddress);
    event PricerAddressUpdated(address newAddress);

    constructor(address _nlpAddress, address _pricerAddress) Ownable(msg.sender) {
        require(_nlpAddress != address(0), "Invalid nLP address");
        require(_pricerAddress != address(0), "Invalid pricer address");
        nlp = InLP(_nlpAddress);
        pricer = InLPPrice(_pricerAddress);
    }

    function setNLPAddress(address _newNLPAddress) external onlyOwner {
        require(_newNLPAddress != address(0), "Invalid nLP address");
        nlp = InLP(_newNLPAddress);
        emit NLPAddressUpdated(_newNLPAddress);
    }

    function setPricerAddress(address _newPricerAddress) external onlyOwner {
        require(_newPricerAddress != address(0), "Invalid pricer address");
        pricer = InLPPrice(_newPricerAddress);
        emit PricerAddressUpdated(_newPricerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = nlp.balanceOf(user);
        uint256 price = pricer.getRate();
        return (balance * price) / 1e8;
    }
}