// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
    }

    function testUserCanFundAndOwnerCanWithdraw() public {
        // Fund using the script helper
        FundFundMe fundScript = new FundFundMe();
        fundScript.fundFundMe(address(fundMe));

        // Withdraw using the script helper
        WithdrawFundMe withdrawScript = new WithdrawFundMe();
        withdrawScript.withdrawFundMe(address(fundMe));

        // After withdraw, contract balance should be 0
        assertEq(address(fundMe).balance, 0);
    }
}
