    依照第二课视频的样例代码可得到依次添加10个employee后相应的calculateRunway()的相应花销如下：

优化前：
  |operation       |transaction cost|execution cost | delta
----------------------------------------------------------
 1|calculateRunway |          22974 |          1702 |
 2|calculateRunway |          23755 |          2483 |  781
 3|calculateRunway |          24536 |          3264 |  781
 4|calculateRunway |          25317 |          4045 |  781
 5|calculateRunway |          26098 |          4826 |  781
 6|calculateRunway |          26879 |          5607 |  781
 7|calculateRunway |          27660 |          6388 |  781
 8|calculateRunway |          28441 |          7169 |  781
 9|calculateRunway |          29222 |          7950 |  781
10|calculateRunway |          30003 |          8731 |  781

    观察相邻两次calculateRunway()的花费之差可知：每次transaction cost的增加都来自execution cost，而execution cost每次都会增加781以计算新加入的employee带来的工资开销。随着员工数量的增加，计算runway的花销将会越来越大。
    一个比较直接的思路是在contract里维护一个当前所有employee的工资开销之和totalSalary，每次更新employee相关信息的的时候将其一同更新，在调用calculateRunway()的时候就可以直接获取该值而无需遍历全体employee重新计算。
    利用变量totalSalary存储当前全体employee的salary后，10次calculateRunway()的相应花销如下：

优化后：
  |operation       |transaction cost|execution cost
---------------------------------------------------
 1|calculateRunway |          22132 |          860
 2|calculateRunway |          22132 |          860
 3|calculateRunway |          22132 |          860
 4|calculateRunway |          22132 |          860
 5|calculateRunway |          22132 |          860
 6|calculateRunway |          22132 |          860
 7|calculateRunway |          22132 |          860
 8|calculateRunway |          22132 |          860
 9|calculateRunway |          22132 |          860
10|calculateRunway |          22132 |          860

    将各次操作花费的transaction cost 和 execution cost分别与优化前的值做差可得到节约的gas：

  |operation       |transaction cost|execution cost 
  |                |difference      |difference
----------------------------------------------------
 1|calculateRunway |           -842 |       -842    
 2|calculateRunway |          -1623 |      -1623    
 3|calculateRunway |          -2404 |      -2404    
 4|calculateRunway |          -3185 |      -3185    
 5|calculateRunway |          -3966 |      -3966    
 6|calculateRunway |          -4747 |      -4747    
 7|calculateRunway |          -5528 |      -5528    
 8|calculateRunway |          -6309 |      -6309    
 9|calculateRunway |          -7090 |      -7090    
10|calculateRunway |          -7871 |      -7871    
--------------------------------------------------
  |total           |          -43565|     -43565

    由此可见，代码在优化后所节约的是execution cost，对transaction cost中的其他部分没有影响。因为totalSalary在调用calculateRunway()的时候是现成的，所以每次的execution cost都是一样的。
    但是修改后的代码在添加或减少employee的时候需要一直维护totalSalary这个变量，addEmployee()函数的花费也会增加；以下为修改代码前后10次calculateRunway()函数的花费对比：

  |operation    |transaction cost|execution cost
  |             |difference      |difference
-----------------------------------------------------
 1|addEmployee  |          20241 |      20241
 2|addEmployee  |           5241 |       5241
 3|addEmployee  |           5241 |       5241
 4|addEmployee  |           5241 |       5241
 5|addEmployee  |           5241 |       5241
 6|addEmployee  |           5241 |       5241
 7|addEmployee  |           5241 |       5241
 8|addEmployee  |           5241 |       5241
 9|addEmployee  |           5241 |       5241
10|addEmployee  |           5241 |       5241

    可以看出为了维护totalSalary，calculateRunway()函数的花销变大了。从添加第二个employee开始，每次都需要多花费相同数量(5241)的execution cost以更新totalSalary。
    对于使用该代码管理薪资发放的公司而言，如果员工人数足够且员工流动性不过于频繁，则该优化效果是可以接受的。
