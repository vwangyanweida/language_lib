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

[1190000010407265    ]
[331] FIZLIN

  • 511

asyncio Protocol

python3.x
更新于 2017-07-29  约 10 分钟

asyncio 模块的Protocol使用

myblog

source code

[source code]

Protocol

 1. 提供了几个'BaseProtocol', 'Protocol', 'DatagramProtocol''SubprocessProtocol' 实例

 2. 基本的方法：

    connection_made()
    data_received() # 这个是类似于一个循环，循环调用者个方法来读取内容
    eof_received()
    connection_lost()

 3. 启动顺序依次是

    State machine of calls:

     start -> CM [-> DR*] [-> ER?] -> CL -> end

    * CM: connection_made()
    * DR: data_received()
    * ER: eof_received()
    * CL: connection_lost()

create_server

 1. create_server

    def create_server(self, protocol_factory, host=None, port=None, *,
             family=socket.AF_UNSPEC, flags=socket.AI_PASSIVE,
             sock=None, backlog=100, ssl=None, reuse_address=None,
             reuse_port=None):
     # 用来建立一个TCP 类型的Server,提供了默认的一些参数
     关于详细的内容可以查看asyncio.events 模块
     protocol_factory 我们使用asyncio.Protocol 来做工厂函数

connect_server/client

 1. create_connection()

      def create_connection(self, protocol_factory, host=None, port=None, *,
                     ssl=None, family=0, proto=0, flags=0, sock=None,
                     local_addr=None, server_hostname=None):
    raise NotImplementedError

loop

 1. asyncio事件循环

    loop = asyncio.get_event_loop()

Server.py

class EchoServerClientProtocol(asyncio.Protocol):
    def connection_made(self, transport):
        peername = transport.get_extra_info('peername')
        print('Connection from {}'.format(peername))
        self.transport = transport
        self.word_title = '我们一起来背诵 <<荷叶杯·记得那年花下>>'
        self.word_list = ['记得那年花下', '深夜', '初识谢娘时', '水堂西面画帘垂', '携手暗相期',
                          '惆怅晓莺残月', '相别', '从此隔音尘', '如今俱是异乡人', '相见更无因']
        self.index = 0

    def data_received(self, data):
        message = data.decode()
        print('Data received: {!r}'.format(message))
        try:
            message = self.find_next(data=data.decode())
            print('Send: {!r}'.format(message))
            self.transport.write(message.encode())
        except (IndexError,ValueError):
            message = input('input the message:')
            print('Send: {!r}'.format(message))
            self.transport.write(message.encode())

    def find_next(self, data):
        index = self.word_list.index(data)
        return self.word_list[index + 1]


loop = asyncio.get_event_loop()
# Each client connection will create a new protocol instance
coro = loop.create_server(EchoServerClientProtocol, '127.0.0.1', 8888)
server = loop.run_until_complete(coro)

# Serve requests until Ctrl+C is pressed
print('Serving on {}'.format(server.sockets[0].getsockname()))
try:
    loop.run_forever()
except KeyboardInterrupt:
    pass

# Close the server
server.close()
loop.run_until_complete(server.wait_closed())
loop.close()

client.py

class EchoClientProtocol(asyncio.Protocol):
    def __init__(self, loop):
        self.loop = loop
        self.transport = None
        self.word_title = '我们一起来背诵 <<荷叶杯·记得那年花下>>'
        self.word_list = ['记得那年花下', '深夜', '初识谢娘时', '水堂西面画帘垂', '携手暗相期',
                          '惆怅晓莺残月', '相别', '从此隔音尘', '如今俱是异乡人', '相见更无因']
        self.index = 0
        print(self.word_title)

    def connection_made(self, transport):
        self.transport = transport
        message = self.word_list[self.index]
        print('message: ',message)
        self.transport.write(message.encode())

    def data_received(self, data):
        print('Data received: {!r}'.format(data.decode()))
        try:
           message = self.find_next(data=data.decode())
           self.transport.write(message.encode())
           print('Data sent: {!r}'.format(message))
        except (IndexError,ValueError):
            message = input('input message:')
            self.transport.write(message.encode())
            print('Data sent: {!r}'.format(message))



    def connection_lost(self, exc):
        print('The server closed the connection')
        print('Stop the event loop')
        self.loop.stop()

    def find_next(self, data):
        index = self.word_list.index(data)
        return self.word_list[index + 1]


loop = asyncio.get_event_loop()
coro = loop.create_connection(lambda: EchoClientProtocol(loop),
                              '127.0.0.1', 8888)
loop.run_until_complete(coro)
loop.run_forever()
loop.close()

代码运行结果

阅读 2.5k更新于 2017-07-29
本作品系原创，采用《署名-非商业性使用-禁止演绎 4.0 国际》许可协议
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[33146929]

FIZLIN

  • 511

关注作者

推荐阅读

python学习

用户专栏

Python新手学习分享

3 人关注
23 篇文章
关注专栏专栏主页
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

