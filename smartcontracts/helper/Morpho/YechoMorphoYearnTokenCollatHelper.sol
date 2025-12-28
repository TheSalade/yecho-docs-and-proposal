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
  Morpho Yearn Collateral Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By Lasalad
*/

struct Position {
    uint256 supplyShares;
    uint128 borrowShares;
    uint128 collateral;
}

struct Market {
    uint128 totalSupplyAssets;
    uint128 totalSupplyShares;
    uint128 totalBorrowAssets;
    uint128 totalBorrowShares;
    uint128 lastUpdate;
    uint128 fee;
}

interface IMorpho {
    function position(bytes32 marketId, address user) external view returns (Position memory);
    function market(bytes32 marketId) external view returns (Market memory);
}

interface IYearnVault {
    function convertToAssets(uint256 shares) external view returns (uint256 assets);
}

contract YechoMorphoYearnTokenCollatHelper is Ownable {
    IMorpho public morpho;
    IYearnVault public yearnVault;
    bytes32 public marketId;

    event MorphoAddressUpdated(address newAddress);
    event YearnVaultUpdated(address newAddress);
    event MarketIdUpdated(bytes32 newMarketId);

    constructor(address _morphoAddress, address _yearnVaultAddress, bytes32 _marketId) Ownable(msg.sender) {
        require(_morphoAddress != address(0), "Invalid Morpho address");
        require(_yearnVaultAddress != address(0), "Invalid Yearn vault address");
        morpho = IMorpho(_morphoAddress);
        yearnVault = IYearnVault(_yearnVaultAddress);
        marketId = _marketId;
    }

    function setMorphoAddress(address _newMorphoAddress) external onlyOwner {
        require(_newMorphoAddress != address(0), "Invalid Morpho address");
        morpho = IMorpho(_newMorphoAddress);
        emit MorphoAddressUpdated(_newMorphoAddress);
    }

    function setYearnVaultAddress(address _newYearnVaultAddress) external onlyOwner {
        require(_newYearnVaultAddress != address(0), "Invalid Yearn vault address");
        yearnVault = IYearnVault(_newYearnVaultAddress);
        emit YearnVaultUpdated(_newYearnVaultAddress);
    }

    function setMarketId(bytes32 _newMarketId) external onlyOwner {
        marketId = _newMarketId;
        emit MarketIdUpdated(_newMarketId);
    }

    function getHelper(address user) external view returns (uint256 collateral) {
        Position memory position = morpho.position(marketId, user);
        uint256 shares = position.collateral;
        return yearnVault.convertToAssets(shares);
    }
}