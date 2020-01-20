## AVL树
> 和二叉搜索树相比，多了一个特点：任一节点的左右子树高度差最大为1.

### 高度
> 从叶子节点开始，起始高度为1，然后计算叶子节点的父节点，比较左右子树的高度，采取最大值再加1为这个节点的高度。以此类推

### 平衡因子
> 平衡因子也是从叶子节点开始，然后依次计算父节点。平衡因子等于：左子树高度 - 右子树高度

1. 带有平衡因子 -1， 1， 0的节点被认为是平衡的
2. 带有平衡因子 -2， 2 被认为是不平衡的。意味着需要调整这个树，平衡因子的绝对值不会超过高度差最大值 + 1
3. 平衡因子的绝对值不会出现大于 2.
4. 如果高度差最大值改为2，那么平衡因子就可以出现-3 或者3 了。

### 左旋右旋
1. 四种情况：LL, LR, RR, RL 