          ☆ torch.Tensor
              ○ abs() → Tensor
              ○ abs_() → Tensor
              ○ acos() → Tensor
              ○ acos_() → Tensor
              ○ add(value)
              ○ add_(value)
              ○ addbmm(beta=1, mat, alpha=1, batch1, batch2) → Tensor
              ○ addbmm_(beta=1, mat, alpha=1, batch1, batch2) → Tensor
              ○ addcdiv(value=1, tensor1, tensor2) → Tensor
              ○ addcdiv_(value=1, tensor1, tensor2) → Tensor
              ○ addcmul(value=1, tensor1, tensor2) → Tensor
              ○ addcmul_(value=1, tensor1, tensor2) → Tensor
              ○ addmm(beta=1, mat, alpha=1, mat1, mat2) → Tensor
              ○ addmm_(beta=1, mat, alpha=1, mat1, mat2) → Tensor
              ○ addmv(beta=1, tensor, alpha=1, mat, vec) → Tensor
              ○ addmv_(beta=1, tensor, alpha=1, mat, vec) → Tensor
              ○ addr(beta=1, alpha=1, vec1, vec2) → Tensor
              ○ addr_(beta=1, alpha=1, vec1, vec2) → Tensor
              ○ apply_(callable) → Tensor
              ○ asin() → Tensor
              ○ asin_() → Tensor
              ○ atan() → Tensor
              ○ atan2() → Tensor
              ○ atan2_() → Tensor
              ○ atan_() → Tensor
              ○ baddbmm(beta=1, alpha=1, batch1, batch2) → Tensor
              ○ baddbmm_(beta=1, alpha=1, batch1, batch2) → Tensor
              ○ bernoulli() → Tensor
              ○ bernoulli_() → Tensor
              ○ bmm(batch2) → Tensor
              ○ byte() → Tensor
              ○ bmm(median=0, sigma=1, *, generator=None) → Tensor
              ○ ceil() → Tensor
              ○ ceil_() → Tensor
              ○ char()
              ○ chunk(n_chunks, dim=0) → Tensor
              ○ clamp(min, max) → Tensor
              ○ clamp_(min, max) → Tensor
              ○ clone() → Tensor
              ○ contiguous() → Tensor
              ○ copy_(src, async=False) → Tensor
              ○ cos() → Tensor
              ○ cos_() → Tensor
              ○ cosh() → Tensor
              ○ cosh_() → Tensor
              ○ cpu() → Tensor
              ○ cross(other, dim=-1) → Tensor
              ○ cuda(device=None, async=False)
              ○ cumprod(dim) → Tensor
              ○ cumsum(dim) → Tensor
              ○ data_ptr() → int
              ○ diag(diagonal=0) → Tensor
              ○ dim() → int
              ○ dist(other, p=2) → Tensor
              ○ div(value)
              ○ div_(value)
              ○ dot(tensor2) → float
              ○ double()
              ○ eig(eigenvectors=False) -> (Tensor, Tensor)
              ○ element_size() → int
              ○ eq(other) → Tensor
              ○ eq_(other) → Tensor
              ○ equal(other) → bool
              ○ exp() → Tensor
              ○ exp_() → Tensor
              ○ expand(*sizes)
              ○ expand_as(tensor)
              ○ exponential_(lambd=1, *, generator=None) $to$ Tensor
              ○ fill_(value) → Tensor
              ○ float()
              ○ floor() → Tensor
              ○ floor_() → Tensor
              ○ fmod(divisor) → Tensor
              ○ fmod_(divisor) → Tensor
              ○ frac() → Tensor
              ○ frac_() → Tensor
              ○ gather(dim, index) → Tensor
              ○ ge(other) → Tensor
              ○ ge_(other) → Tensor
              ○ gels(A) → Tensor
              ○ geometric_(p, *, generator=None) → Tensor
              ○ geqrf() -> (Tensor, Tensor)
              ○ ger(vec2) → Tensor
              ○ gesv(A) → Tensor, Tensor
              ○ gt(other) → Tensor
              ○ gt_(other) → Tensor
              ○ half()
              ○ histc(bins=100, min=0, max=0) → Tensor
              ○ index(m) → Tensor
              ○ index_add_(dim, index, tensor) → Tensor
              ○ index_copy_(dim, index, tensor) → Tensor
              ○ index_fill_(dim, index, val) → Tensor
              ○ index_select(dim, index) → Tensor
              ○ int()
              ○ inverse() → Tensor
              ○ is_contiguous() → bool
              ○ is_cuda
              ○ is_pinned()
              ○ is_set_to(tensor) → bool
              ○ is_signed()
              ○ kthvalue(k, dim=None) -> (Tensor, LongTensor)
              ○ le(other) → Tensor
              ○ le_(other) → Tensor
              ○ lerp(start, end, weight)
              ○ lerp_(start, end, weight) → Tensor
              ○ log() → Tensor
              ○ loglp() → Tensor
              ○ loglp_() → Tensor
              ○ log_()→ Tensor
              ○ log_normal_(mwan=1, std=2, , gegnerator=None*)
              ○ long()
              ○ lt(other) → Tensor
              ○ lt_(other) → Tensor
              ○ map_(tensor, callable)
              ○ masked_copy_(mask, source)
              ○ masked_fill_(mask, value)
              ○ masked_select(mask) → Tensor
              ○ max(dim=None) -> float or(Tensor, Tensor)
              ○ mean(dim=None) -> float or(Tensor, Tensor)
              ○ median(dim=-1, value=None, indices=None) -> (Tensor, LongTensor)
              ○ min(dim=None) -> float or(Tensor, Tensor)
              ○ mm(mat2) → Tensor
              ○ mode(dim=-1, value=None, indices=None) -> (Tensor, LongTensor)
              ○ mul(value) → Tensor
              ○ mul_(value)
              ○ multinomial(num_samples, replacement=False, , generator=None*) → Tensor
              ○ mv(vec) → Tensor
              ○ narrow(dimension, start, length) → Te
              ○ ndimension() → int
              ○ ne(other) → Tensor
              ○ ne_(other) → Tensor
              ○ neg() → Tensor
              ○ neg_() → Tensor
              ○ nelement() → int
              ○ new(args, *kwargs)
              ○ nonezero() → LongTensor
              ○ norm(p=2) → float
              ○ normal_(mean=0, std=1, , gengerator=None*)
              ○ numel() → int
              ○ numpy() → ndarray
              ○ orgqr(input2) → Tensor
              ○ ormqr(input2, input3, left=True, transpose=False) → Tensor
              ○ permute(dims)
              ○ pin_memory()
              ○ potrf(upper=True) → Tensor
              ○ potri(upper=True) → Tensor
              ○ potrs(input2, upper=True) → Tensor
              ○ pow(exponent)
              ○ pow_()
              ○ prod()) → float
              ○ pstrf(upper=True, tol=-1) -> (Tensor, IntTensor)
              ○ qr()-> (Tensor, IntTensor)
              ○ random_(from=0, to=None, *, generator=None)
              ○ reciprocal() → Tensor
              ○ reciprocal_() → Tensor
              ○ remainder(divisor) → Tensor
              ○ remainder_(divisor) → Tensor
              ○ renorm(p, dim, maxnorm) → Tensor
              ○ renorm_(p, dim, maxnorm) → Tensor
              ○ repeat(*sizes)
              ○ resize_(*sizes)
              ○ resize_as_(tensor)
              ○ round() → Tensor
              ○ round_() → Tensor
              ○ rsqrt() → Tensor
              ○ rsqrt_() → Tensor
              ○ scatter_(input, dim, index, src) → Tensor
              ○ select(dim, index) → Tensor or number
              ○ set(source=None, storage_offset=0, size=None, stride=None)
              ○ share_memory_()
              ○ short()
              ○ sigmoid() → Tensor
              ○ sigmoid_() → Tensor
              ○ sign() → Tensor
              ○ sign_() → Tensor
              ○ sin() → Tensor
              ○ sin_() → Tensor
              ○ sinh() → Tensor
              ○ sinh_() → Tensor
              ○ size() → torch.Size
              ○ sort(dim=None, descending=False) -> (Tensor, LongTensor)
              ○ split(split_size, dim=0)
              ○ sqrt() → Tensor
              ○ sqrt_() → Tensor
              ○ squeeze(dim=None) → Tensor
              ○ squeeze_(dim=None) → Tensor
              ○ std() → float
              ○ storage() → torch.Storage
              ○ storage_offset() → int
              ○ classmethod() storage_type()
              ○ stride() → Tensor
              ○ sub(value, other) → Tensor
              ○ sub_(x) → Tensor
              ○ sum(dim=None) → Tensor
              ○ svd(some=True) -> (Tensor, Tensor, Tensor)
              ○ symeig(_eigenvectors=False, upper=True) -> (Tensor, Tensor)
              ○ t() → Tensor
              ○ t() → Tensor
              ○ tan() → Tensor
              ○ tan_() → Tensor
              ○ tanh() → Tensor
              ○ tanh_() → Tensor
              ○ tolist()
              ○ topk(k, dim=None, largest=True, sorted=True) -> (Tensor, LongTensor)
              ○ trace() → float
              ○ transpose(dim0, dim1) → Tensor
              ○ transpose(dim0, dim1) → Tensor
              ○ tril(k=0) → Tensor
              ○ tril_(k=0) → Tensor
              ○ triu(k=0) → Tensor
              ○ triu(k=0) → Tensor
              ○ trtrs(A, upper=True, transpose=False, unitriangular=False) -> (Tensor, Tensor)
              ○ trunc() → Tensor
              ○ trunc() → Tensor
              ○ type(new_type=None, async=False)
              ○ type_as(tesnor)
              ○ unfold(dim, size, step) → Tensor
              ○ uniform_(from=0, to=1) → Tensor
              ○ unsqueeze(dim)
              ○ unsqueeze_(dim) → Tensor
              ○ var()
              ○ view(*args) → Tensor
              ○ view_as(tensor)
              ○ zero_()
      □ torch.Storage
      □ torch.nn
      □ torch.nn.functional
      □ torch.autograd
      □ torch.optim
      □ torch.nn.init
      □ torch.multiprocessing
      □ torch.legacy
      □ torch.cuda
      □ torch.utils.ffi
      □ torch.utils.data
      □ torch.utils.model_zoo
  • TORCHVISION参考
      □ torchvision
      □ torchvision.datasets
      □ torchvision.models
      □ torchvision.transforms
      □ torchvision.utils
  • 致谢

  PyTorch中文文档

  • Docs »
  • PACKAGE参考 »
  • torch.Tensor
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

torch.Tensor

torch.Tensor是一种包含单一数据类型元素的多维矩阵。

Torch定义了七种CPU tensor类型和八种GPU tensor类型：

Data tyoe                 CPU tensor         GPU tensor
32-bit floating point     torch.FloatTensor  torch.cuda.FloatTensor
64-bit floating point     torch.DoubleTensor torch.cuda.DoubleTensor
16-bit floating point     N/A                torch.cuda.HalfTensor
8-bit integer (unsigned)  torch.ByteTensor   torch.cuda.ByteTensor
8-bit integer (signed)    torch.CharTensor   torch.cuda.CharTensor
16-bit integer (signed)   torch.ShortTensor  torch.cuda.ShortTensor
32-bit integer (signed)   torch.IntTensor    torch.cuda.IntTensor
64-bit integer (signed)   torch.LongTensor   torch.cuda.LongTensor

torch.Tensor是默认的tensor类型（torch.FlaotTensor）的简称。

一个张量tensor可以从Python的list或序列构建：

>>> torch.FloatTensor([[1, 2, 3], [4, 5, 6]])
1 2 3
4 5 6
[torch.FloatTensor of size 2x3]

一个空张量tensor可以通过规定其大小来构建：

>>> torch.IntTensor(2, 4).zero_()
0 0 0 0
0 0 0 0
[torch.IntTensor of size 2x4]

可以用python的索引和切片来获取和修改一个张量tensor中的内容：

>>> x = torch.FloatTensor([[1, 2, 3], [4, 5, 6]])
>>> print(x[1][2])
6.0
>>> x[0][1] = 8
>>> print(x)
 1 8 3
 4 5 6
[torch.FloatTensor of size 2x3]

每一个张量tensor都有一个相应的torch.Storage用来保存其数据。类tensor提供了一个存储的多维的、横向视图，并且定义了在数值运算
。

    ！注意：会改变tensor的函数操作会用一个下划线后缀来标示。比如，torch.FloatTensor.abs_()会在原地计算绝对值，并返回改变后
    的tensor，而tensor.FloatTensor.abs()将会在一个新的tensor中计算结果。

class torch.Tensor
class torch.Tensor(*sizes)
class torch.Tensor(size)
class torch.Tensor(sequence)
class torch.Tensor(ndarray)
class torch.Tensor(tensor)
class torch.Tensor(storage)

根据可选择的大小和数据新建一个tensor。如果没有提供参数，将会返回一个空的零维张量。如果提供了numpy.ndarray,torch.Tensor或
torch.Storage，将会返回一个有同样参数的tensor.如果提供了python序列，将会从序列的副本创建一个tensor。

abs() → Tensor

请查看torch.abs()

abs_() → Tensor

abs()的in-place运算形式

acos() → Tensor

请查看torch.acos()

acos_() → Tensor

acos()的in-place运算形式

add(value)

请查看torch.add()

add_(value)

add()的in-place运算形式

addbmm(beta=1, mat, alpha=1, batch1, batch2) → Tensor

请查看torch.addbmm()

addbmm_(beta=1, mat, alpha=1, batch1, batch2) → Tensor

addbmm()的in-place运算形式

addcdiv(value=1, tensor1, tensor2) → Tensor

请查看torch.addcdiv()

addcdiv_(value=1, tensor1, tensor2) → Tensor

addcdiv()的in-place运算形式

addcmul(value=1, tensor1, tensor2) → Tensor

请查看torch.addcmul()

addcmul_(value=1, tensor1, tensor2) → Tensor

addcmul()的in-place运算形式

addmm(beta=1, mat, alpha=1, mat1, mat2) → Tensor

请查看torch.addmm()

addmm_(beta=1, mat, alpha=1, mat1, mat2) → Tensor

addmm()的in-place运算形式

addmv(beta=1, tensor, alpha=1, mat, vec) → Tensor

请查看torch.addmv()

addmv_(beta=1, tensor, alpha=1, mat, vec) → Tensor

addmv()的in-place运算形式

addr(beta=1, alpha=1, vec1, vec2) → Tensor

请查看torch.addr()

addr_(beta=1, alpha=1, vec1, vec2) → Tensor

addr()的in-place运算形式

apply_(callable) → Tensor

将函数callable作用于tensor中每一个元素，并将每个元素用callable函数返回值替代。

    ！注意：该函数只能在CPU tensor中使用，并且不应该用在有较高性能要求的代码块。

asin() → Tensor

请查看torch.asin()

asin_() → Tensor

asin()的in-place运算形式

atan() → Tensor

请查看torch.atan()

atan2() → Tensor

请查看torch.atan2()

atan2_() → Tensor

atan2()的in-place运算形式

atan_() → Tensor

atan()的in-place运算形式

baddbmm(beta=1, alpha=1, batch1, batch2) → Tensor

请查看torch.baddbmm()

baddbmm_(beta=1, alpha=1, batch1, batch2) → Tensor

baddbmm()的in-place运算形式

bernoulli() → Tensor

请查看torch.bernoulli()

bernoulli_() → Tensor

bernoulli()的in-place运算形式

bmm(batch2) → Tensor

请查看torch.bmm()

byte() → Tensor

将tensor改为byte类型

bmm(median=0, sigma=1, *, generator=None) → Tensor

将tensor中元素用柯西分布得到的数值填充： $$ P(x)={\frac1 \pi} {\frac \sigma {(x-median)^2 + \sigma^2}} $$

ceil() → Tensor

请查看torch.ceil()

ceil_() → Tensor

ceil()的in-place运算形式

char()

将tensor元素改为char类型

chunk(n_chunks, dim=0) → Tensor

将tensor分割为tensor元组. 请查看torch.chunk()

clamp(min, max) → Tensor

请查看torch.clamp()

clamp_(min, max) → Tensor

clamp()的in-place运算形式

clone() → Tensor

返回与原tensor有相同大小和数据类型的tensor

contiguous() → Tensor

返回一个内存连续的有相同数据的tensor，如果原tensor内存连续则返回原tensor

copy_(src, async=False) → Tensor

将src中的元素复制到tensor中并返回这个tensor。两个tensor应该有相同数目的元素，可以是不同的数据类型或存储在不同的设备上。参
数： - src (Tensor)-复制的源tensor - async (bool)-如果为True并且复制是在CPU和GPU之间进行的，则复制后的拷贝可能会与源信息异
步，对于其他类型的复制操作则该参数不会发生作用。

cos() → Tensor

请查看torch.cos()

cos_() → Tensor

cos()的in-place运算形式

cosh() → Tensor

请查看torch.cosh()

cosh_() → Tensor

cosh()的in-place运算形式

cpu() → Tensor

如果在CPU上没有该tensor，则会返回一个CPU的副本

cross(other, dim=-1) → Tensor

请查看torch.cross()

cuda(device=None, async=False)

返回此对象在CPU内存中的一个副本如果对象已近存在与CUDA存储中并且在正确的设备上，则不会进行复制并返回原始对象。

参数： - device(int)-目的GPU的id，默认为当前的设备。 - async(bool)-如果为True并且资源在固定内存中，则复制的副本将会与原始
数据异步。否则，该参数没有意义。

cumprod(dim) → Tensor

请查看torch.cumprod()

cumsum(dim) → Tensor

请查看torch.cumsum()

data_ptr() → int

返回tensor第一个元素的地址

diag(diagonal=0) → Tensor

请查看torch.diag()

dim() → int

返回tensor的维数

dist(other, p=2) → Tensor

请查看torch.dist()

div(value)

请查看torch.div()

div_(value)

div()的in-place运算形式

dot(tensor2) → float

请查看torch.dot()

double()

将该tensor投射为double类型

eig(eigenvectors=False) -> (Tensor, Tensor)

请查看torch.eig()

element_size() → int

返回单个元素的字节大小。例：

>>> torch.FloatTensor().element_size()
4
>>> torch.ByteTensor().element_size()
1

eq(other) → Tensor

请查看torch.eq()

eq_(other) → Tensor

eq()的in-place运算形式

equal(other) → bool

请查看torch.equal()

exp() → Tensor

请查看torch.exp()

exp_() → Tensor

exp()的in-place运算形式

expand(*sizes)

返回tensor的一个新视图，单个维度扩大为更大的尺寸。 tensor也可以扩大为更高维，新增加的维度将附在前面。扩大tensor不需要分配
新内存，只是仅仅新建一个tensor的视图，其中通过将stride设为0，一维将会扩展位更高维。任何一个一维的在不分配新内存情况下可扩
展为任意的数值。

参数： - sizes(torch.Size or int...)-需要扩展的大小

例：

>>> x = torch.Tensor([[1], [2], [3]])
>>> x.size()
torch.Size([3, 1])
>>> x.expand(3, 4)
 1 1
 1 1
 2 2 2 2
 3 3 3 3
 [torch.FloatTensor of size 3x4]

expand_as(tensor)

将tensor扩展为参数tensor的大小。该操作等效与：

self.expand(tensor.size())

exponential_(lambd=1, *, generator=None) $to$ Tensor

将该tensor用指数分布得到的元素填充： $$ P(x)= \lambda e^{- \lambda x} $$

fill_(value) → Tensor

将该tensor用指定的数值填充

float()

将tensor投射为float类型

floor() → Tensor

请查看torch.floor()

floor_() → Tensor

floor()的in-place运算形式

fmod(divisor) → Tensor

请查看torch.fmod()

fmod_(divisor) → Tensor

fmod()的in-place运算形式

frac() → Tensor

请查看torch.frac()

frac_() → Tensor

frac()的in-place运算形式

gather(dim, index) → Tensor

请查看torch.gather()

ge(other) → Tensor

请查看torch.ge()

ge_(other) → Tensor

ge()的in-place运算形式

gels(A) → Tensor

请查看torch.gels()

geometric_(p, *, generator=None) → Tensor

将该tensor用几何分布得到的元素填充： $$ P(X=k)= (1-p)^{k-1}p $$

geqrf() -> (Tensor, Tensor)

请查看torch.geqrf()

ger(vec2) → Tensor

请查看torch.ger()

gesv(A) → Tensor, Tensor

请查看torch.gesv()

gt(other) → Tensor

请查看torch.gt()

gt_(other) → Tensor

gt()的in-place运算形式

half()

将tensor投射为半精度浮点类型

histc(bins=100, min=0, max=0) → Tensor

请查看torch.histc()

index(m) → Tensor

用一个二进制的掩码或沿着一个给定的维度从tensor中选取元素。tensor.index(m)与tensor[m]完全相同。

参数： - m(int or Byte Tensor or slice)-用来选取元素的维度或掩码

index_add_(dim, index, tensor) → Tensor

按参数index中的索引数确定的顺序，将参数tensor中的元素加到原来的tensor中。参数tensor的尺寸必须严格地与原tensor匹配，否则会
发生错误。

参数： - dim(int)-索引index所指向的维度 - index(LongTensor)-需要从tensor中选取的指数 - tensor(Tensor)-含有相加元素的tensor

例：

>>> x = torch.Tensor([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
>>> t = torch.Tensor([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
>>> index = torch.LongTensor([0, 2, 1])
>>> x.index_add_(0, index, t)
>>> x
  2 3 4
  8 9 10
  5 6 7
[torch.FloatTensor of size 3x3]

index_copy_(dim, index, tensor) → Tensor

按参数index中的索引数确定的顺序，将参数tensor中的元素复制到原来的tensor中。参数tensor的尺寸必须严格地与原tensor匹配，否则
会发生错误。

参数： - dim (int)-索引index所指向的维度 - index (LongTensor)-需要从tensor中选取的指数 - tensor (Tensor)-含有被复制元素的
tensor

例：

>>> x = torch.Tensor(3， 3)
>>> t = torch.Tensor([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
>>> index = torch.LongTensor([0, 2, 1])
>>> x.index_copy_(0, index, t)
>>> x
  1 2 3
  7 8 9
  4 5 6
[torch.FloatTensor of size 3x3]

index_fill_(dim, index, val) → Tensor

按参数index中的索引数确定的顺序，将原tensor用参数val值填充。

参数： - dim (int)-索引index所指向的维度 - index (LongTensor)-索引 - val (Tensor)-填充的值

例：

>>> x = torch.Tensor([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
>>> index = torch.LongTensor([0, 2])
>>> x.index_fill_(0, index, -1)
>>> x
  -1 2 -1
  -1 5 -1
  -1 8 -1
[torch.FloatTensor of size 3x3]

index_select(dim, index) → Tensor

请查看torch.index_select()

int()

将该tensor投射为int类型

inverse() → Tensor

请查看torch.inverse()

is_contiguous() → bool

如果该tensor在内存中是连续的则返回True。

is_cuda

is_pinned()

如果该tensor在固定内内存中则返回True

is_set_to(tensor) → bool

如果此对象引用与Torch C API相同的THTensor对象作为给定的张量，则返回True。

is_signed()

kthvalue(k, dim=None) -> (Tensor, LongTensor)

请查看torch.kthvalue()

le(other) → Tensor

请查看torch.le()

le_(other) → Tensor

le()的in-place运算形式

lerp(start, end, weight)

请查看torch.lerp()

lerp_(start, end, weight) → Tensor

lerp()的in-place运算形式

log() → Tensor

请查看torch.log()

loglp() → Tensor

请查看torch.loglp()

loglp_() → Tensor

loglp()的in-place运算形式

log_()→ Tensor

log()的in-place运算形式

log_normal_(mwan=1, std=2, , gegnerator=None*)

将该tensor用均值为$\mu$,标准差为$\sigma$的对数正态分布得到的元素填充。要注意mean和stdv是基本正态分布的均值和标准差，不是返
回的分布： $$ P(X)= \frac {1} {x \sigma \sqrt {2 \pi}}e^{- \frac {(lnx- \mu)^2} {2 \sigma^2}} $$

long()

将tensor投射为long类型

lt(other) → Tensor

请查看torch.lt()

lt_(other) → Tensor

lt()的in-place运算形式

map_(tensor, callable)

将callable作用于本tensor和参数tensor中的每一个元素，并将结果存放在本tensor中。callable应该有下列标志：

def callable(a, b) -> number

masked_copy_(mask, source)

将mask中值为1元素对应的source中位置的元素复制到本tensor中。mask应该有和本tensor相同数目的元素。source中元素的个数最少为
mask中值为1的元素的个数。

参数： - mask (ByteTensor)-二进制掩码 - source (Tensor)-复制的源tensor

    注意： mask作用于self自身的tensor，而不是参数中的source。

masked_fill_(mask, value)

在mask值为1的位置处用value填充。mask的元素个数需和本tensor相同，但尺寸可以不同。

参数： - mask (ByteTensor)-二进制掩码 - value (Tensor)-用来填充的值

masked_select(mask) → Tensor

请查看torch.masked_select()

max(dim=None) -> float or(Tensor, Tensor)

请查看torch.max()

mean(dim=None) -> float or(Tensor, Tensor)

请查看torch.mean()

median(dim=-1, value=None, indices=None) -> (Tensor, LongTensor)

请查看torch.median()

min(dim=None) -> float or(Tensor, Tensor)

请查看torch.min()

mm(mat2) → Tensor

请查看torch.mm()

mode(dim=-1, value=None, indices=None) -> (Tensor, LongTensor)

请查看torch.mode()

mul(value) → Tensor

请查看torch.mul()

mul_(value)

mul()的in-place运算形式

multinomial(num_samples, replacement=False, , generator=None*) → Tensor

请查看torch.multinomial()

mv(vec) → Tensor

请查看torch.mv()

narrow(dimension, start, length) → Te

返回一个本tensor经过缩小后的tensor。维度dim缩小范围是start到start+length。原tensor与返回的tensor共享相同的底层内存。

参数： - dimension (int)-需要缩小的维度 - start (int)-起始维度 - length (int)-

例:

>>> x = torch.Tensor([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
>>> x.narrow(0, 0, 2)
 1  2  3
 4  5  6
[torch.FloatTensor of size 2x3]
>>> x.narrow(1, 1, 2)
 2  3
 5  6
 8  9
[torch.FloatTensor of size 3x2]

ndimension() → int

dim()的另一种表示。

ne(other) → Tensor

请查看torch.ne()

ne_(other) → Tensor

ne()的in-place运算形式

neg() → Tensor

请查看torch.neg()

neg_() → Tensor

neg()的in-place运算形式

nelement() → int

numel()的另一种表示

new(args, *kwargs)

构建一个有相同数据类型的tensor

nonezero() → LongTensor

请查看`torch.nonezero()

norm(p=2) → float

请查看`torch.norm()

normal_(mean=0, std=1, , gengerator=None*)

将tensor用均值为mean和标准差为std的正态分布填充。

numel() → int

请查看numel()

numpy() → ndarray

将该tensor以NumPy的形式返回ndarray，两者共享相同的底层内存。原tensor改变后会相应的在ndarray有反映，反之也一样。

orgqr(input2) → Tensor

请查看torch.orgqr()

ormqr(input2, input3, left=True, transpose=False) → Tensor

请查看torch.ormqr()

permute(dims)

将tensor的维度换位。

参数： - __dims__ (int..*)-换位顺序

例：

>>> x = torch.randn(2, 3, 5)
>>> x.size()
torch.Size([2, 3, 5])
>>> x.permute(2, 0, 1).size()
torch.Size([5, 2, 3])

pin_memory()

如果原来没有在固定内存中，则将tensor复制到固定内存中。

potrf(upper=True) → Tensor

请查看torch.potrf()

potri(upper=True) → Tensor

请查看torch.potri()

potrs(input2, upper=True) → Tensor

请查看torch.potrs()

pow(exponent)

请查看torch.pow()

pow_()

pow()的in-place运算形式

prod()) → float

请查看torch.prod()

pstrf(upper=True, tol=-1) -> (Tensor, IntTensor)

请查看torch.pstrf()

qr()-> (Tensor, IntTensor)

请查看torch.qr()

random_(from=0, to=None, *, generator=None)

将tensor用从在[from, to-1]上的正态分布或离散正态分布取样值进行填充。如果没有明确说明，则填充值仅由本tensor的数据类型限定。

reciprocal() → Tensor

请查看torch.reciprocal()

reciprocal_() → Tensor

reciprocal()的in-place运算形式

remainder(divisor) → Tensor

请查看torch.remainder()

remainder_(divisor) → Tensor

remainder()的in-place运算形式

renorm(p, dim, maxnorm) → Tensor

请查看torch.renorm()

renorm_(p, dim, maxnorm) → Tensor

renorm()的in-place运算形式

repeat(*sizes)

沿着指定的维度重复tensor。不同于expand()，本函数复制的是tensor中的数据。

参数： - *sizes (torch.Size ot int...)-沿着每一维重复的次数

例：

>>> x = torch.Tensor([1, 2, 3])
>>> x.repeat(4, 2)
 1  2  3  1  2  3
 1  2  3  1  2  3
 1  2  3  1  2  3
 1  2  3  1  2  3
[torch.FloatTensor of size 4x6]
>>> x.repeat(4, 2, 1).size()
torch.Size([4, 2, 3])

resize_(*sizes)

将tensor的大小调整为指定的大小。如果元素个数比当前的内存大小大，就将底层存储大小调整为与新元素数目一致的大小。如果元素个数
比当前内存小，则底层存储不会被改变。原来tensor中被保存下来的元素将保持不变，但新内存将不会被初始化。

参数： - *sizes (torch.Size or int...)-需要调整的大小

例：

>>> x = torch.Tensor([[1, 2], [3, 4], [5, 6]])
>>> x.resize_(2, 2)
>>> x
 1  2
 3  4
[torch.FloatTensor of size 2x2]

resize_as_(tensor)

将本tensor的大小调整为与参数中的tensor相同的大小。等效于：

self.resize_(tensor.size())

round() → Tensor

请查看torch.round()

round_() → Tensor

round()的in-place运算形式

rsqrt() → Tensor

请查看torch.rsqrt()

rsqrt_() → Tensor

rsqrt()的in-place运算形式

scatter_(input, dim, index, src) → Tensor

将src中的所有值按照index确定的索引写入本tensor中。其中索引是根据给定的dimension，dim按照gather()描述的规则来确定。

注意，index的值必须是在_0_到_(self.size(dim)-1)_之间，

参数： - input (Tensor)-源tensor - dim (int)-索引的轴向 - index (LongTensor)-散射元素的索引指数 - src (Tensor or float)-散
射的源元素

例：

>>> x = torch.rand(2, 5)
>>> x

 0.4319  0.6500  0.4080  0.8760  0.2355
 0.2609  0.4711  0.8486  0.8573  0.1029
[torch.FloatTensor of size 2x5]

>>> torch.zeros(3, 5).scatter_(0, torch.LongTensor([[0, 1, 2, 0, 0], [2, 0, 0, 1, 2]]), x)

 0.4319  0.4711  0.8486  0.8760  0.2355
 0.0000  0.6500  0.0000  0.8573  0.0000
 0.2609  0.0000  0.4080  0.0000  0.1029
[torch.FloatTensor of size 3x5]

>>> z = torch.zeros(2, 4).scatter_(1, torch.LongTensor([[2], [3]]), 1.23)
>>> z

 0.0000  0.0000  1.2300  0.0000
 0.0000  0.0000  0.0000  1.2300
[torch.FloatTensor of size 2x4]

select(dim, index) → Tensor or number

按照index中选定的维度将tensor切片。如果tensor是一维的，则返回一个数字。否则，返回给定维度已经被移除的tensor。

参数： - dim (int)-切片的维度 - index (int)-用来选取的索引

    !注意： select()等效于切片。例如，tensor.select(0, index)等效于tensor[index]，tensor.select(2, index)等效于tensor[:,
    :, index].

set(source=None, storage_offset=0, size=None, stride=None)

设置底层内存，大小和步长。如果tensor是一个tensor，则将会与本tensor共享底层内存并且有相同的大小和步长。改变一个tensor中的元
素将会反映在另一个tensor。如果source是一个Storage，则将设置底层内存，偏移量，大小和步长。

参数： - source (Tensor or Storage)-用到的tensor或内存 - storage_offset (int)-内存的偏移量 - size (torch.Size)-需要的大小
，默认为源tensor的大小。 - stride(tuple)-需要的步长，默认为C连续的步长。

share_memory_()

将底层内存移到共享内存中。如果底层内存已经在共享内存中是将不进行任何操作。在共享内存中的tensor不能调整大小。

short()

将tensor投射为short类型。

sigmoid() → Tensor

请查看torch.sigmoid()

sigmoid_() → Tensor

sidmoid()的in-place运算形式

sign() → Tensor

请查看torch.sign()

sign_() → Tensor

sign()的in-place运算形式

sin() → Tensor

请查看torch.sin()

sin_() → Tensor

sin()的in-place运算形式

sinh() → Tensor

请查看torch.sinh()

sinh_() → Tensor

sinh()的in-place运算形式

size() → torch.Size

返回tensor的大小。返回的值是tuple的子类。

例：

>>> torch.Tensor(3, 4, 5).size()
torch.Size([3, 4, 5])

sort(dim=None, descending=False) -> (Tensor, LongTensor)

请查看torhc.sort()

split(split_size, dim=0)

将tensor分割成tensor数组。请查看torhc.split()

sqrt() → Tensor

请查看torch.sqrt()

sqrt_() → Tensor

sqrt()的in-place运算形式

squeeze(dim=None) → Tensor

请查看torch.squeeze()

squeeze_(dim=None) → Tensor

squeeze()的in-place运算形式

std() → float

请查看torch.std()

storage() → torch.Storage

返回底层内存。

storage_offset() → int

以储存元素的个数的形式返回tensor在地城内存中的偏移量。例：

>>> x = torch.Tensor([1, 2, 3, 4, 5])
>>> x.storage_offset()
0
>>> x[3:].storage_offset()
3

classmethod() storage_type()

stride() → Tensor

返回tesnor的步长。

sub(value, other) → Tensor

从tensor中抽取一个标量或tensor。如果value和other都是给定的，则在使用之前other的每一个元素都会被value缩放。

sub_(x) → Tensor

sub()的in-place运算形式

sum(dim=None) → Tensor

请查看torch.sum()

svd(some=True) -> (Tensor, Tensor, Tensor)

请查看torch.svd()

symeig(_eigenvectors=False, upper=True) -> (Tensor, Tensor)

请查看torch.symeig()

t() → Tensor

请查看torch.t()

t() → Tensor

t()的in-place运算形式

tan() → Tensor

请查看torch.tan()

tan_() → Tensor

tan()的in-place运算形式

tanh() → Tensor

请查看torch.tanh()

tanh_() → Tensor

tanh()的in-place运算形式

tolist()

返回一个tensor的嵌套列表表示。

topk(k, dim=None, largest=True, sorted=True) -> (Tensor, LongTensor)

请查看torch.topk()

trace() → float

请查看torch.trace()

transpose(dim0, dim1) → Tensor

请查看torch.transpose()

transpose(dim0, dim1) → Tensor

transpose()的in-place运算形式

tril(k=0) → Tensor

请查看torch.tril()

tril_(k=0) → Tensor

tril()的in-place运算形式

triu(k=0) → Tensor

请查看torch.triu()

triu(k=0) → Tensor

triu()的in-place运算形式

trtrs(A, upper=True, transpose=False, unitriangular=False) -> (Tensor, Tensor)

请查看torch.trtrs()

trunc() → Tensor

请查看torch.trunc()

trunc() → Tensor

trunc()的in-place运算形式

type(new_type=None, async=False)

将对象投为指定的类型。如果已经是正确的类型，则不会进行复制并返回原对象。

参数： - new_type (type or string)-需要的类型 - async (bool)-如果为True，并且源地址在固定内存中，目的地址在GPU或者相反，则
会相对于源主异步执行复制。否则，该参数不发挥作用。

type_as(tesnor)

将tensor投射为参数给定tensor类型并返回。如果tensor已经是正确的类型则不会执行操作。等效于：

self.type(tensor.type())

参数： - tensor (Tensor):有所需要类型的tensor

unfold(dim, size, step) → Tensor

返回一个tensor，其中含有在dim维tianchong度上所有大小为size的分片。两个分片之间的步长为step。如果_sizedim_是dim维度的原始大
小，则在返回tensor中的维度dim大小是_(sizedim-size)/step+1_ 维度大小的附加维度将附加在返回的tensor中。

参数： - dim (int)-需要展开的维度 - size (int)-每一个分片需要展开的大小 - step (int)-相邻分片之间的步长

例：

>>> x = torch.arange(1, 8)
>>> x

 1
 2
 3
 4
 5
 6
 7
[torch.FloatTensor of size 7]

>>> x.unfold(0, 2, 1)

 1  2
 2  3
 3  4
 4  5
 5  6
 6  7
[torch.FloatTensor of size 6x2]

>>> x.unfold(0, 2, 2)

 1  2
 3  4
 5  6
[torch.FloatTensor of size 3x2]

uniform_(from=0, to=1) → Tensor

将tensor用从均匀分布中抽样得到的值填充。

unsqueeze(dim)

请查看torch.unsqueeze()

unsqueeze_(dim) → Tensor

unsqueeze()的in-place运算形式

var()

请查看torch.var()

view(*args) → Tensor

返回一个有相同数据但大小不同的tensor。返回的tensor必须有与原tensor相同的数据和相同数目的元素，但可以有不同的大小。一个
tensor必须是连续的contiguous()才能被查看。

例：

>>> x = torch.randn(4, 4)
>>> x.size()
torch.Size([4, 4])
>>> y = x.view(16)
>>> y.size()
torch.Size([16])
>>> z = x.view(-1, 8)  # the size -1 is inferred from other dimensions
>>> z.size()
torch.Size([2, 8])

view_as(tensor)

返回被视作与给定的tensor相同大小的原tensor。等效于：

self.view(tensor.size())

zero_()

用0填充该tensor。

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
