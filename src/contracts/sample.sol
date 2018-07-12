pragma solidity 0.4.24;

import "test.sol";
import "Order.sol";

contract blah {
    uint c;

    function doCalc(uint v) public returns (uint) {
        uint h = v * 2;
        return h;
    }
}

contract Sample is Test, blah {
    using Order for Order.Data;

    address myAddr;
    uint8 myUint;

    uint16[3] b;
    uint8 a;
    e f;

    s[2] d;
    
    mapping(uint => Order.Data) private orders;

    mapping(uint => s) theMap;

    struct s {
        uint8 test;
        uint256 foo;
        address bar;
    }

    enum e {
        Hello,
        wOrld,
        GoodBye,
        universe
    }

    function Sample() public {
        c = 12345;
        a = 17;
        b[0] = 9;
        b[1] = 302;
        b[2] = 7;
        d[0].test = 7;
        d[0].foo = 1337;
        d[0].bar = 0x01234567890123456789;
        d[1].test = 6;
        d[1].foo = 1327;
        d[1].bar = 0x01294567890123456789;
        f = e.wOrld;
        theMap[12].test = 7;
        theMap[12].foo = 17779;
        theMap[12].bar = 0x07484567890123456789;
        myAddr = 0x75757575757575757575;
        myUint = 13;
        a = test3b();
    }

    function test1() public {
        uint8 z = 1;
        a = a + z;
        a = 0;
    }

    function test2() public {
        a = 0;
    }

    function test3() public {
        a = test3a();
        a = test3c();
        a = test3d();
    }

    function test3a() private pure returns (uint8) {
        return test3b();
    }

    function test3b() private pure returns (uint8) {
        return 2;
    }

    function test3c() private pure returns (uint8) {
        return 3;
    }

    function test3d() private pure returns (uint8) {
        return 4;
    }

    function test4() public {
        a = test4a(10);
    }

    function test4a(uint8 v) private pure returns (uint8) {
        v = v + 1;
        return v;
    }

    function test5() public {
        uint8 newVal = 108;
        uint8 nextVal = newVal / 2;
        newVal += 1;
        uint8 priorVal = nextVal * 2;
        a = test5a(priorVal, nextVal);
    }

    function test5a(uint8 _val, uint8 v2) private pure returns (uint8) {
        uint8 nextVal = _val * 2 + v2;
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
        e t7;
        t6 = a;
        t7 = e.Hello;
        t0[0] = 7;
        t0[2] = doCalc(7);
        t1 = true;
        t7 = e.GoodBye;
        t2 = -1;
        t2 = 5;
        t3 = msg.sender;
        t4 = byte(2);
        t5[0] = "hello";
        t5[1] = "world";
        t0[1] = 73;
        t1 = false; // for breakpoint purposes
    }

    function test7() public {
        this.delegatecall(keccak256("test3()"));
    }

    function test8() public {
        test0(20);
    }

    function test9() public {
        s storage sampleStruct;
        uint16[3] b_pointer = b;
        sampleStruct = theMap[0];
        sampleStruct.test = 8;
        sampleStruct.foo = 1338;
        sampleStruct.bar = 0x08234567890123456789;
        b_pointer[0] = 654;
    }

    function test10() public {
        bool v1;
        bool[1] v2;
        bool[] v3;
        bool[1][1] memory v4;
        bool[] memory v5;
        bool[][] v6;
        string memory v7;
        string[1] v8;
        bytes memory v9;
        bytes[1] memory v10;
        v1 = true;
        v2[0] = true;
        v3.push(true);
        v4[0][0] = true;
        v5 = new bool[](1);
        v5[0] = true;
        v6.push([true]);
        v7 = "";
        v8[0] = "";
        v9[0] = 0;
        v10[0][0] = 0;
    }

    function test11() public {
        Order.Data storage _order = orders[0];
        _order.orders = this;
        _order.market = this;
        _order.id = "wassup";
        _order.orderType = Order.Types.Ask;
        _order.outcome = 42;
        _order.price = 2150;
        test12(_order);
        _order.amount = 100000000000;
        _order.creator = msg.sender;
        _order.moneyEscrowed = 215000000000000;
        _order.sharesEscrowed = 0;
        _order.betterOrderId = "hello";
        _order.worseOrderId = "world";
        _order.worseOrderId = "worlds";
    }

    function test12(Order.Data storage _order) private {
        _order.price = _order.price + 1;
    }
}