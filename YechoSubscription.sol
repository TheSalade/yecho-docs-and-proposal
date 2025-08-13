//
//  ██    ██ ███████  ██████ ██   ██  ██████  
//   ██  ██  ██      ██      ██   ██ ██    ██ 
//    ████   █████   ██      ███████ ██    ██ 
//     ██    ██      ██      ██   ██ ██    ██ 
//     ██    ███████  ██████ ██   ██  ██████  
//
//  Yecho - Know Your Yield
//  https://www.yecho.app | https://x.com/YechoApp
//  By https://x.com/TRTtheSalad

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YechoSubscription is ReentrancyGuard {
    IERC20 public paymentToken; 
    uint8 public decimals;      
    address public owner;      

    enum Plan { PLAN_1, PLAN_2, PLAN_3 }

    mapping(Plan => uint256) public prices;    
    mapping(Plan => uint256) public durations; 
    mapping(address => uint256) public expiryTime; 

    event Subscribed(address indexed user, uint256 duration, uint256 expiry); 
    event PlanUpdated(Plan plan, uint256 price, uint256 duration);    
    event PaymentTokenUpdated(address newToken, uint8 newDecimals);   
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    constructor(address _paymentToken) {
        owner = msg.sender;
        paymentToken = IERC20(_paymentToken);
        decimals = 6; 
        
        prices[Plan.PLAN_1] = 5;     
        prices[Plan.PLAN_2] = 14;    
        prices[Plan.PLAN_3] = 50;    
        durations[Plan.PLAN_1] = 30 days;
        durations[Plan.PLAN_2] = 90 days;
        durations[Plan.PLAN_3] = 365 days;
    }

    function subscribe(Plan plan) external nonReentrant {
        uint256 price = prices[plan] * 10**decimals; 
        
        require(paymentToken.transferFrom(msg.sender, address(this), price), "Transfer failed");

        if (expiryTime[msg.sender] < block.timestamp) {
            expiryTime[msg.sender] = block.timestamp + durations[plan]; 
        } else {
            expiryTime[msg.sender] += durations[plan]; 
        }
        emit Subscribed(msg.sender, durations[plan], expiryTime[msg.sender]);
    }

    function grantSubscription(address user, uint256 durationInDays) external onlyOwner nonReentrant {
        require(user != address(0), "User cannot be the zero address");
        require(durationInDays > 0, "Duration must be greater than 0");

        uint256 durationInSeconds = durationInDays * 1 days;

        if (expiryTime[user] < block.timestamp) {
            expiryTime[user] = block.timestamp + durationInSeconds;
        } else {
            expiryTime[user] += durationInSeconds; 
        }
        emit Subscribed(user, durationInSeconds, expiryTime[user]);
    }

    function isSubscribed(address user) external view returns (bool) {
        return block.timestamp <= expiryTime[user];
    }

    function getRemainingDays(address user) external view returns (uint256) {
        if (block.timestamp > expiryTime[user]) return 0;
        return (expiryTime[user] - block.timestamp) / 1 days;
    }

    function updatePlan(Plan plan, uint256 newPrice, uint256 newDuration) external onlyOwner {
        prices[plan] = newPrice;
        durations[plan] = newDuration;
        emit PlanUpdated(plan, newPrice, newDuration);
    }

    function updatePaymentToken(address newToken, uint8 newDecimals) external onlyOwner {
        paymentToken = IERC20(newToken);
        decimals = newDecimals;
        emit PaymentTokenUpdated(newToken, newDecimals);
    }

    function withdraw() external onlyOwner nonReentrant {
        uint256 balance = paymentToken.balanceOf(address(this));
        require(paymentToken.transfer(owner, balance), "Withdrawal failed");
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
