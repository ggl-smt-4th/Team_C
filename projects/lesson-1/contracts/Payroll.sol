pragma solidity ^0.4.14;

contract Payroll{
    uint constant payDuration = 30 days;
    
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    
    function Payroll() payable public {//Constructor
        owner = msg.sender;
        salary = 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable public returns (uint) {
        return address(this).balance;
    }
    
    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }
    
    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        require(msg.sender==employee && hasEnoughFund());
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday <= now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function getOwner() view public returns (address) {
        return owner;
    }
    
    function getEmployee() view public returns (address) {
        return employee;
    }
    
    function getSalary() view public returns (uint) {
        return salary;
    }
    
    function updateOwnerAddress(address newAddress) public {
        //Only the previous owner is authorized to do so
        require(msg.sender == owner && owner != newAddress);
        owner = newAddress;
    }
    
    function updateEmployeeAddress(address newAddress) public {
        //Check if the user is authorized
        require(msg.sender == owner && employee != newAddress);
        //Make sure the old employee has all his/her balance cleared before being removed
        //TBD...
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        //Check if the user is authorized
        uint newSalaryInEther = newSalary*1 ether;
        require(msg.sender == owner && salary != newSalaryInEther);
        salary = newSalaryInEther;
    }
}
