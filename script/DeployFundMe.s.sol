// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperconfig = new HelperConfig();
        address addressofcontract = helperconfig.activeConfig();
        vm.startBroadcast();
        FundMe fundme = new FundMe(addressofcontract);
        vm.stopBroadcast();
        return fundme;
    }
}
