//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
//0x694AA1769357215DE4FAC081bf1f309aDC325306
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {pricecoverter} from "./PriceCoverterlib.sol";

error nottheowner();

contract FundMe {
    address private immutable i_owner;
    using pricecoverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addresstoamountsent;
    AggregatorV3Interface private pricefeed_i;

    constructor(address pricefeed) {
        i_owner = msg.sender;
        pricefeed_i = AggregatorV3Interface(pricefeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversion(pricefeed_i) >= MINIMUM_USD,
            "Don't worry I will sponser you"
        );
        s_funders.push(msg.sender);
        s_addresstoamountsent[msg.sender] += msg.value;
    }

    //get price of eth in USD
    //msg.value convert to usd
    function getversion() public view returns (uint256) {
        return pricefeed_i.version();
    }

    function withdraw() public onlyowner {
        uint256 numberoftotalfunders = s_funders.length;
        for (uint index = 0; index < numberoftotalfunders; index++) {
            address funder = s_funders[index];
            s_addresstoamountsent[funder] = 0;
        }
        // //reset the array
        s_funders = new address[](0);
        // //transfer
        // payable(msg.sender).transfer(address(this).balance);//automaticaly reverts the transaction if it fails
        // //send
        // bool suc = payable(msg.sender).send(address(this).balance); //returns a bool no automatic revert, only reverts if we add a require statement
        // require(suc,"FAILED");
        //call
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "FAILED");
    }

    modifier onlyowner() {
        if (i_owner != msg.sender) {
            revert nottheowner();
        }
        _;
        //require(i_owner == msg.sender, "No the owner");
    }

    //What if someone send to this contract without triggering fund function = no track of funders
    //fallback and receive functions
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    //since our data is private we need to create getter functions for them
    function getterfunctionforaddresstoamountsent(
        address funderaddress
    ) external view returns (uint256) {
        return s_addresstoamountsent[funderaddress];
    }

    function getterfunctionforfunders(
        uint256 index
    ) external view returns (address funderaddress) {
        return s_funders[index];
    }

    function getterfunctionforowner() external view returns (address) {
        return i_owner;
    }
}
