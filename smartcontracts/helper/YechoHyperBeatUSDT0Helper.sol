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
  hbUSDT (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhbUSDT {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatUSDT0Helper is Ownable {
    IhbUSDT public hbUSDT;
    IHyperbeatVault public hbVault;
    address public USDT0;
    uint256 public USDT0_DECIMALS; 
    uint256 public HBUSDT_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event USDT0AddressUpdated(address newAddress);
    event HbUSDTAddressUpdated(address newAddress);
    event USDT0DecimalsUpdated(uint256 newDecimals); 
    event HbUSDTDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hbUSDT,
        address _hbVault,
        address _USDT0
    ) Ownable(msg.sender) {
        require(_hbUSDT != address(0), "Invalid hbUSDT address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_USDT0 != address(0), "Invalid USDT0 address");
        hbUSDT = IhbUSDT(_hbUSDT);
        hbVault = IHyperbeatVault(_hbVault);
        USDT0 = _USDT0;
        USDT0_DECIMALS = 6;
        HBUSDT_DECIMALS = 18;
        emit HbUSDTAddressUpdated(_hbUSDT);
        emit HbVaultAddressUpdated(_hbVault);
        emit USDT0AddressUpdated(_USDT0);
        emit USDT0DecimalsUpdated(USDT0_DECIMALS);
        emit HbUSDTDecimalsUpdated(HBUSDT_DECIMALS);
    }

    function setHbUSDT(address _newHbUSDT) external onlyOwner {
        require(_newHbUSDT != address(0), "Invalid hbUSDT address");
        hbUSDT = IhbUSDT(_newHbUSDT);
        emit HbUSDTAddressUpdated(_newHbUSDT);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setUSDT0(address _newUSDT0) external onlyOwner {
        require(_newUSDT0 != address(0), "Invalid USDT0 address");
        USDT0 = _newUSDT0;
        emit USDT0AddressUpdated(_newUSDT0);
    }

    function setUSDT0Decimals(uint256 _newUSDT0Decimals) external onlyOwner {
        require(_newUSDT0Decimals > 0, "Invalid USDT0 decimals");
        USDT0_DECIMALS = _newUSDT0Decimals;
        emit USDT0DecimalsUpdated(_newUSDT0Decimals);
    }

    function setHbUSDTDecimals(uint256 _newHbUSDTDecimals) external onlyOwner {
        require(_newHbUSDTDecimals > 0, "Invalid hbUSDT decimals");
        HBUSDT_DECIMALS = _newHbUSDTDecimals;
        emit HbUSDTDecimalsUpdated(_newHbUSDTDecimals);
    }

    function getHelper(address user) external view returns (uint256 usdt0Amount) {
        uint256 hbBalance = hbUSDT.balanceOf(user);
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

        usdt0Amount = (hbBalance * priceUsd) / (10 ** HBUSDT_DECIMALS);
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
