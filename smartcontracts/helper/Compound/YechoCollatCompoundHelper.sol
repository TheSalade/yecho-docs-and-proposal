// SPDX-License-Identifier: BSL 1.1
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

/*
  ██    ██ ███████  ██████ ██   ██  ██████  
   ██  ██  ██      ██      ██   ██ ██    ██ 
    ████   █████   ██      ███████ ██    ██ 
     ██    ██      ██      ██   ██ ██    ██ 
     ██    ███████  ██████ ██   ██  ██████  

  Yecho - Know Your Yield
  Collateral (Compound V3) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface ICompoundV3Comet {
    function userCollateral(address account, address asset)
        external
        view
        returns (uint128 balance, uint128 _reserved);
}

contract YechoCollatCompoundHelper is Ownable {
    address public cometAddress;     
    address public collateralAsset;  
    ICompoundV3Comet public comet;

    event CometAddressUpdated(address indexed newCometAddress);
    event CollateralAssetUpdated(address indexed newCollateralAsset);

    constructor(address _cometAddress, address _collateralAsset) Ownable(msg.sender) {
        require(_cometAddress != address(0), "Invalid Comet address");
        require(_collateralAsset != address(0), "Invalid collateral asset");
        
        cometAddress = _cometAddress;
        collateralAsset = _collateralAsset;
        comet = ICompoundV3Comet(_cometAddress);
    }

    function setCometAddress(address _newCometAddress) external onlyOwner {
        require(_newCometAddress != address(0), "Invalid Comet address");
        cometAddress = _newCometAddress;
        comet = ICompoundV3Comet(_newCometAddress);
        emit CometAddressUpdated(_newCometAddress);
    }

    function setCollateralAsset(address _newCollateralAsset) external onlyOwner {
        require(_newCollateralAsset != address(0), "Invalid collateral asset");
        collateralAsset = _newCollateralAsset;
        emit CollateralAssetUpdated(_newCollateralAsset);
    }

    function getHelper(address user) external view returns (uint256 collateralBalance) {
        (uint128 balance, ) = comet.userCollateral(user, collateralAsset);
        return uint256(balance);
    }

}