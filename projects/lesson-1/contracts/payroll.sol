pragma solidity ^0.4.14;


contract Payroll {
    uint salary = 1 ether;
    address owner = msg.sender;
    address curAddr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function getSalary() public returns(uint){
        return salary;
    }
    
    function setSalaey(uint value)public {
        salary = value * 1 ether;
    }
    
    function getAddress() public returns(address){
        return curAddr;
    }
    
    function setAddress(address newAddr) public{
        if ( msg.sender != owner ) revert();
        if ( newAddr == curAddr ) revert();
        uint t = now - lastPayday;
        if( now < lastPayday ) revert();
        uint money = t / payDuration *salary;
        if ( !hasEnoughBalance2(money) ) revert();
        lastPayday=now;
        curAddr.transfer(money);
        curAddr = newAddr;
    }
    
    function getBalance() payable public returns(uint){
        return this.balance;
    }
    
    function calculateRunway() internal returns(uint){
        return this.balance / salary;
    }
    
    function hasEnoughBalance() internal returns(bool){
        return calculateRunway() > 0;
    }
    
    function hasEnoughBalance2(uint value) internal returns(bool){
        return this.balance >= value;
    }
    
    function getPaid() payable public {
        if ( msg.sender != curAddr ) revert();
        if ( !hasEnoughBalance() ) revert();
        uint newDay = lastPayday + payDuration;
        if( newDay > now ) revert();
        lastPayday = newDay;
        curAddr.transfer(salary);
    }
    
}