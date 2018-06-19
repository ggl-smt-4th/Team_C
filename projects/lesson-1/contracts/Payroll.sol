pragma solidity ^0.4.14;


contract Payroll {
    uint salary = 1 ether;
    address owner=msg.sender ;
    address curAddr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 30 days;
    uint lastPayday=now ;
    
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
        require( curAddr != 0x0 );
        uint t = now - lastPayday;
        uint money = t / payDuration *salary;
        if ( !hasEnoughBalance2(money) ) revert();
        lastPayday=now;
        curAddr.transfer(money);
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
        if ( msg.sender != curAddr ) revert();
        if ( curAddr == 0x0 ) revert();
        if ( !hasEnoughFund() ) revert();
        uint newDay = lastPayday + payDuration;
        if( newDay > now ) revert();
        lastPayday = newDay;
        curAddr.transfer(salary);
    }
    
}
