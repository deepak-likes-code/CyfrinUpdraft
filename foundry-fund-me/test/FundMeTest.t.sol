//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundTestMe is Test {
    FundMe public fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinUSDIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5");
    }

    function testOwnerIsMsgSender() public {
        console.log("Owner is %s", fundMe.i_owner());
        console.log("Owner is %s", msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }



}
