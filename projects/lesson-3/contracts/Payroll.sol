pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary ;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    uint totalSalary = 0;
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId]; 
        assert(employee.id != 0x0);
        _;
    }
    
    modifier deleteEmployee(address employeeId) {
        _;
        delete employees[employeeId];
    }
    
    function _particlePaid(Employee employee) private{
        uint payment = employee.salary * (now -employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    

    function addEmployee(address employeeAddress, uint salary) onlyOwner payable public {
        //找到该员工及所在位置（var 指代任意变量）
        var employee  =employees[employeeAddress]; 
        assert(employee.id == 0x0);
        
        salary = salary * 1 ether;
        employees[employeeAddress] = Employee(employeeAddress, salary, now);

        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) deleteEmployee(employeeId) public{
        var employee  = employees[employeeId]; 
        _particlePaid(employee);
                
        totalSalary = totalSalary.sub(employees[employeeId].salary);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) deleteEmployee(oldAddress) public {
        require(oldAddress != newAddress);
        
        var employee = employees[oldAddress];
        employee.id = newAddress;
        employees[newAddress] = employee;
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) payable public {
        var employee  = employees[employeeId]; 
        
       _particlePaid(employee);
                
        totalSalary = totalSalary.sub(employees[employeeId].salary);   
        employees[employeeId].salary = salary * 1 ether;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) public {
        var employee  = employees[msg.sender]; 
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

