// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    
    uint256 public constant STARTING_BALANCE = 100 ether;
    
    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

    }

    function testAllowance() public {
    address owner = msg.sender;
    address spender = address(0x1234567890abcdef);
    uint256 amount = 100;

    // Set the allowance.
    vm.prank(msg.sender);
    ourToken.approve(address(this), amount);

    // Check that the allowance is correct.
    //  assertEq(ourToken.allowance(address(this), spender), amount);

    // Transfer tokens from the owner to the spender.
    
    ourToken.transferFrom(msg.sender, spender, amount);

    // Check that the balance of the spender is correct.
    assertEq(ourToken.balanceOf(spender), amount);
}

function testTransfer() public {
    address sender = address(this);
    address recipient = address(0x1234567890abcdef);
    uint256 amount = 100;

    // Transfer tokens from the sender to the recipient.
    vm.prank(msg.sender);
    ourToken.transfer(recipient, amount);

    // Check that the balance of the recipient is correct.
    assertEq(ourToken.balanceOf(recipient), amount);
}
}