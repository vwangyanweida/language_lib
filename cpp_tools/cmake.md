### include_directories

将包含目录添加到构建中。

```
include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])
```

### add_subdirectory
在构建中添加一个子目录

```
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```

1. source_dir指定源CMakeLists.txt和代码文件所在的目录。如果是相对路径，则将相对于当前目录（典型用法）进行评估，但也可能是绝对路径。
2. 在binary_dir指定了该目录中放置输出文件。如果是相对路径，则将相对于当前输出目录进行评估，但也可能是绝对路径。
3. If binary_dir is not specified, the value of source_dir, before expanding any relative path, will be used (the typical usage)

### add_library
使用指定的源文件将库添加到项目中
1. 将指定的源文件编译成为静态库。


### target_link_libraries
将对象文件链接到库生成可执行文件

```
target_link_libraries (Tutorial MathFunctions)
```
