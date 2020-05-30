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
  • TORCHVISION参考
      □ torchvision
      □ torchvision.datasets
      □ torchvision.models
      □ torchvision.transforms
      □ torchvision.utils
          ☆ torchvision.utils
              ○ torchvision.utils.make_grid(tensor, nrow=8, padding=2, normalize=False, range=None, scale_each=False)
              ○ torchvision.utils.save_image(tensor, filename, nrow=8, padding=2, normalize=False, range=None, scale_each=
                False)
  • 致谢

  PyTorch中文文档

  • Docs »
  • TORCHVISION参考 »
  • torchvision.utils
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

torchvision.utils

torchvision.utils.make_grid(tensor, nrow=8, padding=2, normalize=False, range=None, scale_each=False)

猜测，用来做雪碧图的（sprite image）。

给定 4D mini-batch Tensor，形状为 (B x C x H x W),或者一个a list of image，做成一个size为(B / nrow, nrow)的雪碧图。

  • normalize=True ，会将图片的像素值归一化处理

  • 如果 range=(min, max)， min和max是数字，那么min，max用来规范化image

  • scale_each=True ，每个图片独立规范化，而不是根据所有图片的像素最大最小值来规范化

Example usage is given in this notebook

torchvision.utils.save_image(tensor, filename, nrow=8, padding=2, normalize=False, range=None, scale_each=False)

将给定的Tensor保存成image文件。如果给定的是mini-batch tensor，那就用make-grid做成雪碧图，再保存。

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
