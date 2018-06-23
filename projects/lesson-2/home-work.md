ii.添加十个员工，每次加入一个员工后调用 calculateRunway() 函数，消耗的gas没有变化。

![屏幕快照](/Users/eagle/Desktop/屏幕快照.png)



iii.`calculateRunway()` 函数的优化思路和过程

每调用一次calculateRunway()函数就要遍历数组中每个成员的salary，消耗的gas会多，可以把totalSalary定义为一个全局变量，每添加一个员工和每更新一个员工就更新totalSalary，这样在调用calculateRunway()函数是不用计算totalSalary，可以直接调用，减少gas消耗。