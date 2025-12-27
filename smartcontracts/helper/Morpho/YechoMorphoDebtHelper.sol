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
  Morpho Debt Helper Smartcontract

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

contract YechoMorphoDebtHelper is Ownable {
    IMorpho public morpho;
    bytes32 public marketId;

    event MorphoAddressUpdated(address newAddress);
    event MarketIdUpdated(bytes32 newMarketId);

    constructor(address _morphoAddress, bytes32 _marketId) Ownable(msg.sender) {
        require(_morphoAddress != address(0), "Invalid Morpho address");
        morpho = IMorpho(_morphoAddress);
        marketId = _marketId;
    }

    function setMorphoAddress(address _newMorphoAddress) external onlyOwner {
        require(_newMorphoAddress != address(0), "Invalid Morpho address");
        morpho = IMorpho(_newMorphoAddress);
        emit MorphoAddressUpdated(_newMorphoAddress);
    }

    function setMarketId(bytes32 _newMarketId) external onlyOwner {
        marketId = _newMarketId;
        emit MarketIdUpdated(_newMarketId);
    }

    function getHelper(address user) external view returns (uint256 debt) {
        Position memory position = morpho.position(marketId, user);
        Market memory market = morpho.market(marketId);
        if (market.totalBorrowShares == 0) {
            return 0;
        }
        return ((uint256(position.borrowShares) * uint256(market.totalBorrowAssets)) / uint256(market.totalBorrowShares));
    }
}