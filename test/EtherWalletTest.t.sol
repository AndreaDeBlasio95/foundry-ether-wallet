// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/EtherWallet.sol";
import "forge-std/console.sol";

contract EtherWalletTest is Test {
    EtherWallet private etherWallet;
    address private owner;
    address private alice;
    address private bob;

    function setUp() public {
        // Deploy the EtherWallet contract
        etherWallet = new EtherWallet();

        // Assign test addresses
        owner = address(this); // The contract deployer
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        // Pre-fund Alice and Bob
        vm.deal(alice, 10 ether);
        vm.deal(bob, 5 ether);
        vm.deal(owner, 0 ether);

        emit log_address(owner); // Log the initial owner address
        emit log_address(address(etherWallet)); // Log the initial owner address
        emit log_address(alice); // Log Alice's address
        emit log_address(bob); // Log Bob's address
    }
    // Accept incoming Ether transfers

    receive() external payable {}
    fallback() external payable {}

    function testInitialOwner() public view {
        assertEq(etherWallet.owner(), owner, "Initial owner is incorrect");
    }

    function testDeposit() public {
        // Alice deposits 1 Ether
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 1 ether}("");
        assertTrue(success, "Deposit failed");

        // Verify that the balance of the EtherWallet is now 1 Ether
        assertEq(address(etherWallet).balance, 1 ether, "Balance is incorrect");
    }

    function testDepositViaFallback() public {
        // Alice deposits 2 Ether using the fallback function
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 2 ether}("Fallback data");
        assertTrue(success, "Failed to send Ether via fallback");

        // Verify that the balance of the EtherWallet is now 2 Ether
        assertEq(address(etherWallet).balance, 2 ether, "Fallback deposit failed");
    }

    function testWithdraw() public {
        // Setup: Alice deposits 3 Ether
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 3 ether}("");
        assertTrue(success, "Deposit failed");

        // Test withdrawal
        etherWallet.withdraw(2 ether);
        emit log_uint(address(etherWallet).balance);

        // Here the balance is expected to be 1 ether after withdrawing 2 ether from the initial 3 ether deposit
        assertEq(address(etherWallet).balance, 1 ether, "Withdraw failed: Incorrect balance in the wallet");
        assertEq(owner.balance, 2 ether, "Withdraw failed: Owner did not receive the correct amount");
    }

    function testWithdrawUsingTransferByOwner() public {
        // Alice deposits 2 Ether
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 2 ether}("");
        assertTrue(success, "Deposit failed");

        // Withdraw 1 Ether by the owner
        etherWallet.withdrawUsingTransfer(1 ether);
        assertEq(address(etherWallet).balance, 1 ether, "Withdraw failed via Transfer");
        assertEq(owner.balance, 1 ether, "Incorrect amount received by the owner");
    }

    function testWithdrawUsingSendByOwner() public {
        // Bob deposits 3 Ether
        vm.prank(bob);
        (bool success,) = address(etherWallet).call{value: 3 ether}("");
        assertTrue(success, "Deposit failed");

        // Withdraw 2 Ether by the owner using `send`
        etherWallet.withdrawUsingSend(2 ether);
        assertEq(address(etherWallet).balance, 1 ether, "Withdraw failed via Send");
        assertEq(owner.balance, 2 ether, "Incorrect amount received by the owner");
    }

    function testWithdrawUsingCallByOwner() public {
        // Alice deposits 4 Ether
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 4 ether}("");
        assertTrue(success, "Deposit failed");

        // Withdraw 3 Ether by the owner using `call`
        etherWallet.withdrawUsingCall(3 ether);
        assertEq(address(etherWallet).balance, 1 ether, "Withdraw failed via Call");
        assertEq(owner.balance, 3 ether, "Incorrect amount received by the owner");
    }

    function testWithdrawFailsForNonOwner() public {
        // Alice deposits 2 Ether
        vm.prank(alice);
        (bool success,) = address(etherWallet).call{value: 2 ether}("");
        assertTrue(success, "Deposit failed");

        // Bob attempts to withdraw Ether
        vm.prank(bob);
        vm.expectRevert("caller is not owner");
        etherWallet.withdraw(1 ether);
    }

    function testChangeOwner() public {
        etherWallet.changeOwner(payable(alice));
        assertEq(etherWallet.owner(), alice, "Owner change failed");

        // Alice changes ownership to Bob
        vm.prank(alice);
        etherWallet.changeOwner(payable(bob));
        assertEq(etherWallet.owner(), bob, "New owner change failed");
    }

    function testChangeOwnerFailsForNonOwner() public {
        // Bob attempts to change ownership to himself
        vm.prank(bob);
        vm.expectRevert("caller is not owner");
        etherWallet.changeOwner(payable(bob));
    }

    function testWithdrawFailsOnInsufficientBalance() public {
        // Bob deposits 1 Ether
        vm.prank(bob);
        (bool success,) = address(etherWallet).call{value: 1 ether}("");
        assertTrue(success, "Deposit failed");

        // Attempt to withdraw more Ether than available
        vm.expectRevert("insufficient balance");
        etherWallet.withdraw(2 ether);
    }
}
