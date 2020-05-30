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
          ☆ pytorch torchvision transform
              ○ 对PIL.Image进行变换
              ○ 对Tensor进行变换
              ○ Conversion Transforms
              ○ 通用变换
      □ torchvision.utils
  • 致谢

  PyTorch中文文档

  • Docs »
  • TORCHVISION参考 »
  • torchvision.transforms
  • 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

pytorch torchvision transform

对PIL.Image进行变换

class torchvision.transforms.Compose(transforms)

将多个transform组合起来使用。

transforms：由transform构成的列表. 例子：

transforms.Compose([
     transforms.CenterCrop(10),
     transforms.ToTensor(),
 ])
 ```


### class torchvision.transforms.Scale(size, interpolation=2)

将输入的`PIL.Image`重新改变大小成给定的`size`，`size`是最小边的边长。举个例子，如果原图的`height>width`,那么改变大小后的图片大小是`(size*height/width, size)`。
**用例:**
```python
from torchvision import transforms
from PIL import Image
crop = transforms.Scale(12)
img = Image.open('test.jpg')

print(type(img))
print(img.size)

croped_img=crop(img)
print(type(croped_img))
print(croped_img.size)

<class 'PIL.PngImagePlugin.PngImageFile'>
(10, 10)
<class 'PIL.Image.Image'>
(12, 12)

class torchvision.transforms.CenterCrop(size)

将给定的PIL.Image进行中心切割，得到给定的size，size可以是tuple，(target_height, target_width)。size也可以是一个Integer，在
这种情况下，切出来的图片的形状是正方形。

class torchvision.transforms.RandomCrop(size, padding=0)

切割中心点的位置随机选取。size可以是tuple也可以是Integer。

class torchvision.transforms.RandomHorizontalFlip

随机水平翻转给定的PIL.Image,概率为0.5。即：一半的概率翻转，一半的概率不翻转。

class torchvision.transforms.RandomSizedCrop(size, interpolation=2)

先将给定的PIL.Image随机切，然后再resize成给定的size大小。

class torchvision.transforms.Pad(padding, fill=0)

将给定的PIL.Image的所有边用给定的pad value填充。 padding：要填充多少像素 fill：用什么值填充例子：

from torchvision import transforms
from PIL import Image
padding_img = transforms.Pad(padding=10, fill=0)
img = Image.open('test.jpg')

print(type(img))
print(img.size)

padded_img=padding(img)
print(type(padded_img))
print(padded_img.size)

<class 'PIL.PngImagePlugin.PngImageFile'>
(10, 10)
<class 'PIL.Image.Image'>
(30, 30) #由于上下左右都要填充10个像素，所以填充后的size是(30,30)

对Tensor进行变换

class torchvision.transforms.Normalize(mean, std)

给定均值：(R,G,B) 方差：（R，G，B），将会把Tensor正则化。即：Normalized_image=(image-mean)/std。

Conversion Transforms

class torchvision.transforms.ToTensor

把一个取值范围是[0,255]的PIL.Image或者shape为(H,W,C)的numpy.ndarray，转换成形状为[C,H,W]，取值范围是[0,1.0]的
torch.FloadTensor

data = np.random.randint(0, 255, size=300)
img = data.reshape(10,10,3)
print(img.shape)
img_tensor = transforms.ToTensor()(img) # 转换成tensor
print(img_tensor)

class torchvision.transforms.ToPILImage

将shape为(C,H,W)的Tensor或shape为(H,W,C)的numpy.ndarray转换成PIL.Image，值不变。

通用变换

class torchvision.transforms.Lambda(lambd)

使用lambd作为转换器。

Next Previous
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Built with MkDocs using a theme provided by Read the Docs.
Read the Docs
