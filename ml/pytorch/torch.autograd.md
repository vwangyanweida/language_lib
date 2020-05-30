PyTorch中文文档
[                    ]
  • 主页
  • 说明
      □ 自动求导机制
      □ CUDA语义
      □ 扩展PyTorch
      □ 多进程最佳实践
      □ 序列化语义
  • PACKAGE参考
      □ torch
      □ torch.Tensor
      □ torch.Storage
      □ torch.nn
      □ torch.nn.functional
      □ torch.autograd
          ☆ Automatic differentiation package - torch.autograd
              ○ torch.autograd.backward(variables, grad_variables, retain_variables=False)
              ○ Variable
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
  • torch.autograd
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Automatic differentiation package - torch.autograd

torch.autograd提供了类和函数用来对任意标量函数进行求导。要想使用自动求导，只需要对已有的代码进行微小的改变。只需要将所有的
tensor包含进Variable对象中即可。

torch.autograd.backward(variables, grad_variables, retain_variables=False)

Computes the sum of gradients of given variables w.r.t. graph leaves. 给定图的叶子节点variables, 计算图中变量的梯度和。计
算图可以通过链式法则求导。如果variables中的任何一个variable是非标量(non-scalar)的，且requires_grad=True。那么此函数需要指
定grad_variables，它的长度应该和variables的长度匹配，里面保存了相关variable的梯度(对于不需要gradient tensor的variable，
None是可取的)。

此函数累积leaf variables计算的梯度。你可能需要在调用此函数之前将leaf variable的梯度置零。

参数说明:

  • variables (variable 列表) – 被求微分的叶子节点，即 ys 。

  • grad_variables (Tensor 列表) – 对应variable的梯度。仅当variable不是标量且需要求梯度的时候使用。

  • retain_variables (bool) – True,计算梯度时所需要的buffer在计算完梯度后不会被释放。如果想对一个子图多次求微分的话，需要
    设置为True。

Variable

API 兼容性

Variable API 几乎和 Tensor API一致 (除了一些in-place方法，这些in-place方法会修改 required_grad=True的 input 的值)。多数情
况下，将Tensor替换为Variable，代码一样会正常的工作。由于这个原因，我们不会列出Variable的所有方法，你可以通过torch.Tensor的
文档来获取相关知识。

In-place operations on Variables

在autograd中支持in-place operations是非常困难的。同时在很多情况下，我们阻止使用in-place operations。Autograd的贪婪的释放
buffer和复用使得它效率非常高。只有在非常少的情况下，使用in-place operations可以降低内存的使用。除非你面临很大的内存压力，
否则不要使用in-place operations。

In-place 正确性检查

所有的Variable都会记录用在他们身上的 in-place operations。如果pytorch检测到variable在一个Function中已经被保存用来backward
，但是之后它又被in-place operations修改。当这种情况发生时，在backward的时候，pytorch就会报错。这种机制保证了，如果你用了
in-place operations，但是在backward过程中没有报错，那么梯度的计算就是正确的。

class torch.autograd.Variable [source]

包装一个Tensor,并记录用在它身上的operations。

Variable是Tensor对象的一个thin wrapper，它同时保存着Variable的梯度和创建这个Variable的Function的引用。这个引用可以用来追溯
创建这个Variable的整条链。如果Variable是被用户所创建的，那么它的creator是None，我们称这种对象为 leaf Variables。

由于autograd只支持标量值的反向求导(即：y是标量)，梯度的大小总是和数据的大小匹配。同时，仅仅给leaf variables分配梯度，其他
Variable的梯度总是为0.

变量：

  • data – 包含的Tensor

  • grad – 保存着Variable的梯度。这个属性是懒分配的，且不能被重新分配。

  • requires_grad – 布尔值，指示这个Variable是否是被一个包含Variable的子图创建的。更多细节请看Excluding subgraphs from
    backward。只能改变leaf variable的这个标签。

  • volatile – 布尔值，指示这个Variable是否被用于推断模式(即，不保存历史信息)。更多细节请看Excluding subgraphs from
    backward。只能改变leaf variable的这个标签。

  • creator – 创建这个Variable的Function，对于leaf variable，这个属性为None。只读属性。

属性:

  • data (any tensor class) – 被包含的Tensor

  • requires_grad (bool) – requires_grad标记. 只能通过keyword传入.

  • volatile (bool) – volatile标记. 只能通过keyword传入.

backward(gradient=None, retain_variables=False)[source]

当前Variable对leaf variable求偏导。

计算图可以通过链式法则求导。如果Variable是非标量(non-scalar)的，且requires_grad=True。那么此函数需要指定gradient，它的形状
应该和Variable的长度匹配，里面保存了Variable的梯度。

此函数累积leaf variable的梯度。你可能需要在调用此函数之前将Variable的梯度置零。

参数:

  • gradient (Tensor) – 其他函数对于此Variable的导数。仅当Variable不是标量的时候使用，类型和位形状应该和self.data一致。
  • retain_variables (bool) – True, 计算梯度所必要的buffer在经历过一次backward过程后不会被释放。如果你想多次计算某个子图的
    梯度的时候，设置为True。在某些情况下，使用autograd.backward()效率更高。

detach()[source]

Returns a new Variable, detached from the current graph. 返回一个新的Variable，从当前图中分离下来的。

返回的Variable requires_grad=False，如果输入 volatile=True，那么返回的Variable volatile=True。

注意：

返回的Variable和原始的Variable公用同一个data tensor。in-place修改会在两个Variable上同时体现(因为它们共享data tensor)，可能
会导致错误。

detach_()[source]

将一个Variable从创建它的图中分离，并把它设置成leaf variable。

register_hook(hook)[source]

注册一个backward钩子。

每次gradients被计算的时候，这个hook都被调用。hook应该拥有以下签名：

hook(grad) -> Variable or None

hook不应该修改它的输入，但是它可以选择性的返回一个替代当前梯度的新梯度。

这个函数返回一个句柄(handle)。它有一个方法 handle.remove()，可以用这个方法将hook从module移除。

Example

v = Variable(torch.Tensor([0, 0, 0]), requires_grad=True)
h = v.register_hook(lambda grad: grad * 2)  # double the gradient
v.backward(torch.Tensor([1, 1, 1]))
#先计算原始梯度，再进hook，获得一个新梯度。
print(v.grad.data)

 2
 2
 2
[torch.FloatTensor of size 3]
>>> h.remove()  # removes the hook

def w_hook(grad):
    print("hello")
    return None
w1 = Variable(torch.FloatTensor([1, 1, 1]),requires_grad=True)

w1.register_hook(w_hook) # 如果hook返回的是None的话，那么梯度还是原来计算的梯度。

w1.backward(gradient=torch.FloatTensor([1, 1, 1]))
print(w1.grad)

hello
Variable containing:
 1
 1
 1
[torch.FloatTensor of size 3]

reinforce(reward)[source]

注册一个奖励，这个奖励是由一个随机过程得到的。

微分一个随机节点需要提供一个奖励值。如果你的计算图中包含随机 operations，你需要在他们的输出上调用这个函数。否则的话，会报
错。

参数:

  • reward (Tensor) – 每个元素的reward。必须和Varaible形状相同，并在同一个设备上。

class torch.autograd.Function[source]

Records operation history and defines formulas for differentiating ops. 记录operation的历史，定义微分公式。每个执行在
Varaibles上的operation都会创建一个Function对象，这个Function对象执行计算工作，同时记录下来。这个历史以有向无环图的形式保存
下来，有向图的节点为functions，有向图的边代表数据依赖关系(input<-output)。之后，当backward被调用的时候，计算图以拓扑顺序处
理，通过调用每个Function对象的backward()，同时将返回的梯度传递给下一个Function。

通常情况下，用户能和Functions交互的唯一方法就是创建Function的子类，定义新的operation。这是扩展torch.autograd的推荐方法。

由于Function逻辑在很多脚本上都是热点，所有我们把几乎所有的Function都使用C实现，通过这种策略保证框架的开销是最小的。

每个Function只被使用一次(在forward过程中)。

变量:

  • saved_tensors – 调用forward()时需要被保存的 Tensors的 tuple。

  • needs_input_grad – 长度为输入数量的布尔值组成的 tuple。指示给定的input是否需要梯度。这个被用来优化用于backward过程中的
    buffer，忽略backward中的梯度计算。

  • num_inputs – forward 的输入参数数量。

  • num_outputs – forward返回的Tensor数量。

  • requires_grad – 布尔值。指示backward以后会不会被调用。

  • previous_functions – 长度为 num_inputs的 Tuple of (int, Function) pairs。Tuple中的每单元保存着创建 input的Function的引
    用，和索引。

backward(* grad_output)[source]

定义了operation的微分公式。

所有的Function子类都应该重写这个方法。

所有的参数都是Tensor。他必须接收和forward的输出相同个数的参数。而且它需要返回和forward的输入参数相同个数的Tensor。即：
backward的输入参数是此operation的输出的值的梯度。backward的返回值是此operation输入值的梯度。

forward(* input)[source]

执行operation。

所有的Function子类都需要重写这个方法。

可以接收和返回任意个数 tensors

mark_dirty(* args)[source]

将输入的 tensors 标记为被in-place operation修改过。

这个方法应当至多调用一次，仅仅用在 forward方法里，而且mark_dirty的实参只能是forward的实参。

每个在forward方法中被in-place operations修改的tensor都应该传递给这个方法。这样，可以保证检查的正确性。这个方法在tensor修改
前后调用都可以。

mark_non_differentiable(* args)[source]

将输出标记为不可微。

这个方法至多只能被调用一次，只能在forward中调用，而且实参只能是forward的返回值。

这个方法会将输出标记成不可微，会增加backward过程中的效率。在backward中，你依旧需要接收forward输出值的梯度，但是这些梯度一
直是None。

This is used e.g. for indices returned from a max Function.

mark_shared_storage(* pairs)[source]

将给定的tensors pairs标记为共享存储空间。

这个方法至多只能被调用一次，只能在forward中调用，而且所有的实参必须是(input, output)对。

如果一些 inputs 和 outputs 是共享存储空间的，所有的这样的 (input, output)对都应该传给这个函数，保证 in-place operations 检
查的正确性。唯一的特例就是，当 output和input是同一个tensor(in-place operations的输入和输出)。这种情况下，就没必要指定它们
之间的依赖关系，因为这个很容易就能推断出来。

这个函数在很多时候都用不到。主要是用在索引和转置这类的 op 中。

save_for_backward(* tensors)[source]

将传入的 tensor 保存起来，留着backward的时候用。

这个方法至多只能被调用一次，只能在forward中调用。

之后，被保存的tensors可以通过 saved_tensors属性获取。在返回这些tensors之前，pytorch做了一些检查，保证这些tensor没有被
in-place operations修改过。

实参可以是None。

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
