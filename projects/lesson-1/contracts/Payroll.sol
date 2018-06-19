pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address owner;
    address curAddr;
    uint constant payDuration = 30 days;
    uint lastPayday;
    
    function Payroll() public{
        owner=msg.sender;
        lastPayDay=now;
    }
    
    function getSalary() public returns(uint){
        return salary;
    }
    
    function updateEmployeeSalary(uint value)public {
        salary = value * 1 ether;
    }
    
    function getAddress() public returns(address){
        return curAddr;
    }
    
    function updateEmployeeAddress(address newAddr) public{
        require(msg.sender == owner);
        require( newAddr != curAddr );
        require( newAddr != 0x0 );
        uint t = now - lastPayday;
        uint money = t / payDuration *salary;
        if ( !hasEnoughBalance2(money) && curAddr !=0x0 ) curAddr.transfer(money);
        lastPayday=now;
        curAddr = newAddr;
    }
    
    function addFund() payable public returns(uint){
        return address(this).balance;
    }
    
    function calculateRunway() view public returns(uint){
        return address(this).balance / salary;
    }
    
    function hasEnoughFund() public returns(bool){
        return calculateRunway() > 0;
    }
    
    function hasEnoughBalance2(uint value) internal returns(bool){
        return address(this).balance >= value;
    }
    
    function getPaid() payable public {
        require( msg.sender == curAddr );
        require( curAddr != 0x0);
        require( hasEnoughFund() ) ;
        uint newDay = lastPayday + payDuration;
        assert(newDay<now);
        lastPayday = newDay;
        curAddr.transfer(salary);
    }
}
