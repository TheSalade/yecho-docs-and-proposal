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
  USDS(Spark) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface ISparkPSM {
    function previewSwapExactIn(address assetIn, address assetOut, uint256 amountIn) external view returns (uint256);
}

contract YechoSparkUSDSHelper is Ownable {
    address public usdsAddress;
    address public susdsAddress;
    address public psmAddress;

    IERC20 public Isusds;
    ISparkPSM public Ipsm;

    event USDSAddressUpdated(address newAddress);
    event sUSDsAddressUpdated(address newAddress);
    event PSMAddressUpdated(address newAddress);

    constructor(address _usdsAddress, address _susdsAddress, address _psmAddress) Ownable(msg.sender) {
        require(_usdsAddress != address(0), "Invalid USDS address");
        require(_susdsAddress != address(0), "Invalid sUSDS address");
        require(_psmAddress != address(0), "Invalid PSM address");
        usdsAddress = _usdsAddress;
        susdsAddress = _susdsAddress;
        psmAddress = _psmAddress;
        Isusds = IERC20(_susdsAddress);
        Ipsm = ISparkPSM(_psmAddress);
    }

    function setsUSDSAddress(address _newsUSDSAddress) external onlyOwner {
        require(_newsUSDSAddress != address(0), "Invalid sUSDS address");
        susdsAddress = _newsUSDSAddress;
        Isusds = IERC20(_newsUSDSAddress);
        emit USDSAddressUpdated(_newsUSDSAddress);
    }

    function setUSDSAddress(address _newUSDSAddress) external onlyOwner {
        require(_newUSDSAddress != address(0), "Invalid USDS address");
        usdsAddress = _newUSDSAddress;
        emit USDSAddressUpdated(_newUSDSAddress);
    }

    function setPSMAddress(address _newPSMAddress) external onlyOwner {
        require(_newPSMAddress != address(0), "Invalid PSM address");
        psmAddress = _newPSMAddress;
        Ipsm = ISparkPSM(_newPSMAddress);
        emit PSMAddressUpdated(_newPSMAddress);
    }

    function getHelper(address user) external view returns (uint256 usdsEquivalent) {
        uint256 susdsBalance;
        susdsBalance = Isusds.balanceOf(user);

        usdsEquivalent = Ipsm.previewSwapExactIn(susdsAddress, usdsAddress, susdsBalance);

        return (usdsEquivalent);
    }
}
