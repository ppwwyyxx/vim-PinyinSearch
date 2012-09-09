FEATURE:
	just like the original 'f' key, but support pinyin for Chinese as well as
	continuous word

EXAMPLE:
	今天是个好日子,心想的事儿都能成

	put cursor under the above line , press <c-f> and enter "dn<Enter>", the
	cursor will move to "都能"

INSTALL:

1. copy PinyinSearch.vim to your plugin directory

2. specify the location of other two files in your .vimrc, e.g.:

		let g:PinyinSearch_Dict = '/home/wyx/.vim/PinyinSearch.dict'
		let g:PinyinSearch_Python = '/home/wyx/.vim/PinyinSearch.py'

3. add your custom key map, e.g.:

		nnoremap<silent><expr> <c-f> PinyinSearch()
