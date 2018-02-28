pragma solidity ^0.4.2;

contract Sample {
    uint a;
    uint[3] b;

    function Sample() public {
        a = 17;
        b[0] = 9;
        b[1] = 8;
        b[2] = 7;
    }

    function test1() public {
        uint z = 1;
        a = a + z;
        a = 0;
    }

    function test2() public {
        a = 0;
    }

    function test3() public {
        a = test3a();
        a = 0;
    }

    function test3a() private pure returns (uint) {
        return 7;
    }

    function test4() public {
        a = test4a(10);
    }

    function test4a(uint v) private pure returns (uint) {
        v = v + 1;
        return v;
    }

    function test5() public {
        uint256 newVal = 108;
        uint256 nextVal = newVal / 2;
        newVal += 1;
        uint256 priorVal = nextVal * 2;
        a = test5a(priorVal, nextVal);
    }

    function test5a(uint _val, uint v2) private pure returns (uint) {
        uint nextVal = _val * 2 + v2;
        return nextVal;
    }

    function test6() public {
        uint[5] memory t0;
        bool t1 = true;
        int8 t2;
        address t3;
        byte t4;
        bytes5[2] memory t5;
        uint t6;
        t6 = a;
        t0[0] = 7;
        t1 = true;
        t2 = -1;
        t2 = 5;
        t3 = msg.sender;
        t4 = byte(2);
        t5[0] = "hello";
        t1 = false; // for breakpoint purposes
    }
}