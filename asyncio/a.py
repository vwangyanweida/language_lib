import dis


class A:
    def __await__(self):
        print("before")
        yield self
        print("after")
        return 234


async def b():
    d = await A()
    print("d is:", d)


e = b()
ff = e.send(None)
print(ff)
try:
    e.send(None)
except Exception as e:
    print("e is:", e)

