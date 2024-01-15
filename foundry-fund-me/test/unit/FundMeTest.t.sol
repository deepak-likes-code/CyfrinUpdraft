//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundTestMe is StdCheats, Test {
    FundMe public fundMe;
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant SEND_VALUE = 0.1 ether;
    address USER = makeAddr("user");

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinUSDIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5");
    }

    function testOwnerIsMsgSender() public {
        console.log("Owner is %s", fundMe.i_owner());
        console.log("Owner is %s", msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function fundMeFailsWithoutEnoughUSD() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFundAddsFunderToArray() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawByOwner() public funded {
        uint256 ownerBalanceBefore = fundMe.getOwner().balance;
        uint256 contractBalanceBefore = address(fundMe).balance;
        console.log("Owner balance before: %s", ownerBalanceBefore);
        console.log("Contract balance before: %s", contractBalanceBefore);

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, ownerBalanceBefore + contractBalanceBefore);
    }

    function testWithdrawForMultipleFunders() public funded {
        //Arrange

        uint160 funders = 10;

        for (uint160 i = 0; i < funders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerBalanceBefore = fundMe.getOwner().balance;
        uint256 contractBalanceBefore = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, ownerBalanceBefore + contractBalanceBefore);
    }

    function testCheaperWithdrawForMultipleFunders() public funded {
        //Arrange

        uint160 funders = 10;

        for (uint160 i = 0; i < funders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerBalanceBefore = fundMe.getOwner().balance;
        uint256 contractBalanceBefore = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        //Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.getOwner().balance, ownerBalanceBefore + contractBalanceBefore);
    }
}
