// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// contract Mapping {
//     mapping(address=>uint) public mymap;

//     function get(address _addr) public view returns(uint) {
//         return mymap[_addr];
//     }

//     function set(address _addr, uint _i) public {
//         mymap[_addr] = _i;
//     }

//     function remove(address _addr) public {
//         delete mymap[_addr];
//     }

// }

contract question {
    mapping(address=> mapping (string => uint) ) private mymap1;
    // mapping(address=>string) public mymap2;

    function get(address _addrs, string memory j) public view returns(string memory) {
        uint result =  mymap1[_addrs][j];
        if (result<50) {
            return "less";
        } else if(result>50) {
            return "half";
        } else {
            return "100000";
        }
    }

    function set(address _addrs, string memory j, uint i) public {
         mymap1[_addrs][j] = i;
    } 

}


