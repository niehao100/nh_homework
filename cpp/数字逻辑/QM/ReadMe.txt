操作说明：
将Main.cpp和TestCode.hpp中的xxxxxx替换成学号，将你的QMxxxxxx.hpp（xxxxxx也是学号）也放在当前目录下。
如果你还有其他的.cpp文件，也放到项目中。
编译，运行

测试文件说明（BaoShurui.txt）：
4 8 10 11 12 15
9 14
BC'D'+AC+AB' BC'D'+AC+AD'
1
每一个测试数据分为四行：
第一行，最小项
第二行，无关项
第三行，输出可能
第四行，分数（如果分数为0，那么直接越过这个测试数据）

输出文件说明：
输出文件为Result_xxxxxx_姓名_分数.txt
0	BC'D'+AC+AB'	1
1	A+BC+BD	1
2	A'BD'+B'C'E+C'D'+BCDE+AC'E	1
3	A'B'C+BC'+A'CD	1
4	+	0
第一列，测试数据的序号
第二列，输出
第三列，测试结果（通过还是不通过）
当然，如果你的数组越界了，那就没有输出文件了。此时不妨将该测试数据的分数改成0，跳过它来测试其他数据。