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
  LBTCv (Lombard) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ILBTCv {
    function balanceOf(address account) external view returns (uint256);
}

interface IAccountant {
    function getRate() external view returns (uint256);
}

contract YechoLombardLBTCvHelper is Ownable {
    ILBTCv public lbtcv;
    IAccountant public accountant;
    uint256 public decimals;

    event VaultUpdated(address indexed newLBTCv, address indexed newAccountant);
    event DecimalsUpdated(uint256 newDecimals);

    constructor(
        address _lbtcv,     
        address _accountant
    ) Ownable(msg.sender) {
        require(_lbtcv != address(0), "Invalid LBTCv");
        require(_accountant != address(0), "Invalid Accountant");
        lbtcv = ILBTCv(_lbtcv);
        accountant = IAccountant(_accountant);
        decimals = 8;
        emit DecimalsUpdated(decimals);
    }

    function updateVault(address _newLBTCv, address _newAccountant) external onlyOwner {
        require(_newLBTCv != address(0), "Invalid LBTCv");
        require(_newAccountant != address(0), "Invalid Accountant");
        lbtcv = ILBTCv(_newLBTCv);
        accountant = IAccountant(_newAccountant);
        emit VaultUpdated(_newLBTCv, _newAccountant);
    }

    function setDecimals(uint256 _newDecimals) external onlyOwner {
        require(_newDecimals > 0, "Invalid decimals");
        decimals = _newDecimals;
        emit DecimalsUpdated(_newDecimals);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = lbtcv.balanceOf(user);
        uint256 rate = accountant.getRate();
        return (shares * rate) / (10 ** decimals); 
    }
}