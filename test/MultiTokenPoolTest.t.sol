// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MultiTokenPool.sol";
import { UD60x18,unwrap,wrap  } from "@prb/math/UD60x18.sol";


contract MultiTokenPoolTest is Test {
    struct Token {
        uint weight;
        uint balance;
        address tokenAddress;
    }

    MultiTokenPool public pool;
    function setUp() public {
       pool = new MultiTokenPool();
    }

    function testLog() public {
        // uint result = pool.unsignedLog2(wrap(50000000000000000000));
        // console.log(result);

    }
    function testExp() public {
        // uint result = pool.unsignedExp2(25);
        // console.log(result);

    }
    function testPow() public {
        // uint result = pool.unsignedPow(5 ether, .02 ether);
        (uint weight, uint balance, address addr) = pool.idToToken(1);
        // uint result = pool.unsignedPow(balance, weight);
        // console.log(result);

    }

    function testGetToken() public {
        (uint weight, uint balance, address addr) = pool.idToToken(2);
        // console.log(weight);
        // console.log(balance);
        // console.log(addr);
    }

    function testGetAmountOut() public {
        uint amountOut = pool.getAmountOut(1,2,1000 ether);
        console.log(amountOut);
    }

    function testGetAmountIn() public {
        uint amountIn = pool.getAmountIn(1,2,1000 ether);
        console.log(amountIn);
    }

    function testGetSpotPrice() public {
        uint price = pool.getSpotPrice(1,2);
        console.log(price);
    }

    function testGetEffectPrice() public {
        uint price = pool.getEffectivePrice(1,2, 1000 ether);
        console.log(price);
    }
    function testGetInvariant() public {
        uint invariant = pool.getInvariant();
        // console.log(invariant);
    }
    
}
