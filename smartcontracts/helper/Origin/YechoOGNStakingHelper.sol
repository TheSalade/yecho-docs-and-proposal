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
  OGN (Origin) Helper Smartcontract

  https://www.yecho.app | https://x.com/YechoApp
  By https://x.com/TRTtheSalad
*/

interface IExponentialStaking {
    function lockupsCount(address user) external view returns (uint256);
    function lockups(address user, uint256 index) external view returns (
        uint128 amount,
        uint128 end,
        uint256 points
    );
    function previewRewards(address user) external view returns (uint256);
}

contract YechoOGNStakingHelper is Ownable {
    address public stakingAddress;
    IExponentialStaking public staking;

    event StakingAddressUpdated(address indexed newStakingAddress);

    constructor(address _stakingAddress) Ownable(msg.sender) {
        require(_stakingAddress != address(0), "Invalid staking address");
        stakingAddress = _stakingAddress;
        staking = IExponentialStaking(_stakingAddress);
    }

    function setStakingAddress(address _newStakingAddress) external onlyOwner {
        require(_newStakingAddress != address(0), "Invalid staking address");
        stakingAddress = _newStakingAddress;
        staking = IExponentialStaking(_newStakingAddress);
        emit StakingAddressUpdated(_newStakingAddress);
    }

    function getHelper(address user) external view returns (uint256 totalOGN) {
        uint256 totalStaked = 0;

        uint256 count = staking.lockupsCount(user);
        for (uint256 i = 0; i < count; i++) {
            (uint128 amount, uint128 end, ) = staking.lockups(user, i);
            if (end != 0) {
                totalStaked += amount;
            }
        }

        uint256 pendingRewards = staking.previewRewards(user);

        return totalStaked + pendingRewards;
    }
}