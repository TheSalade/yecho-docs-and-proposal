// SPDX-License-Identifier: BSL 1.1
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

/*
  ██    ██ ███████  ██████ ██   ██  ██████  
   ██  ██  ██      ██      ██   ██ ██    ██ 
    ████   █████   ██      ███████ ██    ██ 
     ██    ██      ██      ██   ██ ██    ██ 
     ██    ███████  ██████ ██   ██  ██████  

  Yecho - Know Your Yield
  Mamo Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IMoonwellHelper {
    function getHelper(address user) external view returns (uint256 userBalance);
}

interface IMamoStrategyRegistry {
    function getUserStrategies(address user) external view returns (address[] memory);
}

contract YechoMamoHelper is Ownable {
    IMoonwellHelper public moonwellHelper;      
    IMamoStrategyRegistry public mamoRegistry;

    event MoonwellHelperUpdated(address newAddress);
    event MamoRegistryUpdated(address newAddress);

    constructor(address _moonwellHelper, address _mamoRegistry) Ownable(msg.sender) {
        require(_moonwellHelper != address(0), "Invalid Moonwell helper address");
        require(_mamoRegistry != address(0), "Invalid Mamo registry address");
        moonwellHelper = IMoonwellHelper(_moonwellHelper);
        mamoRegistry = IMamoStrategyRegistry(_mamoRegistry);
    }

    function setMoonwellHelper(address _newHelper) external onlyOwner {
        require(_newHelper != address(0), "Invalid helper address");
        moonwellHelper = IMoonwellHelper(_newHelper);
        emit MoonwellHelperUpdated(_newHelper);
    }

    function setMamoRegistry(address _newRegistry) external onlyOwner {
        require(_newRegistry != address(0), "Invalid registry address");
        mamoRegistry = IMamoStrategyRegistry(_newRegistry);
        emit MamoRegistryUpdated(_newRegistry);
    }

    function getHelper(address user) external view returns (uint256 userBalance) {
        address[] memory strategies = mamoRegistry.getUserStrategies(user);

        if (strategies.length == 0) {
            return 0;
        }

        address strategy = strategies[0];

        return moonwellHelper.getHelper(strategy);
    }
}