//SPDX-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{

struct NetworkConfig{
    address priceFeed;
}

NetworkConfig public activeNetwork;

constructor(){
if(block.chainid==1){
activeNetwork= SepoliaConfig();
}else{
activeNetwork= AnvilConfig();
}
}

function AnvilConfig() public pure returns(NetworkConfig memory){
    return NetworkConfig(
        0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    );
}

function SepoliaConfig() public pure returns(NetworkConfig memory){
    return NetworkConfig(
        0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    );
}
}