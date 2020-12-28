## Introduction


Allow searching of Chinese in VIM by the first letter of Chinese pinyin.
Vim中允许使用拼音首字母搜索中文.
The program is also available at [vim.org](www.vim.org/scripts/script.php?script_id=4211)

# Install

0. Requires vim built with python3 support. Check with `:echo has('python3')`

1. copy PinyinSearch.vim to your plugin directory (or through bundle)

2. specify the location of dict file in your .vimrc, e.g.:

		let g:PinyinSearch_Dict = $HOME . '/.vim/bundle/vim-PinyinSearch/PinyinSearch.dict'

3. (optional) add the suggested key mapping:

		nnoremap ? :call PinyinSearch()<CR>
		" I suggest using '?' to search Pinyin (since we have 'N', why using ? to search backward)
		nnoremap <Leader>pn :call PinyinNext()<CR>

## Usage

The plugin provides two functions:

1. call `PinyinSearch()` and enter the target characters (first letters of the word),
then all the matching characters will be searched and highlighted, you can use `n` and `N` to navigate.

2. During a normal search (i.e. you are searching for pure english),
call `PinyinNext()` and all the matching Chinese will also be searched.

------------------------------------------------------------------------------------------

1. `PinyinSearch()`函数接受首字母输入,将高亮所有匹配的中英文,并允许用`n,N`跳转搜索结果.

2. 正在用`/`搜索英文时,调用`PinyinNext()`函数可以将匹配的中文也加入搜索.

## Example

```
----------START OF EXAMPLE FILE----------------
今天是个好日子,心想的事儿都能成,

大能猫dn
----------END OF EXAMPLE FILE----------------
```

In normal mode, enter `/dn`	, then "dn" will be highlighted.
Then, call `PinyinNext()`, then "大能" and "都能" will also be highlighted, and the
cursor will jump to "大能".

Or you can call `PinyinSearch()` and enter `dn` (or just `?dn` if you use the suggested key mapping), both English
and Chinese will be searched.

