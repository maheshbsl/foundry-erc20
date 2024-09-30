// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address Bob = makeAddr("Bob");
    address Alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(Bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(Bob));
    }

    function testAllowanceWorks() public {
        uint256 INITIAL_ALLOWANCE = 100 ether;
        // Bob will allow alice to use up to 1000
        vm.prank(Bob);
        ourToken.approve(Alice, INITIAL_ALLOWANCE);

        // alice will use that from bob
        uint256 transerAmount = 100;
        vm.prank(Alice);
        ourToken.transferFrom(Bob, Alice, transerAmount);

        assertEq(ourToken.balanceOf(Alice), transerAmount);
        assertEq(ourToken.balanceOf(Bob), STARTING_BALANCE - transerAmount);
    }

    function testTransfer() public {
        //transfer() -> transfer tokens from callser to recipent
        vm.prank(Bob);
        uint256 amount = 200;
        ourToken.transfer(Alice, amount);
        assertEq(ourToken.balanceOf(Alice), amount);
    }

    function testTotalSupply() public view {
        uint256 totalSupply = ourToken.totalSupply();
        assertEq(totalSupply, ourToken.balanceOf(msg.sender) + STARTING_BALANCE);
    }

    function testFailInsufficientBalanceTransfer() public {
        vm.prank(Alice);
        uint256 transferAmount = 200 ether; // Alice has 0 tokens, so this should fail
        vm.expectRevert("Insufficient Balance");
        ourToken.transfer(Bob, transferAmount);
    }

    function testAllowance() public {
        uint256 allownaceAmount = 50 ether;

        vm.prank(Bob); // Bob allows alice to spend up to 50 ether
        ourToken.approve(Alice, allownaceAmount);

        // verify allowance
        uint256 allowance = ourToken.allowance(Bob, Alice); // -> 50
        assertEq(allowance, allownaceAmount);
    }
}
