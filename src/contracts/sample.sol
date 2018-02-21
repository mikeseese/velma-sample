pragma solidity ^0.4.2;

contract Sample {
    uint a;
    uint[] b;

    function Sample() public {
        a = 0;
    }

    function test1() public {
        uint z = 1;
        a = a + z;
        a = 0;
    }

    function test2() public {
        b.push(0);
        a = 0;
    }

    function test3() public {
        a = test3a();
        b.push(test3a());
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

    struct s {
        uint a;
    }

    struct c {
        uint a;
    }

    function test5() public {
        uint8[5] memory crazy;
        crazy[0] = 1;
        crazy[1] = 2;
        crazy[2] = 3;
        crazy[3] = 4;
        crazy[4] = 5;
        s memory wtf;
        s memory wtf2;
        c memory wtf3;
        wtf.a = 0;
        wtf2.a = 10;
        uint256 newVal = 108;
        uint256 nextVal = newVal / 2;
        newVal += 1;
        uint256 priorVal = nextVal * 2;
        a = test5a(priorVal);
    }

    function test5a(uint _val) private pure returns (uint) {
        uint nextVal = _val * 2;
        return nextVal;
    }

    function test6() public {
        bool t1;
        int8 t2;
        address t3;
        byte t4;
        bytes32 t5;
        t1 = true;
        t2 = -1;
        t3 = msg.sender;
        t4 = byte(2);
        t5 = "hello";
        t1 = false; // for breakpoint purposes
    }
}