INTRODUCTION:
=============
	Allow you to search Chinese in VIM by the first letter of Chinese character

FEATURE:
========
1. Jump to next matched word
2. Global highlight all matched word

INSTALL:
========

1. copy PinyinSearch.vim to your plugin directory

2. specify the location of dict file in your .vimrc, e.g.:

		let g:PinyinSearch_Dict = '/home/wyx/.vim/PinyinSearch.dict'

3. add your custom key map, e.g.:

		nnoremap <Leader>ps :call PinyinSearch()<CR>
		nnoremap <Leader>pn :call PinyinNext()<CR>

EXAMPLE:
========
	今天是个好日子,心想的事儿都能成,

	大能猫

	put cursor under the first line , call PinyinNext() and enter "dn<Enter>", the
	cursor will move to "都能", call PinyinNext() and enter "<Enter>", the cursor
	will move to "大能".
	call PinyinSearch() and enter "dn<Enter>", "都能" and "大能" will be
	highlighted

