## numpy中pad函数的常用方法

### 一、参数解释

ndarray = numpy.pad(array, pad_width, mode, **kwargs)

  • array为要填补的数组
  • pad_width是在各维度的各个方向上想要填补的长度,如（（1，2），（2，2）），表示在第一个维度上水平方向上padding=1,垂直方向
    上padding=2,在第二个维度上水平方向上padding=2,垂直方向上padding=2。如果直接输入一个整数，则说明各个维度和各个方向所填
    补的长度都一样。
  •  mode为填补类型，即怎样去填补，有“constant”，“edge”等模式，如果为constant模式，就得指定填补的值，如果不指定，则默认填
    充0。 
  • 剩下的都是一些可选参数，具体可查看 
    https://docs.scipy.org/doc/numpy/reference/generated/numpy.pad.html
  • ndarray为填充好的返回值。

二、例子

 1、对一维数组填充

【code】

import numpy as np
array = np.array([1, 1, 1])

# (1,2)表示在一维数组array前面填充1位，最后面填充2位
#  constant_values=(0,2) 表示前面填充0，后面填充2
ndarray=np.pad(array,(1,2),'constant', constant_values=(0,2))

print("array",array)
print("ndarray=",ndarray)

 

【result】

array [1 1 1]
ndarray= [0 1 1 1 2 2]

 

 

2、对二维数组填充

【code】

import numpy as np
array = np.array([[1, 1],[2,2]])

"""
((1,1),(2,2))表示在二维数组array第一维（此处便是行）前面填充1行，最后面填充1行；
                 在二维数组array第二维（此处便是列）前面填充2列，最后面填充2列
constant_values=(0,3) 表示第一维填充0，第二维填充3
"""
ndarray=np.pad(array,((1,1),(2,2)),'constant', constant_values=(0,3))

print("array",array)
print("ndarray=",ndarray)

 

【result】

array [[1 1]
       [2 2]]

ndarray= [[0 0 0 0 3 3]
          [0 0 1 1 3 3]
          [0 0 2 2 3 3]
          [0 0 3 3 3 3]]

