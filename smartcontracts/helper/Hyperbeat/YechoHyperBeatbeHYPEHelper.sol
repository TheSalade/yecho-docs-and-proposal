// SPDX-License-Identifier: BSL 1.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
  ██    ██ ███████  ██████ ██   ██  ██████  
   ██  ██  ██      ██      ██   ██ ██    ██ 
    ████   █████   ██      ███████ ██    ██ 
     ██    ██      ██      ██   ██ ██    ██ 
     ██    ███████  ██████ ██   ██  ██████  

  Yecho - Know Your Yield
  hbbeHYPE (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhbbeHYPE {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatbeHYPEHelper is Ownable {
    IhbbeHYPE public hbbeHYPE;
    IHyperbeatVault public hbVault;
    address public beHYPE;
    uint256 public beHYPE_DECIMALS; 
    uint256 public HBbeHYPE_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event beHYPEAddressUpdated(address newAddress);
    event HbbeHYPEAddressUpdated(address newAddress);
    event beHYPEDecimalsUpdated(uint256 newDecimals); 
    event HbbeHYPEDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hbbeHYPE,
        address _hbVault,
        address _beHYPE
    ) Ownable(msg.sender) {
        require(_hbbeHYPE != address(0), "Invalid hbbeHYPE address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_beHYPE != address(0), "Invalid beHYPE address");
        hbbeHYPE = IhbbeHYPE(_hbbeHYPE);
        hbVault = IHyperbeatVault(_hbVault);
        beHYPE = _beHYPE;
        beHYPE_DECIMALS = 6;
        HBbeHYPE_DECIMALS = 18;
        emit HbbeHYPEAddressUpdated(_hbbeHYPE);
        emit HbVaultAddressUpdated(_hbVault);
        emit beHYPEAddressUpdated(_beHYPE);
        emit beHYPEDecimalsUpdated(beHYPE_DECIMALS);
        emit HbbeHYPEDecimalsUpdated(HBbeHYPE_DECIMALS);
    }

    function setHbbeHYPE(address _newHbbeHYPE) external onlyOwner {
        require(_newHbbeHYPE != address(0), "Invalid hbbeHYPE address");
        hbbeHYPE = IhbbeHYPE(_newHbbeHYPE);
        emit HbbeHYPEAddressUpdated(_newHbbeHYPE);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setbeHYPE(address _newbeHYPE) external onlyOwner {
        require(_newbeHYPE != address(0), "Invalid beHYPE address");
        beHYPE = _newbeHYPE;
        emit beHYPEAddressUpdated(_newbeHYPE);
    }

    function setbeHYPEDecimals(uint256 _newbeHYPEDecimals) external onlyOwner {
        require(_newbeHYPEDecimals > 0, "Invalid beHYPE decimals");
        beHYPE_DECIMALS = _newbeHYPEDecimals;
        emit beHYPEDecimalsUpdated(_newbeHYPEDecimals);
    }

    function setHbbeHYPEDecimals(uint256 _newHbbeHYPEDecimals) external onlyOwner {
        require(_newHbbeHYPEDecimals > 0, "Invalid hbbeHYPE decimals");
        HBbeHYPE_DECIMALS = _newHbbeHYPEDecimals;
        emit HbbeHYPEDecimalsUpdated(_newHbbeHYPEDecimals);
    }

    function getHelper(address user) external view returns (uint256 beHYPEAmount) {
        uint256 hbBalance = hbbeHYPE.balanceOf(user);
        if (hbBalance == 0) {
            return 0;
        }

        address dataFeedAddr = hbVault.mTokenDataFeed();
        if (dataFeedAddr == address(0)) {
            return 0;
        }

        uint256 priceUsd;
        try IDataFeed(dataFeedAddr).getDataInBase18() returns (uint256 _price) {
            priceUsd = _price;
        } catch {
            return 0;
        }

        if (priceUsd == 0) {
            return 0;
        }

        beHYPEAmount = (hbBalance * priceUsd) / (10 ** HBbeHYPE_DECIMALS);
    }

    function getRate() external view returns (uint256 rate18) {
        address dataFeedAddr = hbVault.mTokenDataFeed();
        if (dataFeedAddr == address(0)) {
            return 0;
        }
        try IDataFeed(dataFeedAddr).getDataInBase18() returns (uint256 price) {
            return price;
        } catch {
            return 0;
        }
    }
}