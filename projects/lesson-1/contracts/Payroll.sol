pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    function Payroll() payable public {
        owner = msg.sender;
        lastPayday = now;
    }

    function updateEmployeeAddress(address newAddress) public {
        // Only owner can update employee address.
        require(msg.sender == owner);

        // Revert if it is the same employee. Save gas.
        require(employee != newAddress);

        // At beginning, there is no employee.
        if (employee != 0x0) {
            uint unpaidSalary = (now - lastPayday) / payDuration * salary;
            employee.transfer(unpaidSalary);
        }
        lastPayday = now;
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        // Only owner can update employee salary.
        require(msg.sender == owner);
        require(salary != newSalary);
        require(newSalary > 0);

        // At beginning, there is no employee.
        if (employee != 0x0) {
            uint unpaidSalary = (now - lastPayday) / payDuration * salary;
            employee.transfer(unpaidSalary);
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
        // Only employee can get paid.
        require(msg.sender == employee);

        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }

        // Revert if there is not enough fund.
        require(hasEnoughFund());

        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}