pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    
    struct Employee {
         // TODO, your code here
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping(address => Employee) public employees;
    
    function Payroll() payable public {
        // TODO: your code here
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
	}
	
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        // TODO: your code here
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary.mul( 1 ether ), now);
        totalSalary = totalSalary.add( employees[employeeId].salary );
    }
    
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId){ 
        // TODO: your code here
        var employee = employees[employeeId];
		
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        
        delete employees[employeeId];
        
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public employeeExist(oldAddress) {
        // TODO: your code here
        
        var employee = employees[newAddress];
        assert(employee.id == 0x0);

        employees[newAddress] = Employee(newAddress, employees[oldAddress].salary, employees[oldAddress].lastPayday);
        
        delete employees[oldAddress];
        
    }
    
    
    function updateEmployeeSalary(address employeeId, uint  salary) public onlyOwner employeeExist(employeeId){
        // TODO: your code here
        var employee = employees[employeeId];
		
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
	}
    
   
    function addFund() payable public returns (uint) {
        return this.balance;
    }
    
    
    function caculateRunway() public view returns (uint) {
        // TODO: your code here
        assert(totalSalary != 0);
        return this.balance.div( totalSalary );
    }
	
    function hasEnoughtFund() public view returns (bool) {
        // TODO: your code here
        return caculateRunway() > 0;
    }
    
    function getPaid() public employeeExist(msg.sender) {
        // TODO: your code here
        var employee = employees[msg.sender];
	
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
