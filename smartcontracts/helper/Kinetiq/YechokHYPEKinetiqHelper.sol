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
  kHYPE (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IkHYPE {
    function balanceOf(address account) external view returns (uint256);
}

interface IkHYPEPrice {
    function kHYPEToHYPE(uint256 _amountInkHYPE) external view returns (uint256);
}

contract YechokHYPEKinetiqHelper is Ownable {
    IkHYPE public kHYPE;
    IkHYPEPrice public stakingManager;

    event kHYPEAddressUpdated(address newAddress);
    event stakingManagerAddressUpdated(address newAddress);

    constructor(address _kHYPEAddress, address _stakingManagerAddress) Ownable(msg.sender) {
        require(_kHYPEAddress != address(0), "Invalid kHYPE address");
        require(_stakingManagerAddress != address(0), "Invalid stakingManager address");
        kHYPE = IkHYPE(_kHYPEAddress);
        stakingManager = IkHYPEPrice(_stakingManagerAddress);
    }

    function setkHYPEAddress(address _newkHYPEAddress) external onlyOwner {
        require(_newkHYPEAddress != address(0), "Invalid kHYPE address");
        kHYPE = IkHYPE(_newkHYPEAddress);
        emit kHYPEAddressUpdated(_newkHYPEAddress);
    }

    function setstakingManagerAddress(address _newstakingManagerAddress) external onlyOwner {
        require(_newstakingManagerAddress != address(0), "Invalid stakingManager address");
        stakingManager = IkHYPEPrice(_newstakingManagerAddress);
        emit stakingManagerAddressUpdated(_newstakingManagerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = kHYPE.balanceOf(user);
        uint256 bnbBalance= stakingManager.kHYPEToHYPE(balance);
        return bnbBalance;
    }
}