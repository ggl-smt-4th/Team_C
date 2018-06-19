pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    address employee;
    uint salary = 1 ether;
    uint lastPayday;

    //构造函数
    function Payroll() payable public {  
        owner = msg.sender;
        lastPayday = now;
    }
    
    function updateEmployeeAddress(address newAddress) public {
        
        require(msg.sender == owner);
        require(newAddress != employee);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        lastPayday = now;
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {  
        require(msg.sender == owner);
        require(newSalary > 0);
        require(newSalary != salary);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }        

        lastPayday = now;
        salary = newSalary;
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        //if (msg.sender != employee) revert();
        //require(msg.sender == employee);
        assert(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;

        if (nextPayday > now) revert();

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}