pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint salaryUnit=1 ether;
    uint public totalSalary = 0;
    mapping(address => Employee) public employees;

    function Payroll() payable{
        owner=msg.sender;
    }
    
    modifier employeeExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNotExist (address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeAddress, uint salary) onlyOwner employeeNotExist(employeeAddress) {
        salary = salary.mul(salaryUnit);  // convert the uint to ether
        employees[employeeAddress] = (Employee(employeeAddress, salary, now));
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress) public {
        var employee = employees[oldAddress];
        var newEmployee = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
        employees[newAddress] = newEmployee;
    }

    function updateEmployee(address employeeAddress, uint salary) onlyOwner employeeExist(employeeAddress) {
        var employee = employees[employeeAddress];
        _partialPaid(employee);
        employee.id = employeeAddress;
        salary = salary.mul(salaryUnit);  // convert the uint to ether
        totalSalary = totalSalary.sub(employee.salary).add(salary);
        employee.salary = salary;
        
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender){
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
