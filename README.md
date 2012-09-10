INTRODUCTION:
=============
	Allow you to search Chinese in VIM by the first letter of Chinese pinyin

FEATURE:
========
1. Jump to next matched word and remember your jump history
2. Global highlight all matched word and jump

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
	call PinyinNext() and enter the target chars, you will jump to next word
	matching the target (Either English or Chinese which matches the first
	letter).
	If no target is given to PinyinNext(), it will use your last target.

	call PinyinSearch() and enter the target chars, all matched words will be
	highlighted, you can use 'n' in normal mode to jump between the matched
	words.
	call PinyinSearch() again without giving any target, to clear the
	highlight and restore your custom map for 'n'

EXAMPLE:
========
	----------START OF EXAMPLE FILE----------------
	今天是个好日子,心想的事儿都能成,

	大能猫
	----------END OF EXAMPLE FILE----------------

	put cursor under the first line , call PinyinNext() and enter "dn<Enter>", the
	cursor will move to "都能", call PinyinNext() and enter "<Enter>", the cursor
	will move to "大能".
	put cursor at the start of file, call PinyinSearch() and enter "dn<Enter>", "都能" and "大能" will be
	highlighted, you can use 'n' to jump to next highlited text. 
	Don't forget to call PinyinSearch() again without giving the target.

