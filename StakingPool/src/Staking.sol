//SPDX-License-Identifier:MIT

pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract staking is ERC20{
    mapping (address => uint) internal staked;
    mapping (address => uint) private stakedFromTS;

    constructor() ERC20("staking", "NGN") {
        _mint(msg.sender, 100000000000);
    }

    function stake(uint amount) external {
        require(amount >= 0, "amount is <= 0");
        require(balanceOf(msg.sender) >= amount, "balance is <= amount");
        _transfer(msg.sender, address(this), amount);
        if (staked[msg.sender] > 0) {
            claim();
        }

        stakedFromTS[msg.sender] = block.timestamp;
        staked[msg.sender] += amount;
    }

    function withdraw(uint amount) external {
        require(amount >= 0, "amount is <= 0");
        require(staked[msg.sender] >= amount, "amount is > staked");
        claim();
        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claim() public {
        require(staked[msg.sender] > 0, "staked is <= 0");
        uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];
        uint rewards = staked[msg.sender] + secondsStaked / 3.154e7;
        _mint(msg.sender, rewards);
        stakedFromTS[msg.sender] = block.timestamp;
    }
}