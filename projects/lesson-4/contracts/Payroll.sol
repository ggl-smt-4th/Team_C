pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;

    //Solidityの構造体
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    //uint constant payDuration = 5 seconds;
    uint totalSalary = 0;
    address owner;
    //Employee[] employees;
    mapping(address => Employee) public employees; 

    //この関数がなければ、ownerがない
    function Payroll() payable public {
        owner = msg.sender;
    }

    /*
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    */

    modifier employeeExist(address employeeId) {
        var employee  = employees[employeeId]; 
        assert(employee.id != 0x0);
        _;
    }

    //今まで社員に支払うべき金額を計算する
    //Solidity可視性修飾子:1.private 2.internal 3.external 4.public
    //private:コントラクト内の別の関数からのみ呼び出される
    function _partialPay(Employee employee) private {
        //uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        uint payment = employee.salary 
            .mul((now - employee.lastPayday))
            .div(payDuration);
        employee.id.transfer(payment);        
    }

    //位置を探す
    /*
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i=0; i < employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }
    */
    
    function addEmployee(address employeeId, uint salary) onlyOwner payable public {
        //require(msg.sender == owner);

        //社員の位置を探す
        //var (employee, index)  = _findEmployee(employeeId); 
        var employee  = employees[employeeId]; 
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        //totalSalary += salary.mul(1 ether);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        //require(msg.sender == owner);
        
        //var (employee, index)  = _findEmployee(employeeId); 
        var employee  = employees[employeeId]; 
        //assert(employee.id != 0x0);

        //削除する前に、社員に支払う
        _partialPay(employee);       
        //totalSalary -= employees[employeeId].salary;
        totalSalary = totalSalary.sub(employees[employeeId].salary);

        //delete employees[index];
        delete employees[employeeId];

        //情報を削除した社員は、配列の最後に置く
        //employees[index] = employees[employees.length - 1];
        //employees.length -= 1;
    }

    //社員情報を更新する
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) payable public {
        //require(msg.sender == owner);
        
        //var (employee, index)  =_findEmployee(employeeAddress); 
        var employee  = employees[employeeId]; 

        //assert(employee.id != 0x0);
        
        _partialPay(employee);

        //totalSalary -= employees[employeeId].salary;
        totalSalary = totalSalary.sub(employees[employeeId].salary);

        //employees[index].salary = salary;
        employees[employeeId].salary = salary.mul(1 ether);

        //totalSalary += employees[employeeId].salary;
        totalSalary = totalSalary.add(employees[employeeId].salary);

        //employees[index].lastPayday = now;
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function calculateRunway() public view returns (uint) {
        //uint totalSalary = 0 ether;

        /* 
        for (uint i=0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        */
        //「空間を時間に交換する」Map

        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    //社員の情報を取る
    function checkEmployee(address employeeId) public returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        //return (employee.salary, employee.lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    //payable修飾詞:Etherを受け取ることができる特別なタイプの関数
    function getPaid() employeeExist(msg.sender) payable public {
        //var (employee, index)  = _findEmployee(msg.sender); 
        var employee = employees[msg.sender];

        //assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        //employees[index].lastPayday = nextPayday;
        employees[msg.sender].lastPayday = nextPayday;
        //employees[index].id.transfer(employees[index].salary);
        employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) public {
        require(oldAddress != newAddress);
        var employee = employees[oldAddress];
        employees[newAddress] = employee;
        
        employee.id = newAddress;
        delete employees[oldAddress];
    }
}

