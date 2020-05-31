filetype plugin indent on

map <C-n> :NERDTree<CR>

" pathongen
"execute pathogen#infect()

" taglist
map <C-t> :Tlist<CR>
let Tlist_Sort_Type="name"
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=0 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
"是否一直处理tags.1:处理;0:不处理
let Tlist_Process_File_Always=1 "实时更新tags
let Tlist_Inc_Winwidth=0

map <F6> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F6> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags " 设置tags搜索路径
set tags+=./tags " 设置tags搜索路径
set tags+=/usr/include/c++/tags 
set tags+=~/.vim/tags/cpp_src/tags " 设置tags搜索路径
set wildmode=longest,list " Ex命令自动补全采用bash方式"

"会用markdown的toc插件时,vim不能实现跳转,所以在目录项后面加入行数,方便跳转.
map <F8> :g/^#/s/$/\=' ' . line(".")<CR>
map <F9>  :%s/\(^#.* .*\) \d\+/\1/g<CR>

" omnicppcomplete
imap <F3> <C-X><C-O>
" 按下F2根据头文件内关键字补全
imap <F2> <C-X><C-I>
set completeopt=menu,menuone " 关掉智能补全时的预览窗口
let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表
let OmniCpp_MayCompleteScope = 1    " 输入 :: 后自动补全
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_GlobalScopeSearch=1 " enable the global scope search
let OmniCpp_DisplayMode=1 " Class scope completion mode: always show all members "let OmniCpp_DefaultNamespaces=["std"]
let OmniCpp_ShowScopeInAbbr=1 " show scope in abbreviation and remove the last column
let OmniCpp_ShowAccess=1

" -- MiniBufferExplorer --
let g:miniBufExplMapWindowNavVim = 1 " 按下Ctrl+h/j/k/l，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapWindowNavArrows = 1 " 按下Ctrl+箭头，可以切换到当前窗口的上下左右窗口
let g:miniBufExplMapCTabSwitchBufs = 1 " 启用以下两个功能：Ctrl+tab移到下一个buffer并在当前窗口打开；Ctrl+Shift+tab移到上一个buffer并在当前窗口打开；ubuntu好像不支持
"let g:miniBufExplMapCTabSwitchWindows = 1 " 启用以下两个功能：Ctrl+tab移到下一个窗口；Ctrl+Shift+tab移到上一个窗口；ubuntu好像不支持
let g:miniBufExplModSelTarget = 1 " 不要在不可编辑内容的窗口（如TagList窗口）中打开选中的buffer


"--fold setting--
set foldmethod=indent " 用语法高亮来定义折叠
"set foldmethod=syntax " 用语法高亮来定义折叠
set foldlevel=100 " 启动vim时不要自动折叠代码
"set foldcolumn=5 " 设置折叠栏宽度
" ----------------------------------------------------------------------
set nocompatible

if has("syntax")
syntax on " 语法高亮
endif

colorscheme ron " elflord ron peachpuff default 设置配色方案，vim自带的配色方案保存在/usr/share/vim/vim72/colors目录下
set ignorecase " 搜索模式里忽略大小写
set smartcase " 如果搜索模式包含大写字符，不使用 'ignorecase' 选项。只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用。
set autowrite " 自动把内容写回文件: 如果文件被修改过，在每个 :next、:rewind、:last、:first、:previous、:stop、:suspend、:tag、:!、:make、CTRL-] 和 CTRL-^命令时进行；用 :
set autoindent " 设置自动对齐(缩进)：即每行的缩进值与上一行相等；使用 noautoindent 取消设置
set smartindent " 智能对齐方式
set tabstop=4 " 设置制表符(tab键)的宽度
set softtabstop=4 " 设置软制表符的宽度
set shiftwidth=4 " (自动) 缩进使用的4个空格
set cindent " 使用 C/C++ 语言的自动缩进方式
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s "设置C/C++语言的具体缩进方式
set backspace=2 " 设置退格键可用
set showmatch " 设置匹配模式，显示匹配的括号
set linebreak " 整词换行
set whichwrap=b,s,<,>,[,] " 光标从行首和行末时可以跳到另一行去
set mouse-=a " Enable mouse usage (all modes) "使用鼠标
set number " Enable line number "显示行号 

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
map <F2> :GenTocGFM<CR>
map <C-u> :UpdateToc<CR>
imap <F2> :GenTocGFM<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickly Run
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F5> :call CompileRunGcc()<CR>

func! CompileRunGcc()
    exec "w" 
    if &filetype == 'c' 
	exec '!gcc % -std=c99 -o %<'
	exec '!time ./%<'
    elseif &filetype == 'cpp'
	exec '!g++ % -std=c++11 -o %<'
	exec '!time ./%<'
    elseif &filetype == 'python'
	exec '!time python3 %'
	elseif &filetype == 'html'
	exec '!firefox %'
    elseif &filetype == 'sh'
	:!time bash %
    endif  
endfunc 

map <CR> :call SkipLine()<CR>
func! SkipLine()
	let i = getline(".")
	"注意,正则表达式用双引号时,匹配的都是空
	let e = matchlist(i, '^\s*\* \[.* \(\d\+\)\]$')
	if len(e)
		exec ":" . e[1]
	else
		echom "无法跳跃"
	endif
endfunc


nmap    w=  :resize +3<CR>
nmap    w-  :resize -3<CR>
nmap    w,  :vertical resize -3<CR>
nmap    w.  :vertical resize +3<CR>

imap <C-c> <font color=red></font><Left><Left><Left><Left><Left><Left><Left>
imap <C-g> <font color=green></font><Left><Left><Left><Left><Left><Left><Left>
iab xtime <C-r>=strftime("%H-%M")<cr>
iab xdate <C-r>=strftime("%Y-%m-%d")<cr>
map <F4> :call Dot()<CR>
func! Dot()
	exec "w"
	exec "!dot % -Tpng -o %.png"
	exec "!xdg-open %.png"
endfunc

" 修改Emmet默认快捷键 将默认的<C-y>修改成<C-e>方便操作
let g:user_emmet_leader_key = '<C-e>'
