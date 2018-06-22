pragma solidity ^0.4.14;

contract Payroll {

    //Solidityの構造体
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    //uint constant payDuration = 5 seconds;
    
    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    //今まで社員に支払うべき金額を計算する
    //Solidity可視性修飾子:1.private 2.internal 3.external 4.public
    //private:コントラクト内の別の関数からのみ呼び出される
    function _partialPay(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);        
    }

    //位置を探す
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0; i < employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        //社員の位置を探す
        var (employee, index)  = _findEmployee(employeeAddress); 
        assert(employee.id == 0x0);

        employees.push(Employee(employeeAddress, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee, index)  = _findEmployee(employeeId); 
        assert(employee.id != 0x0);
        
        //削除する前に、社員に支払う
        _partialPay(employee);       

        delete employees[index];
        //情報を削除した社員は、配列の最後に置く
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    //社員情報を更新する
    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (employee, index)  =_findEmployee(employeeAddress); 
        assert(employee.id != 0x0);
        
        _partialPay(employee);        
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        uint totalSalary = 0 ether;
        for (uint i=0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    //payable修飾詞:Etherを受け取ることができる特別なタイプの関数
    function getPaid() payable public {
        var (employee, index)  = _findEmployee(msg.sender); 
        assert(employee.id != 0x0);

        uint nextPayday =employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);
    }
}

