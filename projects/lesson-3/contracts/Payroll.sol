pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    function Payroll() payable public Ownable() {
 
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping(address => Employee) public employees;
    // function Payroll() payable public {
    //     // TODO: your code here
    // }
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier employeeNoExist(address employeeId) {
        assert(employees[employeeId].id == 0x0);
        _;
    }
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary
        .mul(now.sub(employee.lastPayday))
        .div(payDuration);
        employee.id.transfer(payment);
    }
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNoExist(employeeId) {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        // TODO: your code here
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) employeeNoExist(newAddress){
        assert(newAddress != 0x0);
        var employee = employees[oldAddress];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
        // TODO: your code here
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
        // TODO: your code here
    }

    function getPaid() public employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        // TODO: your code here
    }
}
