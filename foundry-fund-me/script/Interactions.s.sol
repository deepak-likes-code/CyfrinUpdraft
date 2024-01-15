//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
        fundMe.fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded %s", mostRecentlyDeployed);
    }

    function run() external {
        address mostRecentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployedFundMe);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe fundMe = FundMe(payable(mostRecentlyDeployed));
        fundMe.withdraw();
        vm.stopBroadcast();
        console.log("Withdrew %s", mostRecentlyDeployed);
    }

    function run() external {
        address mostRecentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployedFundMe);
    }
}
