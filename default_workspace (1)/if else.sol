// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IfElse {
    function foo(uint x) public pure returns (uint) {
        if (x < 10) {
            return 0;
        } else if (x < 20) {
            return 1;
        } else {
            return 2;
        }
    }

    function number(uint x, uint y) public pure returns (uint) {
        if (x==y) {
            return x+y;
        } else if (x > y){
            return x;
        } else {
            return y;
        }
    }
}


