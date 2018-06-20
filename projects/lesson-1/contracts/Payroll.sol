pragma solidity ^0.4.14;

contract Payroll {

    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;
    
    //部署合约时自动执行
    function Payroll() payable public {
        owner = msg.sender;   
        lastPayday = now;
    }

    function doUpdateEmployee(address newAddress, uint newSalary) internal {
        if (employee != 0x0) { 
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = newAddress;
        salary = newSalary;
        lastPayday = now;
    }
    

    function updateEmployeeAddress(address newAddress) public {
        require(msg.sender == owner);      //确定只有合约部署者能修改员工地址
        require(newAddress != employee);  

        doUpdateEmployee(newAddress, salary);
    }

    function updateEmployeeSalary(uint newSalary) public {
        require(msg.sender == owner);   //确定只有合约部署者能修改员工工资
        require(newSalary > 0);
        newSalary = newSalary * 1 ether;
        require(newSalary != salary);

        doUpdateEmployee(employee, newSalary);
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    //充值
    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() view public returns (uint) {
        return this.balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    //员工获取工资
    function getPaid() public {
        require(msg.sender == employee); //只有员工能获取工资

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
