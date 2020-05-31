
<!-- vim-markdown-toc GFM -->

* [key]
* [string]
	* [set]
	* [get]
	* [incr/decr]
	* [str]
* []

<!-- vim-markdown-toc -->
## key
1. type
2. expire
	- expire/expireat
	- pexpire/pexpireat
3. dump
4. rename/renamenx
5. persist
6. move
7. randomkey
8. dump
9. ttl/pttl
10. del
11. exists
12. keys pattern

## string
### set
1. set, setnx, mset, msetnx

2. setex, psetex
	- command key time value

3. setbit
	- setbit key offset value(0/1)

4. setrange
	- setrange key offset value(str)

### get
1. get, getset, gitbit, getrange, mget

2. getbit
	- getbit key offset

3. getrange
	- getrange key start end

### incr/decr
1. incr/ decr
	- command key

2. incrby/incrbyfloat/decrby
	- command key value

### str
1. strlen
2. append

## 
