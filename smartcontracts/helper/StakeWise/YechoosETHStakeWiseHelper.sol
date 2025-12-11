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
  osETH (StakeWise) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IEthGenesisVault {
    function convertToAssets(uint256 shares) external view returns (uint256 assets);
}

contract YechoosETHStakeWiseHelper is Ownable {
    address public osETHAddress;
    address public vaultAddress;

    IERC20 public osETH;
    IEthGenesisVault public vault;

    event osETHAddressUpdated(address newAddress);
    event VaultAddressUpdated(address newAddress);

    constructor(address _osETHAddress, address _vaultAddress) Ownable(msg.sender) {
        require(_osETHAddress != address(0), "Invalid osETH address");
        require(_vaultAddress != address(0), "Invalid vault address");
        osETHAddress = _osETHAddress;
        vaultAddress = _vaultAddress;
        osETH = IERC20(_osETHAddress);
        vault = IEthGenesisVault(_vaultAddress);
    }

    function setosETHAddress(address _newosETHAddress) external onlyOwner {
        require(_newosETHAddress != address(0), "Invalid osETH address");
        osETHAddress = _newosETHAddress;
        osETH = IERC20(_newosETHAddress);
        emit osETHAddressUpdated(_newosETHAddress);
    }

    function setVaultAddress(address _newVaultAddress) external onlyOwner {
        require(_newVaultAddress != address(0), "Invalid vault address");
        vaultAddress = _newVaultAddress;
        vault = IEthGenesisVault(_newVaultAddress);
        emit VaultAddressUpdated(_newVaultAddress);
    }

    function getHelper(address user) external view returns (uint256 ETHEquivalent) {
        uint256 directBalance = osETH.balanceOf(user);
        ETHEquivalent = vault.convertToAssets(directBalance);
        return ETHEquivalent;
    }
}