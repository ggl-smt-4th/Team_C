pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);

        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeAddress){
                revert();
            }
        }
        employees.push(Employee(employeeAddress,salary * 1 ether,now));

    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                uint payment = employees[i].salary * (now - employees[i].lastPayday) / payDuration;
                employeeId.transfer(payment);

                delete employees[i];
                employees[i] = employees[employees.length - 1];
                employees.length -= 1;
                return;
            }
        }
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id ==  employeeAddress){
                uint payment = employees[i].salary * (now - employees[i].lastPayday) / payDuration;
                employeeAddress.transfer(payment);

                employees[i].salary = salary * 1 ether;
                employees[i].lastPayday = now;
                return;
            }
        }
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++){
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        for (uint i = 0; i < employees.length; i++){
            if (msg.sender != employees[i].id){
                revert();
            }

            uint nextPayday = employees[i].lastPayday + payDuration;
            assert(nextPayday < now);
            employees[i].lastPayday = nextPayday;
            employees[i].id.transfer(employees[i].salary);

        } 
    }
}

