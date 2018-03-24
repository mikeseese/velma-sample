pragma solidity 0.4.18;

contract Test {
    uint g;

    function Test() public {
        g = 1337;
    }

    function test0(uint v) public {
        uint z = 1;
        g = z + v;
    }
}