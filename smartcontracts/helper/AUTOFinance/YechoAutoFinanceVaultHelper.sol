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

interface IAutopoolVault {
    function convertToAssets(uint256 shares) external view returns (uint256 assets);
}

contract YechoAutoFinanceVaultHelper is Ownable {
    address public vaultAddress;
    address public rewarderAddress;

    IERC20 public IVault;
    IERC20 public IRewarder;

    event VaultAddressUpdated(address newAddress);
    event RewarderAddressUpdated(address newAddress);

    constructor(address _vaultAddress, address _rewarderAddress) Ownable(msg.sender) {
        require(_vaultAddress != address(0), "Invalid vault address");
        require(_rewarderAddress != address(0), "Invalid rewarder address");
        vaultAddress = _vaultAddress;
        rewarderAddress = _rewarderAddress;
        IVault = IERC20(_vaultAddress);
        IRewarder = IERC20(_rewarderAddress);
    }

    function setVaultAddress(address _newVaultAddress) external onlyOwner {
        require(_newVaultAddress != address(0), "Invalid vault address");
        vaultAddress = _newVaultAddress;
        IVault = IERC20(_newVaultAddress);
        emit VaultAddressUpdated(_newVaultAddress);
    }

    function setRewarderAddress(address _newRewarderAddress) external onlyOwner {
        require(_newRewarderAddress != address(0), "Invalid rewarder address");
        rewarderAddress = _newRewarderAddress;
        IRewarder = IERC20(_newRewarderAddress);
        emit RewarderAddressUpdated(_newRewarderAddress);
    }

    function getHelper(address user) external view returns (uint256 usdEquivalent) {
        uint256 directBalance = IVault.balanceOf(user);
        uint256 stakedBalance = IRewarder.balanceOf(user);

        uint256 totalShares = directBalance + stakedBalance;

        usdEquivalent = IAutopoolVault(vaultAddress).convertToAssets(totalShares);

        return usdEquivalent;
    }
}