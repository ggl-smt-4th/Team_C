根据上课的code例子，加入前10个employee，计算出来的gas是:
transaction cost      execution cost
22974                 1702
23755                 2483
24536                 3264
25317                 4045
26098                 4826
26879                 5607
27660                 6388
28441                 7169
29222                 7950
30003                 8731

由于calculateRunaway需要遍历每一个employee去calculate total salary, 所以gas随着employee的增加而增加。
一个简单的办法就是维护一个全局变量totalSalary，这样会增加add/remove/update employee的gas，但是会大幅减少calculateRunaway的gas.

优化后，加入前10个employee，计算出来的gas是:
transaction cost      execution cost
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860
22132                 860