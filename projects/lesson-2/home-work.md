★ calculateRunway()的transaction与execution cost gas消耗：
22974 + 1702
23755 + 2483
24536 + 3264
25317 + 4045
26098 + 4826
26879 + 5607
27660 + 6388
28441 + 7169
29222 + 7950
30003 + 8731


每次加入一个员工，调用calculateRunway()的gas都会增加。因为每加入一个员工加入数组后，employees数组元素增加。当调用calculateRunway()，函数中要遍历employees数组，每次计算都增加一次，所以消耗的gas会变多。

优化方法：使用一个全局变量totalSalary，每次添加，删除和更新员工的时候，直接利用totalSalary计算得到结果。优化后结果每次gas消耗相同。

★ 优化之后calculateRunway()的transaction与execution cost gas消耗：
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097
22369 + 1097  