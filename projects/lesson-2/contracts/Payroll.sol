pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    address owner;
    uint constant payDuration = 30 days;
    Employee[] employees;
    uint totalSalary;
    uint salaryIdent=1 ether;
    
    function Payroll(){
        owner=msg.sender;
        totalSalary=0;
    }
    
    function _partialPaid(Employee employee) private{
        if(employee.id!=0x0){
            uint payment=employee.salary*(now-employee.lastPayday)/payDuration;
            if(hasEnoughBalance2(payment)) employee.id.transfer(payment);
        }
    }
    
    function _findEmployee(address employeeId) private returns(Employee,uint){
        for(uint i=0;i<employees.length;i++){
            if(employees[i].id==employeeId)
                return (employees[i],i);
        }
    }
    
    function addEmployee(address employeeId,uint salary)public{
        require(msg.sender==owner);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        salary*=salaryIdent;
        employees.push(Employee(employeeId,salary,now));
        totalSalary+=salary;
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender==owner);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        _partialPaid(employees[index]);
        totalSalary-=employees[index].salary;
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
    }
    
    function updateEmployee(address employeeId, uint salary) public{
        require(msg.sender==owner);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        _partialPaid(employees[index]);
        salary*=salaryIdent;
        totalSalary+=salary-employees[index].salary;
        employees[index].id=employeeId;
        employees[index].salary=salary;
        employees[index].lastPayday=now;
    }
    
    function getSalary(address employeeId) public returns(uint){
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        return employee.salary;
    }
    
    function getLastPayday(address employeeId) public returns(uint){
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id==0x0);
        return employee.lastPayday;
    }
    
    function addFund() payable public returns(uint){
        return address(this).balance;
    }
    
    function calculateRunway() public returns(uint){
        require(totalSalary>0);
        return address(this).balance / totalSalary;
    }
    
    function hasEnoughFund() public returns(bool){
        return calculateRunway() > 0;
    }
    
    function hasEnoughBalance2(uint value) internal returns(bool){
        return address(this).balance >= value;
    }
    
    function getPaid() payable public {
        var (employee,index)=_findEmployee(msg.sender);
        if ( employee.id==0x0) revert();
        require( hasEnoughFund() );
        uint newDay = employee.lastPayday + payDuration;
        assert(newDay<now);
        employees[index].lastPayday = newDay;
        employees[index].id.transfer(employees[index].salary);
    }
    
}
