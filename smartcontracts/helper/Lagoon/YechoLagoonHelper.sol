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
  Lagoon Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function convertToAssets(uint256 shares) external view returns (uint256);
}

contract YechoLagoonHelper is Ownable {
    IERC20 public ERC20;

    event ERC20AddressUpdated(address newAddress);

    constructor(address _ERC20Address) Ownable(msg.sender) {
        require(_ERC20Address != address(0), "Invalid ERC20 address");
        ERC20 = IERC20(_ERC20Address);
    }

    function setERC20Address(address _newERC20Address) external onlyOwner {
        require(_newERC20Address != address(0), "Invalid ERC20 address");
        ERC20 = IERC20(_newERC20Address);
        emit ERC20AddressUpdated(_newERC20Address);
    }

    function getHelper(address user) external view returns (uint256) {
        uint256 shares = ERC20.balanceOf(user);
        return ERC20.convertToAssets(shares);
    }
}