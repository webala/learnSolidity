// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 < 0.9.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}


contract FundMe {
    mapping(address=>uint256) public addressToAmountFunded;

    function fund() public payable{

        //msg.sender -> Sender of funds
        //msg.value -> Amount funded
        //Both are key words in solidity
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion () public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice () public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
            ) = priceFeed.latestRoundData(); //returns a touple. A list of variables of potentially different types

            //roe unused vaiables can be ignored like so
            //(,int256 answer,,,) = priceFeed.latestRoundData();
        
        return uint256(answer); // type casting since return value is of uint256
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1000000000000000000;
        return ethAmountInUsd;
    }

    //3332.49374413 -> the price has 8 decimals.
}