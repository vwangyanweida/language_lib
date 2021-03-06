## 第六章 二叉树和树

### 名词解释
	1. 树的度—— 一棵树中最大的结点度数 
	2. 双亲—— 孩子结点的上层结点叫该结点的双亲 
	3. 兄弟—— 同一双亲的孩子之间互成为兄弟 
	4. 祖先—— 结点的祖先是从根到该结点所经分支上的所有结点 
	5. 子孙—— 以某结点为根的子树中的任一结点都成为该结点的子孙 
	6. 结点的层次—— 从根结点算起，根为第一层，它的孩子为第二层…… 
	7. 堂兄弟—— 其双亲在同一层的结点互称为堂兄弟。 
	8. 深度—— 树中结点的最大层次数 
	9. 有序树—— 如果将树中结点的各子树看成从左至右是有次序的（即不能互换），则称该树为有序树，否则称为无序树。在有序树中最左边的子树的根称为第一个孩子，最右边的称为最后一个孩子。 
	10. 森林：0个或多个不相交的树组成。对森林加上一个根，森林即成为树；删去根，树即成为森林
	11. 二叉树：一种特殊的树，每个双亲的孩子数不超过2个（0个，1个或2个），提供对元素的高效访问。有左孩子和右孩子。
	12. 退化树：树中只有一个叶子结点，每个非叶子结点只有一个孩子。一颗退化树等价于一个链表。


### 二叉树：概念和性质
1. 概念
	> 二叉树是一棵树，且每个节点都不能有多于两个的儿子，且二叉树的子树有左右之分，次序不能颠倒

2. 性质
	1. 每个结点最多2棵子树, 
		1. 二叉树不存在度数大于2的结点
	2. 它是有序树,左子树、右子树是顺序的,不能交换次序
	3. 即使某个结点只有一棵子树,也要确定它是左子树还是右子树

3. 二叉树的五种基本形态
	- 空二叉树 
	- 只有一个根结点
	- 根结点只有左子树
	- 根结点只有右子树
	- 根结点有左子树和右子树

4. 二叉树的性质
	1. 在二叉树的第层上至多有2^(i-1)个结点(i21)

	2. 深度为k的二叉树,至多有2^k-1个节点(k21)
		1. 在二叉树中的第i层上至多有2^(i-1)个结点（i>=1)。
		2. 深度为k的二叉树至多有2^k - 1个节点（k>=1)。
		3. 对任何一棵二叉树T，如果其叶结点数目为n0，度为2的节点数目为n2，则n0=n2+1。

5. 满二叉树：如果二叉树中所有分支节点的度数都是2，则称它为一颗满二叉树。
	1. 满二叉树里的叶节点比分支节点多一个

6. 扩充二叉树： 
	1. 对二叉树T，如果加入足够多的新叶节点，使T的原有节点都变成度数为2的分支节点，得到的二叉树称为T的扩充二叉树。
	2. 扩充二叉树中新增的节点称为其外部节点， 原T的节点称为其内部结点。空树的扩充二叉树为空树

	3. 性质
		1. 在扩充二叉树中，外部结点的个数比内部结点的个数多1。 
		2. 对任意扩充二叉树，外部路径长度E和内部路径长度I之间满足以下关系：E=I+2n，其中n是内部结点个数。
		
7. 完全二叉树：
	1. 定义：
		在一棵二叉树中，除最后一层外，若其余层都是满的，并且最后一层或者是满的，或者是在右边缺少连续若干节点，则此二叉树为完全二叉树（Complete Binary Tree）。

	2. 性质
		1. 具有n个节点的完全二叉树的深度为 k=log2n 。
		2. 【满二叉树】i层的节点数目为：2^i
		3. 【满二叉树】节点总数和深度的关系：n=∑ki=2^(k+1) - 1
		4. 【完全二叉树】最后一层的节点数为：n-(2^k - 1)=n+1-2^k （因为除最后一层外，为【满二叉树】）
		5. 【完全二叉树】左子树的节点数为（总节点为n）：
			ln = n-2^k-1, if n+1-2^k <= 2^(k-1),else 2^k - 1, n+1-2^k > 2^(k-1)
		7. 【完全二叉树】右子树： r(n)=n-l(n)
		8. 如果根节点是0，对于任意节点i，父节点是(i-1)/2
		9. 如果2*i + 1 <n, 左子节点是 2*i+1, 否则无左子节点。
		10. 如果2*i + 2 <n, 右子节点是 2*i+2, 否则无右子节点。

8. 平衡二叉树
	1. 性质
		1. 它是一颗空树或它的左右两个子树的高度差的绝对值不超过1，并且左右两个子树都是一颗平衡二叉树。

8. 抽象数据类型
	1. ![图片](G:\picture\program_graph\二叉树ADT.png)
	2. 需要包含的操作：
		1. is_empty
		2. 访问左右子树
		3. 修改左右子树
		4. 遍历操作

9. 遍历二叉树
	1. 深度优先遍历
		1. 三种遍历方法
			- 先根序遍历
			- 中根序遍历/对称序
			- 后根序遍历
		2. 三种遍历序列：
			- 先根序遍历
			- 中根序遍历/对称序列
			- 后根序遍历
			 
		3. 若果之道了一个二叉树的对称序列，有知道另一遍历序列，可以唯一确定这个二叉树。

	2. 宽度优先遍历
		1. 又称为按层次顺序遍历。
		2. 不能写成一个递归过程

	3. 遍历：
		一颗二叉树可以看做一个状态空间。

### 二叉树的list实现

### 优先队列
#### 基于List实现优先队列
1. 插入排序方法，插入新值，形成一个有序列表。

#### 树形结构和堆
1. 采用树形结构实现优先队列的一种有效技术称为堆。
2. 解决堆插入和删除的关键操作称为筛选，又分为向上筛选和向下筛选。(构造堆和弹出堆顶)
	1. 插入元素和向上筛选
		1. 在一个堆的最后加入一个元素，得到的结果还可以看做完全二叉树，但未必是堆，为了把这样的完全二叉树恢复为堆，
		只需要做一次向上筛选。
		2. 不断用新加入的元素(设为e)与其父节点的数据相比较，若果e较小就交换两个元素的位置，通过这样的不断比较和交换，元素e不断上移。

	2. 弹出元素和向下筛选
		1. 因为堆顶元素就是最优先元素，所以应该弹出当时的堆顶元素
		2. 此时原堆变成两个子堆，
			1. 所以从堆的最后取出一个元素作为两个子堆的父元素，则剩余部分又变成一个完全二叉树。
			2. 而且除了对顶元素可能不满足堆序外，其余元素都满足堆序
			3. 所以只需要设法把结构恢复成一个堆，这种情况下恢复堆的操作称为**向下筛选**
		
		3. 向下筛选。
			1. 最后一个元素e，A和B是两个子堆
			2. 用e与A、B两个子堆的定元素（根）比较，最小者作为整个堆的顶
				1. 若e不是最小，最小的必然是A或B的根，设A的根为最小，将其移动到堆顶，相当于删除A的顶元素。
				2. 下面考虑将e放入去掉堆顶的A，这时规模更小的同一问题。
				3. B的根最小的情况可以同样处理。
			3. 如果某次比较e最小，以它为定的局部树已经成为了堆，整个结构也称为了堆。
			4. 或者e已经落到底，这时它自身就是一个堆，整个结构也成为堆。
		
#### 堆排序
1. 步骤：
	1. 堆分为最大堆和最小堆，其实就是完全二叉树
	2. 最大堆要求节点的元素都要不小于其孩子，最小堆要求节点元素都不大于其左右孩子
	3. **两者对左右孩子的大小关系不做任何要求**<F6>
	4. 处于最大堆的根节点的元素一定是这个堆中的最大值。
	5. 其实我们的堆排序算法就是抓住了堆的这一特点
		1. 每次都取堆顶的元素，将其放在序列最后面，然后将剩余的元素重新调整为最大堆，依次类推，最终得到排序的序列。
2. 总结
	1. 堆排序分两步：
		1. 构建最大堆
		2. 将堆顶元素排序
		3. 然后在将剩下的元素重新运行1,2。

	2. 算法复杂度是O(nlogn)，空间复杂度是O(1)

### 应用：离散事件模拟

### 二叉树的类实现
1. list实现和tuple实现前面已经介绍过，这里是链表实现

2. 二叉树实现需要用到的类
	1. 节点类：BinTNode：data，left， right

3. 基于BinTNode类的对象构造的二叉树具有递归的结构：

4. **链表形式的二叉树遍历操作可以用递归很方便的写出来。包括三种遍历方式、需要遍历所有节点的操作。**

5. eg
		t = BinTNode(1, BinTNode(2), BinTNode(3))

		def count_BinTNode(t):
			if t is None:
				return 0
			else:
				return 1 + count_BinTNode(t.left) + count_BinTNode(t.right)

		def sum_BinTNode(t):
			if t is None:
				return 0
			else:
				return t.data + sum_BinTNode(t.left) + sum_BinTNode(t.right)

		def preorder(t, proc): #proc是具体操作节点的方法  先序遍历
			if t is None:
				return
			proc(t.data)
			preorder(t.left)
			preorder(t.right)

5. 宽度优先遍历
	1. 处理一个节点时，函数先将其左右子节点顺序加入队列，这样实现的就是对每层节点从左到右的遍历。

7. 非递归的先根遍历函数
	1. 算法
		1. 由于采取先根序，遇到节点就应该访问，下一步应该沿着树的左枝下行
		2. 但节点的右分支还没有访问，因此需要记录，将右子节点入栈
		3. 遇到空的树时回溯，取出栈中保存的一个右分支，像一颗二叉树一样遍历它。
	
	2. 实现
			def preorder_nonrec(t, proc):
				s = SStack()
				while t is not None or not s.is_empty():
					while t is not None:
						proc(t.data)
						s.push(t.right)
						t = t.left
					t = s.pop()

8. 中根遍历和先根遍历相似

		def midorder_nonrec(t, proc):
			s = []
			while t is not None or s:
				while t is not None:
					s.append(t)
					t = t.left
				if s:
					m = s.pop()
					proc(m.data)
					if m.right:
						t = m.right

9. 后根序的非递归算法最难

		def postorder_nonrec(t, proc):
			s = []
			while t is not None or s:
				while t is not None:
					s.append(t)
					t = t.left if t.left else t.right

				t = s.pop()
				proc(t.data)
				if s and s[-1].left == t:
					t = s[-1].right
				else:
					t = None

10. 不使用基于节点构造的二叉树而是新定义二叉树
	1. 直接基于节点的二叉树具有递归结构，但是需要用None表示空树，并且封装的不够良好

	2. 直接定义一个二叉树类

			class BinTree(object):
				def __init__(self):
					self._root = None

				def is_empty(self):
					return self._root is None

				def root(self):
					return self._root

				def leftchild(self):
					return self._root.left

				def rightchild(self):
					return self._root.right

				def set_root(self, rootnode):
					self._root = rootnode

				def set_left(self, leftchild):
					self._root.left = leftchild

				def set_right(self, rightchild):
					self._root.right = rightchild
		
### 哈夫曼树
1. 注意看下扩充二叉树，扩充二叉树的外部路径长度是 E = I + 2 * n
2. 带权扩充二叉树的外部路径长度
	1. 每个外部节点有一个权值
	2. 长度是外部节点的长度乘以权值相加。WPL = wi * li + ……

3. 定义
	设有实数集W={w0，w1, w2, ……wm-1},T是一颗扩充二叉树，其m个外部节点分别以wi为权，而且T的带权外部路径WPL在所有这样的扩充二叉树中大道最小
	则称T为数据集W的最优二叉树或者哈弗曼树。

4. 哈夫曼算法
	1. 算法输入为实数集W={w0，w1, w2, ……wm-1}.
	2. 在构造中维护一个包含K颗二叉树的即可F，开始时k=m且F={T0,T1,……,Tm-1}，其中每个Ti是一颗只包含权为Wi的根节点的单点二叉树。
	3. 算法过程中重复执行下面两个步骤，直到集合F中剩下一颗树为止：
		1. 构造一棵新二叉树，其左右子树是从集合F中选取的两颗权最小的二叉树，其根节点的权值设置为这两个棵树的权值之和
		2. 将所选的两棵二叉树从F中删除，把新构造的二叉树加入F。

		![哈夫曼构造过程](G:\picture\program_graph\哈夫曼.png)

5. 实现
	1. 算法开始时建立一组单节点的二叉树，以权值作为优先码存入优先队列，要求取出队列里的最小元素。然后反复做下面两步，直至优先队列里只有一个元素。
		1. 从优先队列里弹出两个最小的元素（两个二叉树）
		2. 基于所取的二叉树构造一颗新的二叉树，其权值等于两个子树的权值之和，并将新构建的二叉树压入优先队列。
	2. 这里要有两个必须要解决的两个问题
		1. 需要为二叉树定义一个序，权值小的二叉树在前
		2. 需要检查优先度列里的元素（二叉树）个数，以便在只剩一棵树时结束。

6. 哈夫曼编码
	1. 定义：
		1. 问题：最优编码问题：给定基本数据集合：C={c0, c1,……, cm-1}, W={w0, w1,……, wm-1},其中集合C是要编码的字符集合，
			W为C中各个字符的实际信息(或则信息存储)中出现的频率。
		2. 要求：要求为C设计一套二进制编码，使得
			1. 用这种编码存储/传输时的平均开销最小
			2. 对任一对不同字符ci和cj，字符ci的编码不是cj编码的前缀。

	2. 哈夫曼编码的生成
		1. 以W={w0, w1,……, wm-1}作为m个外部节点的权，以C={c0, c1,……, cm-1}中字符作为外部节点的标注，基于W和相应结点集构造出一颗哈弗曼树。
		2. 在得到的哈夫曼树中，再从树中各个分支节点到其左子节点的边上标注二进制数字0；在所有到右子节点的边上标上1.
		3. 以从根节点到一个叶子节点（外部节点）的路径上的二进制数字序列，作为这个叶子节点的标记字符的编码，这样得到的就是哈夫曼编码。

	3. 编码
		编码时，从下到上，根据已知的编码节点，找他的父节点。每个节点表明是否是left还是right，然后根据相应规则加‘0’或者‘1’。倒着加。
