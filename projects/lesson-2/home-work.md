
gas变化的记录
添加第一个员工 （地址：0xca35b7d915458ef540ade6068dfe2f44e8fa733c），调用calculateRunway()，
          transaction cost为22974 gas， execution cost为：1702 gas ；
第二个员工：transaction cost为23755 gas ，execution cost为：2483 gas ；
第三个员工：transaction cost为24536 gas ，execution cost为：3264 gas ；
第四个员工：transaction cost为25317 gas ，execution cost为：4045 gas ；
第五个员工：transaction cost为26098 gas ，execution cost为：4826 gas ；
第六个员工：transaction cost为26879 gas ，execution cost为：5607 gas ；
第七个员工：transaction cost为27660 gas ，execution cost为：6388 gas ；
第八个员工：transaction cost为28441 gas ，execution cost为：7169 gas ；
第九个员工：transaction cost为29222 gas ，execution cost为：7950 gas ；
第十个员工：transaction cost为30003 gas ，execution cost为：8731 gas ；

1.加入十个员工，每次加入一个后调用calculateRunway() 这个函数，gas会变化，后面的总是比前一个消耗的gas多。这是因为员工加入数组后，调用calculateRunway()，数组内的员工变多，每次都比上一次要多计算一次，所以消耗的gas会变多。


2.定义一个全局的totalSalary，每次添加员工的时候，totalSalary加上该员工的工资；删除员工的时候，totalSalary删除该员工的工资；更新员工的时候，totalSalary减去该员工之前的工资，再加上更新的工资；
 即把计算总工资的方法在每次添加删除修改的时候处理；