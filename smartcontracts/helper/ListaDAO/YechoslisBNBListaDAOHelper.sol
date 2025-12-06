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
  slisBNB (Ether.Fi) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IslisBNB {
    function balanceOf(address account) external view returns (uint256);
}

interface IslisBNBPrice {
    function convertSnBnbToBnb(uint256 _amountInSlisBnb) external view returns (uint256);
}

contract YechoslisBNBListaDAOHelper is Ownable {
    IslisBNB public slisBNB;
    IslisBNBPrice public stakingManager;

    event slisBNBAddressUpdated(address newAddress);
    event stakingManagerAddressUpdated(address newAddress);

    constructor(address _slisBNBAddress, address _stakingManagerAddress) Ownable(msg.sender) {
        require(_slisBNBAddress != address(0), "Invalid slisBNB address");
        require(_stakingManagerAddress != address(0), "Invalid stakingManager address");
        slisBNB = IslisBNB(_slisBNBAddress);
        stakingManager = IslisBNBPrice(_stakingManagerAddress);
    }

    function setslisBNBAddress(address _newslisBNBAddress) external onlyOwner {
        require(_newslisBNBAddress != address(0), "Invalid slisBNB address");
        slisBNB = IslisBNB(_newslisBNBAddress);
        emit slisBNBAddressUpdated(_newslisBNBAddress);
    }

    function setstakingManagerAddress(address _newstakingManagerAddress) external onlyOwner {
        require(_newstakingManagerAddress != address(0), "Invalid stakingManager address");
        stakingManager = IslisBNBPrice(_newstakingManagerAddress);
        emit stakingManagerAddressUpdated(_newstakingManagerAddress);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 balance = slisBNB.balanceOf(user);
        uint256 bnbBalance= stakingManager.convertSnBnbToBnb(balance);
        return bnbBalance;
    }
}