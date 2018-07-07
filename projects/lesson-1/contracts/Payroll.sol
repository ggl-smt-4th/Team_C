pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner = msg.sender;
    uint salary = 1 ether;
    address employee;
    uint lastPayday = now;

    function updateEmployee(address newAddress, uint newSalary) private {
        if(employee != 0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        employee = newAddress;
        salary = newSalary;
        lastPayday = now;
    }
    function updateEmployeeAddress(address newAddress) public {
        if(msg.sender != owner || newAddress == employee) {
            revert();
        }
        updateEmployee(newAddress, salary);
    }

    function updateEmployeeSalary(uint newSalary) public {
        uint newSalaryInEther = newSalary * 1 ether;
        if(msg.sender != owner || newSalaryInEther == salary || newSalary <= 0) {
            revert();
        }
        updateEmployee(employee, newSalaryInEther);
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
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now) {
            revert();
        }
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}