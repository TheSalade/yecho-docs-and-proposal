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
  srUSD (Reservoir) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface ISavings {
    function currentPrice() external view returns (uint256);
}

contract YechoReservoirsrUSDHelper is Ownable {
    address public srUSDAddress;
    address public savingsAddress;

    IERC20 public IsrUSD;
    ISavings public Isavings;

    event srUSDAddressUpdated(address newAddress);
    event SavingsAddressUpdated(address newAddress);

    constructor(address _srUSDAddress, address _savingsAddress) Ownable(msg.sender) {
        require(_srUSDAddress != address(0), "Invalid srUSD address");
        require(_savingsAddress != address(0), "Invalid Savings address");
        srUSDAddress = _srUSDAddress;
        savingsAddress = _savingsAddress;
        IsrUSD = IERC20(_srUSDAddress);
        Isavings = ISavings(_savingsAddress);
    }

    function setSrUSDAddress(address _newSrUSDAddress) external onlyOwner {
        require(_newSrUSDAddress != address(0), "Invalid srUSD address");
        srUSDAddress = _newSrUSDAddress;
        IsrUSD = IERC20(_newSrUSDAddress);
        emit srUSDAddressUpdated(_newSrUSDAddress);
    }

    function setSavingsAddress(address _newSavingsAddress) external onlyOwner {
        require(_newSavingsAddress != address(0), "Invalid Savings address");
        savingsAddress = _newSavingsAddress;
        Isavings = ISavings(_newSavingsAddress);
        emit SavingsAddressUpdated(_newSavingsAddress);
    }

    function getHelper(address user) external view returns (uint256 rUSDEquivalent) {
        uint256 srUSDBalance = IsrUSD.balanceOf(user);
        uint256 price = Isavings.currentPrice();

        rUSDEquivalent = (srUSDBalance * price) / 1e8;

        return rUSDEquivalent;
    }
}