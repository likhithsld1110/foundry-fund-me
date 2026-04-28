// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library pricecoverter {
    function getprice(AggregatorV3Interface getpriceETHUSD)
        public
        view
        returns (uint256)
    //to interact with a contract we require address and ABI
    {
        (, int256 valueinUSD,,,) = getpriceETHUSD.latestRoundData();
        return uint256(valueinUSD * 1e10);
    }

    function getConversion(uint256 amount, AggregatorV3Interface pricefeed) public view returns (uint256) {
        uint256 gettheprice = getprice(pricefeed);
        uint256 convert = (amount * gettheprice) / 1e18;
        return convert;
    }
}
