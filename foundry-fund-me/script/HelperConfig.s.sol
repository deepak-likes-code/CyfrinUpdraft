//SPDX-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 200000000000;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetwork;

    constructor() {
        if (block.chainid == 1) activeNetwork = SepoliaConfig();
        else activeNetwork = getOrCreateAnvilConfig();
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetwork.priceFeed != address(0)) return activeNetwork;

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        return NetworkConfig(address(mockPriceFeed));
    }

    function SepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }
}
