// Helps to write a mock chain
//Deploy mocks when we are local anvil chain
//keep track of contract address across various chains -- Sepolia, polygon, mainnet
//on local network those contract address dosent exist -- so we deploy mocks
//keep track of pricefeed address across various chains

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Agg.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = SepoliaETHGET();
        } else {
            activeConfig = getandcreateanviladdress();
        }
    }

    struct NetworkConfig {
        address pricefeed;
    }

    function SepoliaETHGET() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaaddress = NetworkConfig({pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaaddress;
    }

    function getandcreateanviladdress() public returns (NetworkConfig memory) {
        if (activeConfig.pricefeed != address(0)) {
            return activeConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({pricefeed: address(mockpricefeed)});
        return anvilConfig;
    }
}
