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
  hblstHYPE (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhblstHYPE {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatlstHYPEHelper is Ownable {
    IhblstHYPE public hblstHYPE;
    IHyperbeatVault public hbVault;
    address public lstHYPE;
    uint256 public lstHYPE_DECIMALS; 
    uint256 public HBlstHYPE_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event lstHYPEAddressUpdated(address newAddress);
    event HblstHYPEAddressUpdated(address newAddress);
    event lstHYPEDecimalsUpdated(uint256 newDecimals); 
    event HblstHYPEDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hblstHYPE,
        address _hbVault,
        address _lstHYPE
    ) Ownable(msg.sender) {
        require(_hblstHYPE != address(0), "Invalid hblstHYPE address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_lstHYPE != address(0), "Invalid lstHYPE address");
        hblstHYPE = IhblstHYPE(_hblstHYPE);
        hbVault = IHyperbeatVault(_hbVault);
        lstHYPE = _lstHYPE;
        lstHYPE_DECIMALS = 6;
        HBlstHYPE_DECIMALS = 18;
        emit HblstHYPEAddressUpdated(_hblstHYPE);
        emit HbVaultAddressUpdated(_hbVault);
        emit lstHYPEAddressUpdated(_lstHYPE);
        emit lstHYPEDecimalsUpdated(lstHYPE_DECIMALS);
        emit HblstHYPEDecimalsUpdated(HBlstHYPE_DECIMALS);
    }

    function setHblstHYPE(address _newHblstHYPE) external onlyOwner {
        require(_newHblstHYPE != address(0), "Invalid hblstHYPE address");
        hblstHYPE = IhblstHYPE(_newHblstHYPE);
        emit HblstHYPEAddressUpdated(_newHblstHYPE);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setlstHYPE(address _newlstHYPE) external onlyOwner {
        require(_newlstHYPE != address(0), "Invalid lstHYPE address");
        lstHYPE = _newlstHYPE;
        emit lstHYPEAddressUpdated(_newlstHYPE);
    }

    function setlstHYPEDecimals(uint256 _newlstHYPEDecimals) external onlyOwner {
        require(_newlstHYPEDecimals > 0, "Invalid lstHYPE decimals");
        lstHYPE_DECIMALS = _newlstHYPEDecimals;
        emit lstHYPEDecimalsUpdated(_newlstHYPEDecimals);
    }

    function setHblstHYPEDecimals(uint256 _newHblstHYPEDecimals) external onlyOwner {
        require(_newHblstHYPEDecimals > 0, "Invalid hblstHYPE decimals");
        HBlstHYPE_DECIMALS = _newHblstHYPEDecimals;
        emit HblstHYPEDecimalsUpdated(_newHblstHYPEDecimals);
    }

    function getHelper(address user) external view returns (uint256 lstHYPEAmount) {
        uint256 hbBalance = hblstHYPE.balanceOf(user);
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

        lstHYPEAmount = (hbBalance * priceUsd) / (10 ** HBlstHYPE_DECIMALS);
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