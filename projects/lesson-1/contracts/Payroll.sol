pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner = 0x583031d1113ad414f02576bd6afabfb302140225;
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday = now;

    function updateEmployeeAddress(address newAddress) public {
        if(msg.sender != owner) {
            revert();
        }
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        if(msg.sender != owner) {
            revert();
        }
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