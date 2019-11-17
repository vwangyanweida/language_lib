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

<!-- vim-markdown-toc -->
### 容器
#### 序列容器
> 有序集合，内部每个元素都有确凿的位置--取决于插入时机和地点，与元素值无关

1. 如果以追加方式对一个集合置入几个元素，它们排序次序将和置入顺序一致。
2. STL提供了5个定义好的序列容器：array、deque、vector、list、forward_list
3. <font color=green>通常实现为：array或者linked list</font>
4. <font color=green>序列容器可以通过计算得到位置地址，支持随机读取</font>
	1. push_bask: 所有序列容器都支持，因为都可以在末尾加入一个元素，而且效率很高。
	2. 数字下标操作: 
	3. 中段、起始段插入元素比较费时，因为安插点之后的所有元素都要移动。

5. 特殊情况
	1. list 不提供随机访问
	2. forward_list 不提供push_back()和size()
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
2. STL提供了4个定义好的无序容器：unordered_set、unordered_multiset、unordered_map、unordered_multimap
3. <font color=green>通常实现未hash table</font>
4. 内部是一个linked list 组成的array

### 迭代器
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
	1. bask_iterator
		- 调用push_back()
		- 支持push_back的容器有：vector、deque、list、string。array、forward_list不支持。

	2. front_iterator
		- 内部调用push_front()
		- 支持push_front()的容器有：deque、list、forward_list.

	3. iterator
		- 内部调用insert()
		- 所有STL都支持insert()成员函数，因此，这是唯一可用于关联式容器身上的一种预定义的inserter。

#### Stream iterator
> Stream 是一个用来表现I/O通道的对象。

#### Reverse iterator
> 所有提供双向或随机访问迭代器的容器都可以通过他们的成员函数rbegin和rend产生一个反向迭代器（也就是forward_list之外所有的序列容器和所有的关联容器）

1. forward_list和所有的无序容器都没有提供回向迭代接口，即rbegin()、rend().因为那些容器内部实现只是使用singly linked list 串起所有元素。


#### Move iterator
