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
  hbXAUt (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhbXAUt {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatXAUtHelper is Ownable {
    IhbXAUt public hbXAUt;
    IHyperbeatVault public hbVault;
    address public XAUt;
    uint256 public XAUt_DECIMALS; 
    uint256 public HBXAUt_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event XAUtAddressUpdated(address newAddress);
    event HbXAUtAddressUpdated(address newAddress);
    event XAUtDecimalsUpdated(uint256 newDecimals); 
    event HbXAUtDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hbXAUt,
        address _hbVault,
        address _XAUt
    ) Ownable(msg.sender) {
        require(_hbXAUt != address(0), "Invalid hbXAUt address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_XAUt != address(0), "Invalid XAUt address");
        hbXAUt = IhbXAUt(_hbXAUt);
        hbVault = IHyperbeatVault(_hbVault);
        XAUt = _XAUt;
        XAUt_DECIMALS = 6;
        HBXAUt_DECIMALS = 18;
        emit HbXAUtAddressUpdated(_hbXAUt);
        emit HbVaultAddressUpdated(_hbVault);
        emit XAUtAddressUpdated(_XAUt);
        emit XAUtDecimalsUpdated(XAUt_DECIMALS);
        emit HbXAUtDecimalsUpdated(HBXAUt_DECIMALS);
    }

    function setHbXAUt(address _newHbXAUt) external onlyOwner {
        require(_newHbXAUt != address(0), "Invalid hbXAUt address");
        hbXAUt = IhbXAUt(_newHbXAUt);
        emit HbXAUtAddressUpdated(_newHbXAUt);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setXAUt(address _newXAUt) external onlyOwner {
        require(_newXAUt != address(0), "Invalid XAUt address");
        XAUt = _newXAUt;
        emit XAUtAddressUpdated(_newXAUt);
    }

    function setXAUtDecimals(uint256 _newXAUtDecimals) external onlyOwner {
        require(_newXAUtDecimals > 0, "Invalid XAUt decimals");
        XAUt_DECIMALS = _newXAUtDecimals;
        emit XAUtDecimalsUpdated(_newXAUtDecimals);
    }

    function setHbXAUtDecimals(uint256 _newHbXAUtDecimals) external onlyOwner {
        require(_newHbXAUtDecimals > 0, "Invalid hbXAUt decimals");
        HBXAUt_DECIMALS = _newHbXAUtDecimals;
        emit HbXAUtDecimalsUpdated(_newHbXAUtDecimals);
    }

    function getHelper(address user) external view returns (uint256 XAUtAmount) {
        uint256 hbBalance = hbXAUt.balanceOf(user);
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

        XAUtAmount = (hbBalance * priceUsd) / (10 ** HBXAUt_DECIMALS);
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
