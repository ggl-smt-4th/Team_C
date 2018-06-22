优化前每次calculateRunway()的gas消耗:  
1. 22974 + 1702
2. 23755 + 2483
3. 24536 + 3264
4. 25317 + 4045
5. 26098 + 4826
6. 26879 + 5607
7. 27660 + 6388
8. 28441 + 7169
9. 29222 + 7950
10. 30003 + 8731

每增加一个employee, calculateRunway()的gas消耗都会增加. 原因是calculateRunway()函数中要遍历employees数组. 当addEmployee()后, employees数组长度增加, 遍历一次的计算次数也增加, 因此gas消耗增加. 为了减少calculateRunway()的gas消耗, 可以在contract中存储totalSalary, 每次add, remove或update employee时更新totalSalary. calculateRunway可以直接用totalSalary计算出结果, 不用遍历数组. 这样calculateRunway()的计算复杂度是固定的, gas消耗不变. 实验结果如下:    
优化后每次calculateRunway()的gas消耗:   

1. 22132 + 860
2. 22132 + 860
3. 22132 + 860
4. 22132 + 860
5. 22132 + 860
6. 22132 + 860
7. 22132 + 860
8. 22132 + 860
9. 22132 + 860
10. 22132 + 860  

这带来一个问题, add, remove和update employee增加了额外的计算, 它们的gas消耗应当会增加, 实验结果如下:



优化前每次addEmployee()的gas消耗(前四次):  

1. 104834 81962

2. 90675  67803
 
3. 91516 68644

4. 92357 69485

优化后每次addEmployee()的gas消耗(前四次):  

1. 125080 102208
2. 95921 73049
3. 96762 73890
4. 97603 74731  

结果验证了假设. 总的来说, 是否应该采取上面的优化取决于calculateRunway()以及add, remove, update employee函数调用次数的多少, 如果calculateRunway()将会被频繁调用, 需要采取优化. 如果相对来说add, remove, update employee会被频繁调用, 则不应当采取上面的优化. 