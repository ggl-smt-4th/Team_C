# Homework2
---------------
### gas记录 1.0
加入10个员工，gas记录如下
    
    **员工数**                     **gas消耗**
    1                             1699
    2                             2487
    3                             3275
    4                             4063
    5                             4851
    6                             5639
    7                             6427
    8                             7215
    9                             8003
    10                            8791

### 优化思路
**code1.0**
    
    uint totalSalary=0;
        for(uint i=0;i<employees.length;i++)
            totalSalary+=employees[i].salary;
    
gas的消耗在于对链数据的读取，即访问employee的次数.
随着员工增加，读取次数增加，gas消耗即增加.

**code2.0**
    
    uint totalSalary;
    function Payroll(){
        owner=msg.sender;
        totalSalary=0;
    }
    function addEmployee(address employId,uint salary) public{
        ...
        totalSalary+=salary;
    }
    function removeEmployee(adddress employeeId) public {
        ...
        totalSalary-=employees[index].salary;
    }
    function updateEmployee(address employeeId,uint salary) public{
        ...
        totalSalary+=salary-employees[index].salary;
        ...
    }
    ...
    function calculateRunway() public view returns(uint){
        require(totalSalary>0);
        return address(this).balance / totalSalary;
    }
通过一个全局变量维护总工资的计算，将操作代价分摊至增、减、改中，减少了开销。
从O(n)代价改为O(1)代价。

### gas记录2.0
    **员工数**                     **gas消耗**
    1                             1079
    2                             1079
    3                             1079
    4                             1079
    5                             1079
    6                             1079
    7                             1079
    8                             1079
    9                             1079
    10                            1079