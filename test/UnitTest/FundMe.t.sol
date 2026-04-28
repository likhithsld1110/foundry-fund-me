// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    address USER = makeAddr("USER");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUSD() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        assertEq(fundme.getterfunctionforowner(), msg.sender);
    }

    function testversion() public view {
        uint256 pricefeedversion = fundme.getversion();
        assertEq(pricefeedversion, 4);
    }

    function testfundgetsenoughfunds() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testdatastructureupdates() public createprankuserandfundsomemeoney {
        //vm.prank(USER); // THE next transaction will be sent by USER
        //fundme.fund{value: SEND_VALUE}();
        uint256 amountsent = fundme.getterfunctionforaddresstoamountsent(USER);
        assertEq(amountsent, SEND_VALUE);
    }

    function testfunderaddedtoarray() public createprankuserandfundsomemeoney {
        address funder = fundme.getterfunctionforfunders(0);
        assertEq(funder, USER);
    }

    function testONlyownnercanwithdraw() public createprankuserandfundsomemeoney {
        vm.expectRevert();
        fundme.withdraw();
    }

    function testownerbalacebeforeandafterwithdraw() public createprankuserandfundsomemeoney {
        //arrange
        uint256 ownerstartingbalace = fundme.getterfunctionforowner().balance;
        uint256 fundmestartingbalance = address(fundme).balance;
        //Action
        vm.prank(fundme.getterfunctionforowner()); //since the owner is the one who deployed the contract the owner address is same as fundme address
        fundme.withdraw();
        //assert
        uint256 fundmelastbalance = address(fundme).balance;
        assertEq(fundmelastbalance, 0);
        uint256 ownnerlastbalance = fundme.getterfunctionforowner().balance;
        assertEq(ownerstartingbalace + fundmestartingbalance, ownnerlastbalance);
    }

    function testwithdrawwithmultiplefunders() public {
        //arrange
        uint160 numberoftotalfunders = 10; // the reason for using uint160 is that the maximum number of addresses we can have is 2^160-1
        for (uint160 i = 1; i < numberoftotalfunders; i++) {
            //vm.prank(USER);
            //vm.deal instead user vm.hoax //the hoax function is a combination of prank and deal it sets the next transaction to be from a specific address and also gives that address some amount of ether
            // vm.hoax(address(i), SEND_VALUE);
            vm.deal(address(i), SEND_VALUE); // give ETH
            vm.prank(address(i)); // next call is from this address
            fundme.fund{value: SEND_VALUE}();

            fundme.fund{value: SEND_VALUE}();
        }

        uint256 ownerstratingbalnce = fundme.getterfunctionforowner().balance;
        uint256 fundmestartingbalance = address(fundme).balance;
        //Action
        vm.startPrank(fundme.getterfunctionforowner());
        fundme.withdraw();
        vm.stopPrank();
        //assert
        assertEq(address(fundme).balance, 0);
        uint256 ownerlastbalance = fundme.getterfunctionforowner().balance;
        assertEq(ownerstratingbalnce + fundmestartingbalance, ownerlastbalance);
    }

    modifier createprankuserandfundsomemeoney() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }
}
