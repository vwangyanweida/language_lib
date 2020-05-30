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
      □ torch.optim
      □ torch.nn.init
      □ torch.multiprocessing
      □ torch.legacy
      □ torch.cuda
      □ torch.utils.ffi
      □ torch.utils.data
      □ torch.utils.model_zoo
          ☆ torch.utils.model_zoo
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
  • torch.utils.model_zoo
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

torch.utils.model_zoo

torch.utils.model_zoo.load_url(url, model_dir=None)

在给定URL上加载Torch序列化对象。

如果对象已经存在于 model_dir 中，则将被反序列化并返回。URL的文件名部分应遵循命名约定filename-<sha256>.ext，其中<sha256>是
文件内容的SHA256哈希的前八位或更多位数字。哈希用于确保唯一的名称并验证文件的内容。

model_dir 的默认值为$TORCH_HOME/models，其中$TORCH_HOME默认为~/.torch。可以使用$TORCH_MODEL_ZOO环境变量来覆盖默认目录。

参数：

  • url (string) - 要下载对象的URL
  • model_dir (string, optional) - 保存对象的目录

例子：

>>> state_dict = torch.utils.model_zoo.load_url('https://s3.amazonaws.com/pytorch/models/resnet18-5c106cde.pth')

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
