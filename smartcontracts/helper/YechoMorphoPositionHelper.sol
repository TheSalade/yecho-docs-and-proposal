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
  Morpho Position Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
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

contract YechoMorphoPositionHelper is Ownable {
    IMorpho public morpho;

    event MorphoAddressUpdated(address newAddress);

    constructor(address _morphoAddress) Ownable(msg.sender) {
        require(_morphoAddress != address(0), "Invalid Morpho address");
        morpho = IMorpho(_morphoAddress);
    }

    function setMorphoAddress(address _newMorphoAddress) external onlyOwner {
        require(_newMorphoAddress != address(0), "Invalid Morpho address");
        morpho = IMorpho(_newMorphoAddress);
        emit MorphoAddressUpdated(_newMorphoAddress);
    }

    function getHelper(bytes32 marketId, address user) external view returns (uint256 collateral, uint256 debt) {
        Position memory position = morpho.position(marketId, user);
        Market memory market = morpho.market(marketId);

        collateral = position.collateral;
        debt = (market.totalBorrowAssets * position.borrowShares) / market.totalBorrowShares * 1e18;
    }
}