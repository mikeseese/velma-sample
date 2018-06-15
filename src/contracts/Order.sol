// Copyright (C) 2015 Forecast Foundation OU, full GPL notice in LICENSE

// Bid / Ask actions: puts orders on the book
// price is denominated by the specific market's numTicks
// amount is the number of attoshares the order is for (either to buy or to sell).
// price is the exact price you want to buy/sell at [which may not be the cost, for example to short a binary market it'll cost numTicks-price, to go long it'll cost price]
// smallest order value is Order.MIN_ORDER_VALUE

pragma solidity 0.4.18;

import "sample.sol";

// CONSIDER: Is `price` the most appropriate name for the value being used? It does correspond 1:1 with the attoETH per share, but the range might be considered unusual?
library Order {
    uint256 constant MIN_ORDER_VALUE = 10**14;

    enum Types {
        Bid, Ask
    }

    enum TradeDirections {
        Long, Short
    }

    struct Data {
        // Contracts
        Sample orders;
        Sample market;
        Sample augur;

        // Order
        bytes32 id;
        address creator;
        uint8 outcome;
        Order.Types orderType;
        uint256 amount;
        uint256 price;
        uint256 sharesEscrowed;
        uint256 moneyEscrowed;
        bytes32 betterOrderId;
        bytes32 worseOrderId;
    }
}
