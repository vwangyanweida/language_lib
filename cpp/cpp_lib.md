<!-- vim-markdown-toc GFM -->

	* [容器](#容器)
		* [序列容器](#序列容器)
		* [关联容器](#关联容器)
		* [无序容器容器](#无序容器容器)
	* [迭代器](#迭代器)
	* [迭代器适配器](#迭代器适配器)
		* [Insert iterator](#insert-iterator)
		* [Stream iterator](#stream-iterator)
		* [Reverse iterator](#reverse-iterator)
		* [Move iterator](#move-iterator)
		* [更易型算法](#更易型算法)
	* [匿名函数](#匿名函数)
* [疑问](#疑问)
	* [insert](#insert)
	* [反向迭代器](#反向迭代器)

<!-- vim-markdown-toc -->
### 容器
#### 序列容器
> 有序集合，内部每个元素都有确凿的位置--取决于插入时机和地点，与元素值无关

1. 如果以追加方式对一个集合置入几个元素，它们排序次序将和置入顺序一致。
2. STL提供了5个定义好的序列容器：array、deque、vector、list、`forward_list`
3. <font color=green>通常实现为：array或者linked list</font>
4. <font color=green>序列容器可以通过计算得到位置地址，支持随机读取</font>
	1. `push_bask`: 所有序列容器都支持，因为都可以在末尾加入一个元素，而且效率很高。
	2. 数字下标操作: 
	3. 中段、起始段插入元素比较费时，因为安插点之后的所有元素都要移动。

5. 特殊情况
	1. list 不提供随机访问
	2. `forward_list` 不提供`push_back`()和size()
#### 关联容器
> 这是一种已排序的集合，元素位置取决于value(key，如果是key/value pair)和给定的某个排序准则

1. 如果以追加方式对一个集合置入几个元素，它们的值将决定它们的次序。和置入顺序无关。
2. STL提供了4个定义好的关联容器：set、multiset、map、multimap
3. <font color=green>通常实现为binary tree</font>
4. <font color=green>二叉树结构，不支持随机读取，查找效率高</font>
	1. 不允许改变key，因为可能引起自动排序。
	2. insert
	3. 下标是key

#### 无序容器容器
> 这是一种无序集合，其内每个元素的位置无关紧要，唯一重要的是某特定元素是否位于此集合内。

1. 元素位置可能改变。
2. STL提供了4个定义好的无序容器：`unordered_set`、`unordered_multiset`、`unordered_map`、`unordered_multimap`
3. <font color=green>通常实现未hash table</font>
4. 内部是一个linked list 组成的array

### 迭代器
> 迭代器只不过是“容器内部某一位置”的抽象概念而已。一般来说，迭代器对自己所属的容器一无所知。任何“以迭代器访问容器”的算法都不得（无法）通过迭代器调用容器的任何成员函数。这个设计导致一个重要结果：算法的操作对象不一定得是“容器内的全部元素”所形成的区间，而可以是那些元素的子集。

1. 前向迭代器 / Forward iterator
2. 双向迭代器 / Bidirectional iterator
3. 随机访问迭代器 / Random-access iterator : 只有随机访问迭代器支持 operator <.
4. 输入型迭代器  / Input iterator
5. 输出型迭代器 / Output iterator

### 迭代器适配器
#### Insert iterator
> 它可以使算法<font color=red>安插(insert)</font>方式而非<font color=red>覆写(overwrite)</font>方式运作。

1. 使用它可以解决算法的“目标空间不足”问题，它会促使目标空间的大小按需要增长。

2. 三种insert iterator
	1. `bask_iterator`
		- 调用push_back()
		- 支持push_back的容器有：vector、deque、list、string。array、forward_list不支持。

	2. `front_iterator`
		- 内部调用`push_front`()
		- 支持`push_front`()的容器有：deque、list、forward_list.

	3. iterator
		- 内部调用insert()
		- 所有STL都支持insert()成员函数，因此，这是唯一可用于关联式容器身上的一种预定义的inserter。

#### Stream iterator
> Stream 是一个用来表现I/O通道的对象。

#### Reverse iterator
> 所有提供双向或随机访问迭代器的容器都可以通过他们的成员函数rbegin和rend产生一个反向迭代器（也就是`forward_list`之外所有的序列容器和所有的关联容器）

1. `forward_list`和所有的无序容器都没有提供回向迭代接口，即rbegin()、rend().因为那些容器内部实现只是使用singly linked list 串起所有元素。


#### Move iterator

#### 更易型算法
> 更易型算法会删除原来容器的成员，但是coll.end()返回的终点没有变，需要重新计算容器的长度

1. 更易型算法(指那些会移除remove、重排reorder、修改modify元素的算法)若用于关联式容器或无序容器，会出现问题，关联式和无序容器不能被当作操作目标，原因是：如果更易型算法用于关联式和无需容器身上，会改变某位置上的值，进而破坏容器本身对次序的维护(关联式容器是已排序sorted，无序容器是hash运算的结果)。

2. <font color=green>关联式容器和无序容器的所有迭代器均被声明为指向常量的value或key，如果更改关联式容器或无序容器，会导致编译错误。</font>

3. 关联式容器和无序容器怎样删除元素？调用它们的成员函数

3. remove：remove会返回一个iterator，指向的是现在容器的end节点。coll需要调用erase来删除多余的元素。

### 匿名函数
1. [=]以=caputure值，表明：在lambda被声明时已有效的所有符号都以by value形式传进lambda体内。

## 疑问
1. `back_iterator` 和`back_inserter`所代表的不同?
2. std::transform函数用法？
3. multiplies<int> 是否是乘积运算

### insert
1. 顺序容器insert是移动，原来的容器移动后元素减少
2. `unordered_map`容器是拷贝，将所有这个分清楚？

### 反向迭代器
迭代器指的位置是物理位置，`reverse_iterator`的区间是[end+1, 0),iterator 指的是[begin, end+1) .所以
对`reverse_iterator`取值时，取得是迭代器指向物理位置的前一个元素。
