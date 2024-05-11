// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EtherWallet {
    address payable public owner;

    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);
    event FailedWithdraw(address indexed to, uint256 amount);
    event OwnerChanged(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not owner");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    // Automatically called when Ether is sent without data
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Fallback function called when unsupported calls occur
    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraws Ether using the `call` method
    function withdraw(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "insufficient balance");

        // Attempt to send using call to avoid gas issues
        (bool success,) = owner.call{value: _amount}("");
        if (success) {
            emit Withdraw(owner, _amount);
        } else {
            emit FailedWithdraw(owner, _amount);
        }
    }

    // Withdraws Ether using the `transfer` method
    function withdrawUsingTransfer(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "insufficient balance");
        owner.transfer(_amount);
        emit Withdraw(owner, _amount);
    }

    // Withdraws Ether using the `send` method
    function withdrawUsingSend(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "insufficient balance");
        bool success = owner.send(_amount);
        require(success, "Send failed");
        emit Withdraw(owner, _amount);
    }

    // Withdraws Ether using the `call` method
    function withdrawUsingCall(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "insufficient balance");
        (bool success,) = owner.call{value: _amount}("");
        require(success, "Call failed");
        emit Withdraw(owner, _amount);
    }

    // Allows changing the wallet's owner
    function changeOwner(address payable _newOwner) external onlyOwner {
        require(_newOwner != address(0), "new owner is the zero address");
        emit OwnerChanged(owner, _newOwner);
        owner = _newOwner;
    }

    // Returns the current Ether balance of the wallet
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
