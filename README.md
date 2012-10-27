INTRODUCTION:
=============
	Allow searching of Chinese in VIM by the first letter of Chinese pinyin

INSTALL:
========

1. copy PinyinSearch.vim to your plugin directory

2. specify the location of dict file in your .vimrc, e.g.:

		let g:PinyinSearch_Dict = '/home/wyx/.vim/PinyinSearch.dict'

3. add your custom key map, e.g.:

		nnoremap <Leader>ps :call PinyinSearch()<CR>
		nnoremap <Leader>pn :call PinyinNext()<CR>

USAGE:
======

	call PinyinSearch() and enter the target chars(first letters of the word),
	all the matching words will be highlighted, you can use 'n' and 'N' to
	jump.

	During a normal searching (i.e. you are searching for pure english),
	call PinyinNext() and all the matching Chinese will also be highlighted.

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

