PyTorch中文文档
[                    ]
  • 主页
  • 说明
      □ 自动求导机制
      □ CUDA语义
      □ 扩展PyTorch
          ☆ 扩展PyTorch
              ○ 扩展 torch.autograd
              ○ 扩展 torch.nn
              ○ 编写自定义C扩展
      □ 多进程最佳实践
      □ 序列化语义
  • PACKAGE参考
      □ torch
      □ torch.Tensor
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
  • 说明 »
  • 扩展PyTorch
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

扩展PyTorch

本篇文章中包含如何扩展 torch.nn, torch.autograd和使用我们的 C 库编写自定义的C扩展。

扩展 torch.autograd

如果你想要添加一个新的 Operation 到autograd的话，你的Operation需要继承 class Function。autograd使用Function计算结果和梯度
，同时编码 operation的历史。每个新的 operation(function) 都需要实现三个方法：

  • __init__ (optional) - 如果你的operation包含非Variable参数，那么就将其作为__init__的参数传入到operation中。例如：
    AddConstant Function加一个常数，Transpose Function需要指定哪两个维度需要交换。如果你的operation不需要额外的参数，你可
    以忽略__init__。

  • forward() - 在里面写执行此operation的代码。可以有任意数量的参数。如果你对某些参数指定了默认值，则这些参数是可传可不传
    的。记住：forward()的参数只能是Variable。函数的返回值既可以是 Variable也可以是Variables的tuple。同时，请参考 Function
    [function]的 doc，查阅有哪些方法是只能在forward中调用的。

  • backward() - 梯度计算公式。参数的个数和forward返回值的个数一样，每个参数代表传回到此operation的梯度. backward()的返回
    值的个数应该和此operation输入的个数一样，每个返回值对应了输入值的梯度。如果operation的输入不需要梯度，或者不可导，你可
    以返回None。如果forward()存在可选参数，你可以返回比输入更多的梯度，只是返回的是None。

下面是 Linear 的实现代码：

# Inherit from Function
class Linear(Function):

    # bias is an optional argument
    def forward(self, input, weight, bias=None):
        self.save_for_backward(input, weight, bias)
        output = input.mm(weight.t())
        if bias is not None:
            output += bias.unsqueeze(0).expand_as(output)
        return output

    # This function has only a single output, so it gets only one gradient
    def backward(self, grad_output):
        # This is a pattern that is very convenient - at the top of backward
        # unpack saved_tensors and initialize all gradients w.r.t. inputs to
        # None. Thanks to the fact that additional trailing Nones are
        # ignored, the return statement is simple even when the function has
        # optional inputs.
        input, weight, bias = self.saved_tensors
        grad_input = grad_weight = grad_bias = None

        # These needs_input_grad checks are optional and there only to
        # improve efficiency. If you want to make your code simpler, you can
        # skip them. Returning gradients for inputs that don't require it is
        # not an error.
        if self.needs_input_grad[0]:
            grad_input = grad_output.mm(weight)
        if self.needs_input_grad[1]:
            grad_weight = grad_output.t().mm(input)
        if bias is not None and self.needs_input_grad[2]:
            grad_bias = grad_output.sum(0).squeeze(0)

        return grad_input, grad_weight, grad_bias

现在，为了可以更简单的使用自定义的operation，我们建议将其用一个简单的 helper function 包装起来。 functions:

def linear(input, weight, bias=None):
    # First braces create a Function object. Any arguments given here
    # will be passed to __init__. Second braces will invoke the __call__
    # operator, that will then use forward() to compute the result and
    # return it.
    return Linear()(input, weight, bias)

你可能想知道你刚刚实现的 backward方法是否正确的计算了梯度。你可以使用小的有限的差分进行数值估计。

from torch.autograd import gradcheck

# gradchek takes a tuple of tensor as input, check if your gradient
# evaluated with these tensors are close enough to numerical
# approximations and returns True if they all verify this condition.
input = (Variable(torch.randn(20,20).double(), requires_grad=True),)
test = gradcheck.gradcheck(Linear(), input, eps=1e-6, atol=1e-4)
print(test)

扩展 torch.nn

nn 包含两种接口 - modules和他们的functional版本。通过这两个接口，你都可以扩展nn。但是我们建议，在扩展layer的时候，使用
modules，因为modules保存着参数和buffer。如果不需要参数的话，那么建议使用functional(激活函数，pooling，这些都不需要参数)。

增加一个operation的 functional版本已经在上面一节介绍完毕。

增加一个模块(module)。由于nn重度使用autograd。所以，添加一个新module需要实现一个用来执行计算和计算梯度的Function。从现在开
始，假定我们想要实现一个Linear module，记得之前我们已经实现了一个Linear Funciton。只需要很少的代码就可以完成这个工作。现在
，我们需要实现两个方法：

  • __init__ (optional) - 输入参数，例如kernel sizes, numbers of features, 等等。同时初始化 parameters和buffers。

  • forward() - 实例化一个执行operation的Function，使用它执行operation。和functional wrapper(上面实现的那个简单的wrapper)
    十分类似。

Linear module实现代码:

class Linear(nn.Module):
    def __init__(self, input_features, output_features, bias=True):
        self.input_features = input_features
        self.output_features = output_features

        # nn.Parameter is a special kind of Variable, that will get
        # automatically registered as Module's parameter once it's assigned
        # as an attribute. Parameters and buffers need to be registered, or
        # they won't appear in .parameters() (doesn't apply to buffers), and
        # won't be converted when e.g. .cuda() is called. You can use
        # .register_buffer() to register buffers.
        # nn.Parameters can never be volatile and, different than Variables,
        # they require gradients by default.
        self.weight = nn.Parameter(torch.Tensor(input_features, output_features))
        if bias:
            self.bias = nn.Parameter(torch.Tensor(output_features))
        else:
            # You should always register all possible parameters, but the
            # optional ones can be None if you want.
            self.register_parameter('bias', None)

        # Not a very smart way to initialize weights
        self.weight.data.uniform_(-0.1, 0.1)
        if bias is not None:
            self.bias.data.uniform_(-0.1, 0.1)

    def forward(self, input):
        # See the autograd section for explanation of what happens here.
        return Linear()(input, self.weight, self.bias)
        #注意这个Linear是之前实现过的Linear

编写自定义C扩展

Coming soon. For now you can find an example at GitHub.

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
