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
  GG (Lido) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IVault {
    function balanceOf(address account) external view returns (uint256);
}

interface IAccountant {
    function getRate() external view returns (uint256);
}

contract YechoLidoGGHelper is Ownable {
    IVault public boringVault;
    IAccountant public accountant;
    uint256 public rateDecimals = 18;

    event BoringVaultAddressUpdated(address newAddress);
    event AccountantAddressUpdated(address newAddress);
    event RateDecimalsUpdated(uint256 newDecimals);

    constructor(address _boringVaultAddress, address _accountantAddress) Ownable(msg.sender) {
        require(_boringVaultAddress != address(0), "Invalid BoringVault address");
        require(_accountantAddress != address(0), "Invalid Accountant address");
        boringVault = IVault(_boringVaultAddress);
        accountant = IAccountant(_accountantAddress);
    }

    function setBoringVaultAddress(address _newBoringVaultAddress) external onlyOwner {
        require(_newBoringVaultAddress != address(0), "Invalid BoringVault address");
        boringVault = IVault(_newBoringVaultAddress);
        emit BoringVaultAddressUpdated(_newBoringVaultAddress);
    }

    function setAccountantAddress(address _newAccountantAddress) external onlyOwner {
        require(_newAccountantAddress != address(0), "Invalid Accountant address");
        accountant = IAccountant(_newAccountantAddress);
        emit AccountantAddressUpdated(_newAccountantAddress);
    }

    function setRateDecimals(uint256 _newRateDecimals) external onlyOwner {
        require(_newRateDecimals <= 77, "Decimals too large");
        rateDecimals = _newRateDecimals;
        emit RateDecimalsUpdated(_newRateDecimals);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = boringVault.balanceOf(user);
        uint256 exchangeRate = accountant.getRate();
        return (balance * exchangeRate) / (10 ** rateDecimals);
    }
}