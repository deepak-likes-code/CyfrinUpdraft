//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeIntegrationTest is Test{
FundMe fundMe;
uint256 constant STARTING_BALANCE = 10 ether;
address USER =makeAddr("user");
uint256 constant gasPrice=1;





    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
         fundMe = deployFundMe.run();
    vm.deal(USER, STARTING_BALANCE);
    }

    function testUserInteractions() external{
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);

    }

}
