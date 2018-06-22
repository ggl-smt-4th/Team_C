pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address addr;
        uint salary ;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    //构造函数
    function Payroll() payable public {
        owner = msg.sender;
    }
    
    function _particlePaid(Employee employee) private{
        uint payment = employee.salary * (now -employee.lastPayday) / payDuration;
        employee.addr.transfer(payment);
    }
    
    //查找员工及所在位置
    function _getEmployee(address newAddr) private returns (Employee storage, uint) {
        for (uint i=0; i<employees.length; i++){
            if (employees[i].addr == newAddr){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        //找到该员工及所在位置（var 指代任意变量）
        // var (employee, index)  =_getEmployee(employeeAddress); 
        // assert(employee.addr == 0x0);
        
        for (uint i=0; i<employees.length; i++){
            if (employees[i].addr == employeeAddress){
                revert() ;
            }
        }

        employees.push(Employee(employeeAddress, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        
        var (employee, index)  =_getEmployee(employeeId); 
        //确认员工是存在数组中的
        assert(employee.addr != 0x0);
        
        //先结清员工的工资
        _particlePaid(employee);
                
        //删除员工
        delete employees[index];
        //将地址为空的员工置于数组最后
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
         var (employee, index)  =_getEmployee(employeeAddress); 
        //确认员工是存在数组中的
        assert(employee.addr != 0x0);
        
       _particlePaid(employee);
                
        employee.salary = salary;
        employee.lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        uint totalSalary = 0;
        for (uint i=0; i<employees.length; i++){
            totalSalary += employees[i].salary;
        }
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index)  =_getEmployee(msg.sender); 
        assert(employee.addr != 0x0);
        
        uint nextPayday =employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.addr.transfer(employee.salary);
    }
}

