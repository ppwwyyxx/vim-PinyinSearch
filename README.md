INTRODUCTION:
=============
	Allow searching of Chinese in VIM by the first letter of Chinese pinyin.
	Vim中允许使用拼音首字母搜索中文.
	The program is also available at [vim.org](www.vim.org/scripts/script.php?script_id=4211)

INSTALL:
========

1. copy PinyinSearch.vim to your plugin directory

2. specify the location of dict file in your .vimrc, e.g.:

		let g:PinyinSearch_Dict = '/home/wyx/.vim/PinyinSearch.dict'

3. (optional)add your custom key map, e.g.:

		nnoremap ? :call PinyinSearch()<CR>
		" I suggest use '?' to search Pinyin (since we have 'N', why using ? to search backward)
		nnoremap <Leader>pn :call PinyinNext()<CR>

USAGE:
======
	call PinyinSearch() and enter the target chars(first letters of the word),
	all the matching words will be highlighted, you can use 'n' and 'N' to
	jump.

	During a normal searching (i.e. you are searching for pure english),
	call PinyinNext() and all the matching Chinese will also be highlighted.

 ------------------------------------------------------------------------------------------

	PinyinSearch()函数接受首字母输入,将高亮所有匹配的中英文,并允许用n,N跳转搜
	索结果.

	正在用'/'搜索英文时,调用PinyinNext()函数可以将匹配的中文也加入搜索.

EXAMPLE:
========

		----------START OF EXAMPLE FILE----------------
		今天是个好日子,心想的事儿都能成,

		大能猫dn
		----------END OF EXAMPLE FILE----------------
	In normal mode, enter '/dn'	, then "dn" will be highlighted.
	Then, call PinyinNext(), then "大能" and "都能" will also be highlighted, and the
	cursor will jump to "大能".

	Or you can just simply call PinyinSearch() and enter 'dn', both English
	and Chinese will be searched.

