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
  hbVLP (Hyperbeat) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IhbVLP {
    function balanceOf(address account) external view returns (uint256);
}

interface IDataFeed {
    function getDataInBase18() external view returns (uint256);
}

interface IHyperbeatVault {
    function mTokenDataFeed() external view returns (address);
}

contract YechoHyperBeatVLPHelper is Ownable {
    IhbVLP public hbVLP;
    IHyperbeatVault public hbVault;
    address public VLP;
    uint256 public VLP_DECIMALS; 
    uint256 public HBVLP_DECIMALS; 

    event HbVaultAddressUpdated(address newAddress);
    event VLPAddressUpdated(address newAddress);
    event HbVLPAddressUpdated(address newAddress);
    event VLPDecimalsUpdated(uint256 newDecimals); 
    event HbVLPDecimalsUpdated(uint256 newDecimals); 

    constructor(
        address _hbVLP,
        address _hbVault,
        address _VLP
    ) Ownable(msg.sender) {
        require(_hbVLP != address(0), "Invalid hbVLP address");
        require(_hbVault != address(0), "Invalid hbVault address");
        require(_VLP != address(0), "Invalid VLP address");
        hbVLP = IhbVLP(_hbVLP);
        hbVault = IHyperbeatVault(_hbVault);
        VLP = _VLP;
        VLP_DECIMALS = 6;
        HBVLP_DECIMALS = 18;
        emit HbVLPAddressUpdated(_hbVLP);
        emit HbVaultAddressUpdated(_hbVault);
        emit VLPAddressUpdated(_VLP);
        emit VLPDecimalsUpdated(VLP_DECIMALS);
        emit HbVLPDecimalsUpdated(HBVLP_DECIMALS);
    }

    function setHbVLP(address _newHbVLP) external onlyOwner {
        require(_newHbVLP != address(0), "Invalid hbVLP address");
        hbVLP = IhbVLP(_newHbVLP);
        emit HbVLPAddressUpdated(_newHbVLP);
    }

    function setHbVault(address _newHbVault) external onlyOwner {
        require(_newHbVault != address(0), "Invalid hbVault address");
        hbVault = IHyperbeatVault(_newHbVault);
        emit HbVaultAddressUpdated(_newHbVault);
    }

    function setVLP(address _newVLP) external onlyOwner {
        require(_newVLP != address(0), "Invalid VLP address");
        VLP = _newVLP;
        emit VLPAddressUpdated(_newVLP);
    }

    function setVLPDecimals(uint256 _newVLPDecimals) external onlyOwner {
        require(_newVLPDecimals > 0, "Invalid VLP decimals");
        VLP_DECIMALS = _newVLPDecimals;
        emit VLPDecimalsUpdated(_newVLPDecimals);
    }

    function setHbVLPDecimals(uint256 _newHbVLPDecimals) external onlyOwner {
        require(_newHbVLPDecimals > 0, "Invalid hbVLP decimals");
        HBVLP_DECIMALS = _newHbVLPDecimals;
        emit HbVLPDecimalsUpdated(_newHbVLPDecimals);
    }

    function getHelper(address user) external view returns (uint256 VLPAmount) {
        uint256 hbBalance = hbVLP.balanceOf(user);
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

        VLPAmount = (hbBalance * priceUsd) / (10 ** HBVLP_DECIMALS);
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