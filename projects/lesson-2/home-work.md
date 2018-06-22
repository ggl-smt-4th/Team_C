gas变化的记录


1.加入十个员工，每次加入一个后调用calculateRunway() 这个函数，gas会变化，后面的总是比前一个消耗的gas多。这是因为员工加入数组后，调用calculateRunway()，数组内的员工变多，每次都比上一次要多计算一次，所以消耗的gas会变多。


2.定义一个全局的totalSalary，每次添加员工的时候，totalSalary加上该员工的工资；删除员工的时候，totalSalary删除该员工的工资；更新员工的时候，totalSalary减去该员工之前的工资，再加上更新的工资；
 即把计算总工资的方法在每次添加删除修改的时候处理；