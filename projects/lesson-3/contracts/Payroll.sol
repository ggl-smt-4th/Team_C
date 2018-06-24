pragma solidity ^0.4.24;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    address owner;
    uint constant payDuration = 30 days;
    mapping(address=>Employee) employees;
    uint totalSalary;
    uint salaryIdent=1 ether;
    
    function Payroll(){
        owner=msg.sender;
        totalSalary=0;
    }
    
    
    modifier EmployeeExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id!=0x0);
        _;
    }
    
    modifier EmployeeNotExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id==0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private{
        if(employee.id!=0x0){
            uint payment=(employee.salary).mul((now.sub(employee.lastPayday))).div(payDuration);
            if(hasEnoughFund2(payment)) employee.id.transfer(payment);
        }
    }
    
    
    function addEmployee(address employeeId,uint salary) public onlyOwner EmployeeNotExist(employeeId){
        var employee=employees[employeeId];
        salary=salary.mul(salaryIdent);
        employees[employeeId]=Employee(employeeId,salary,now);
        totalSalary+=salary;
    }
    
    function removeEmployee(address employeeId) public onlyOwner EmployeeExist(employeeId){
        _partialPaid(employees[employeeId]);
        totalSalary=totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) payable public onlyOwner EmployeeExist(employeeId){
        var employee=employees[employeeId];
        _partialPaid(employees[employeeId]);
        salary=salary.mul(salaryIdent);
        totalSalary=totalSalary.add(salary).sub(employee.salary);
        employees[employeeId].id=employeeId;
        employees[employeeId].salary=salary;
        employees[employeeId].lastPayday=now;
    }
    
    function changePaymentAddress(address oldAddr,address newAddr) public EmployeeExist(oldAddr) EmployeeNotExist(newAddr){
        var employee=employees[oldAddr];
        employees[newAddr]=Employee(newAddr,employee.salary,employee.lastPayday);
        delete employees[oldAddr];
    }
    
    function getSalary(address employeeId) public EmployeeExist(employeeId) returns(uint){
        var employee=employees[employeeId];
        return employee.salary;
    }
    
    function getLastPayday(address employeeId) public EmployeeExist(employeeId) returns(uint){
        var employee=employees[employeeId];
        return employee.lastPayday;
    }
    
    function addFund() payable public returns(uint){
        return address(this).balance;
    }
    
    function calculateRunway() public view returns(uint){
        require(totalSalary>0);
        return address(this).balance .div( totalSalary);
    }
    
    function hasEnoughFund() public returns(bool){
        return calculateRunway() > 0;
    }
    
    function hasEnoughFund2(uint value) internal returns(bool){
        return address(this).balance >= value;
    }
    
    function checkEmployee(address employeeId) public returns(uint salary,uint lastPayday){
        var employee=employees[employeeId];
        salary=employee.salary;
        lastPayday=employee.lastPayday;
    }
    
    function getPaid() payable public {
        var employee=employees[msg.sender];
        if (employee.id != 0x0) revert();
        require( hasEnoughFund() );
        uint newDay = employee.lastPayday.add( payDuration);
        assert(newDay<now);
        employees[msg.sender].lastPayday = newDay;
        employee.id.transfer(employee.salary);
    }
    
}
