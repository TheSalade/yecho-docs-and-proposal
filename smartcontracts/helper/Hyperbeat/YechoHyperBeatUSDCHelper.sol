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
  hbUSDC (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhbUSDC {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatUSDCHelper is Ownable {
    IhbUSDC public hbUSDC;
    IHyperbeatVault public hbVault;
    address public USDC;
    uint256 public USDC_DECIMALS; 
    uint256 public HBUSDC_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event USDCAddressUpdated(address newAddress);
    event HbUSDCAddressUpdated(address newAddress);
    event USDCDecimalsUpdated(uint256 newDecimals); 
    event HbUSDCDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hbUSDC,
        address _hbVault,
        address _USDC
    ) Ownable(msg.sender) {
        require(_hbUSDC != address(0), "Invalid hbUSDC address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_USDC != address(0), "Invalid USDC address");
        hbUSDC = IhbUSDC(_hbUSDC);
        hbVault = IHyperbeatVault(_hbVault);
        USDC = _USDC;
        USDC_DECIMALS = 6;
        HBUSDC_DECIMALS = 18;
        emit HbUSDCAddressUpdated(_hbUSDC);
        emit HbVaultAddressUpdated(_hbVault);
        emit USDCAddressUpdated(_USDC);
        emit USDCDecimalsUpdated(USDC_DECIMALS);
        emit HbUSDCDecimalsUpdated(HBUSDC_DECIMALS);
    }

    function setHbUSDC(address _newHbUSDC) external onlyOwner {
        require(_newHbUSDC != address(0), "Invalid hbUSDC address");
        hbUSDC = IhbUSDC(_newHbUSDC);
        emit HbUSDCAddressUpdated(_newHbUSDC);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setUSDC(address _newUSDC) external onlyOwner {
        require(_newUSDC != address(0), "Invalid USDC address");
        USDC = _newUSDC;
        emit USDCAddressUpdated(_newUSDC);
    }

    function setUSDCDecimals(uint256 _newUSDCDecimals) external onlyOwner {
        require(_newUSDCDecimals > 0, "Invalid USDC decimals");
        USDC_DECIMALS = _newUSDCDecimals;
        emit USDCDecimalsUpdated(_newUSDCDecimals);
    }

    function setHbUSDCDecimals(uint256 _newHbUSDCDecimals) external onlyOwner {
        require(_newHbUSDCDecimals > 0, "Invalid hbUSDC decimals");
        HBUSDC_DECIMALS = _newHbUSDCDecimals;
        emit HbUSDCDecimalsUpdated(_newHbUSDCDecimals);
    }

    function getHelper(address user) external view returns (uint256 USDCAmount) {
        uint256 hbBalance = hbUSDC.balanceOf(user);
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

        USDCAmount = (hbBalance * priceUsd) / (10 ** HBUSDC_DECIMALS);
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