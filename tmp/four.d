[touch-icon]
SegmentFault 注册登录

  • 首页
  • 问答
  • 专栏
  • 资讯
  • 课程
  • 活动
  • 发现
    圈子标签酷工作排行榜徽章笔记
    开发手册广告投放

[                    ]
  • 立即登录
  • 免费注册

[1190000014117039    ]
[use] Hanwencheng

  • 159

Python中的并发处理之使用asyncio包

[2521771040] python
更新于 2018-04-08  约 9 分钟

    导语：本文章记录了本人在学习Python基础之控制流程篇的重点知识及个人心得，打算入门Python的朋友们可以来一起学习并交流。

本文重点：

    1、了解asyncio包的功能和使用方法；
    2、了解如何避免阻塞型调用；
    3、学会使用协程避免回调地狱。

一、使用asyncio包做并发编程

1、并发与并行

并发：一次处理多件事。
并行：一次做多件事。
并发用于制定方案，用来解决可能（但未必）并行的问题。并发更好。

2、asyncio概述

了解asyncio的4个特点：

  • asyncio包使用事件循环驱动的协程实现并发。
  • 适合asyncio API的协程在定义体中必须使用yield from，而不能使用yield。
  • 使用asyncio处理的协程，需在定义体上使用@asyncio.coroutine装饰。装饰的功能在于凸显协程，同时当协程不产出值，协程会被垃
    圾回收。
  • Python3.4起，asyncio包只直接支持TCP和UDP协议。如果想使用asyncio实现HTTP客户端和服务器时，常使用aiohttp包。

在协程中使用yield from需要注意两点：

  • 使用yield froml链接的多个协程最终必须由不是协程的调用方驱动，调用方显式或隐式在最外层委派生成器上调用next()函数或
    .send()方法。
  • 链条中最内层的子生成器必须是简单的生成器（只使用yield）或可迭代的对象。

但在asyncio包的API中使用yield from还需注意两个细节：

  • asyncio包中编写的协程链条始终通过把最外层委派生成器传给asyncio包API中的某个函数驱动，例如loop.run_until_complete()。即
    不通过调用next()函数或 .send()方法驱动协程。
  • 编写的协程链条最终通过yield from把职责委托给asyncio包中的某个协程函数或协程方法。即最内层的子生成器是库中真正执行I/O操
    作的函数，而不是我们自己编写的函数。

实例——通过asyncio包和协程以动画形式显示文本式旋转指针：

import asyncio
import itertools
import sys

@asyncio.coroutine  # 交给 asyncio 处理的协程要使用 @asyncio.coroutine 装饰
def spin(msg):
    for char in itertools.cycle('|/-\\'):
        status = char + ' ' + msg
        print(status)
        try:
            yield from asyncio.sleep(.1)  # 使用 yield from asyncio.sleep(.1) 代替 time.sleep(.1)，这样的休眠不会阻塞事件循环。
        except asyncio.CancelledError:  # 如果 spin 函数苏醒后抛出 asyncio.CancelledError 异常，其原因是发出了取消请求，因此退出循环。
            break

@asyncio.coroutine
def slow_function():  # slow_function 函数是协程，在用休眠假装进行 I/O 操作时，使用 yield from 继续执行事件循环。
    # 假装等待I/O一段时间
    yield from asyncio.sleep(3)  # yield from asyncio.sleep(3) 表达式把控制权交给主循环，在休眠结束后恢复这个协程。
    return 42

@asyncio.coroutine
def supervisor():  # supervisor 函数也是协程
    spinner = asyncio.async(spin('thinking!'))  # asyncio.async(...) 函数排定 spin 协程的运行时间，使用一个 Task 对象包装spin 协程，并立即返回。
    print('spinner object:', spinner)
    result = yield from slow_function()  # 驱动 slow_function() 函数。结束后，获取返回值。
# 同时，事件循环继续运行，因为slow_function 函数最后使用 yield from asyncio.sleep(3) 表达式把控制权交回给了主循环。
    spinner.cancel()  # Task 对象可以取消；取消后会在协程当前暂停的 yield 处抛出 asyncio.CancelledError 异常。协程可以捕获这个异常，也可以延迟取消，甚至拒绝取消。
    return result

if __name__ == '__main__':
    loop = asyncio.get_event_loop()  # 获取事件循环的引用
    result = loop.run_until_complete(supervisor())  # 驱动 supervisor 协程，让它运行完毕；这个协程的返回值是这次调用的返回值。
    loop.close()
    print('Answer:', result)

3、线程与协程对比

线程：调度程序在任何时候都能中断线程。必须记住保留锁。去保护程序中的重要部分，防止多步操作在执行的过程中中断，防止数据处于
无效状态。
协程：默认会做好全方位保护，以防止中断。对协程来说无需保留锁，在多个线程之间同步操作，协程自身就会同步，因为在任意时刻只有
一个协程运行。

4、从期物、任务和协程中产出

在asyncio包中，期物和协程关系紧密，因为可以使用yield from从asyncio.Future对象中产出结果。这意味着，如果foo是协程函数，抑或
是返回Future或Task实例的普通函数，那么可以这样写：res=yield from foo()。这是asyncio包中很多地方可以互换协程与期物的原因之
一。

二、避免阻塞型调用

1、有两种方法能避免阻塞型调用中止整个应用程序的进程：

  • 在单独的线程中运行各个阻塞型操作。
  • 把每个阻塞型操作转换成非阻塞的异步调用。

使用多线程处理大量连接时将耗费过多的内存，故此通常使用回调来实现异步调用。

2、使用Executor对象防止阻塞事件循环：

  • 使用loop.run_in_executor把阻塞的作业（例如保存文件）委托给线程池做。

@asyncio.coroutine
def download_one(cc, base_url, semaphore, verbose):
    try:
        with (yield from semaphore):
            image = yield from get_flag(base_url, cc)
    except web.HTTPNotFound:
        status = HTTPStatus.not_found
        msg = 'not found'
    except Exception as exc:
        raise FetchError(cc) from exc
    else:
        loop = asyncio.get_event_loop()  # 获取事件循环对象的引用
        loop.run_in_executor(None,  # None 使用默认的 TrreadPoolExecutor 实例
                save_flag, image, cc.lower() + '.gif')  # 传入可调用对象
        status = HTTPStatus.ok
        msg = 'OK'

    if verbose and msg:
        print(cc, msg)

    return Result(status, cc)

asyncio 的事件循环背后维护一个 ThreadPoolExecutor 对象，我们可以调用 run_in_executor 方法，把可调用的对象发给它执行。

三、从回调到期物和协程

回调地狱：如果一个操作需要依赖之前操作的结果，那就得嵌套回调。
Python 中的回调地狱：

def stage1(response1):
    request2 = step1(response1)
    api_call2(request2, stage2)

def stage2(response2):
    request3 = step2(response2)
    api_call3(request3, stage3)

def stage3(response3):
    step3(response3)

api_call1(request1, step1)

使用协程和 yield from 结构做异步编程，无需用回调：

@asyncio.coroutine
def three_stages(request1):
    response1 = yield from api_call1()
    request2 = step1(response1)
    response2 = yield from api_call2(request2)
    request3 = step2(response2)
    response3 = yield from api_call3(request3)
    step3(response3)

loop.create_task(three_stages(request1))
# 协程不能直接调用，必须用事件循环显示指定协程的执行时间，或者在其他排定了执行时间的协程中使用 yield from 表达式把它激活

四、使用asyncio包编写服务器

  • 使用asyncio包能实现TCP和HTTP服务器
  • Web服务将成为asyncio包的重要使用场景。

阅读 1.8k更新于 2018-04-08
本作品系原创，采用《署名-非商业性使用-禁止演绎 4.0 国际》许可协议
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[user-64]

Hanwencheng

  • 159

关注作者

推荐阅读

Planets
广告位促销，月曝光三千万，10 元/天

目录

产品
    热门问答
    热门专栏
    热门课程
    最新活动
    技术圈
    酷工作
    移动客户端

课程
    Java 开发课程
    PHP 开发课程
    Python 开发课程
    前端开发课程
    移动开发课程

资源
    每周精选
    用户排行榜
    徽章
    帮助中心
    声望与权限
    社区服务中心

合作
    关于我们
    广告投放
    职位发布
    讲师招募
    联系我们
    合作伙伴

关注
    产品技术日志
    社区运营日志
    市场运营日志
    团队日志
    社区访谈

条款
    服务条款
    隐私政策
    [appQrco]
    下载 App

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Copyright © 2011-2020 SegmentFault. 当前呈现版本 19.02.27

浙ICP备 15005796号-2 浙公网安备 33010602002000号杭州堆栈科技有限公司版权所有

