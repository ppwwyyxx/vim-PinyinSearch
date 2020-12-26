
" dict from http://lingua.mtsu.edu/chinese-computing/statistics/char/list.php?Which=IN
func! s:Pinyin(table, char)
    call clearmatches()
python << EOF
import vim,sys
ENCODING = vim.eval("&fileencoding")
if not ENCODING or ENCODING == 'none':
    ENCODING = 'utf-8'
table = vim.eval("a:table")
chars = vim.eval("a:char")
charlen = len(chars)
if charlen == 0:
	vim.command("return") # XXX error on no input
cur = vim.current; window = cur.window; buf = cur.buffer
Dict = {}
with open(table, 'r', encoding='utf-8') as f:
    def update(ch, s):
        Dict.setdefault(ch, [])
        Dict[ch].extend(s)

    for line in f.readlines():
        sp = line.split(' ')
        update(sp[0], map(lambda x: x.strip(), sp[1:]))

        #with open('/tmp/tmp', 'w') as f:
        #    f.write(str(Dict))

def find_next(line):
    flag = r = 0
    for i in line:
        r += 1
        try :
            t = Dict[i]
        except KeyError:
            t = i
        if chars[flag] in t:
            flag += 1
        elif chars[0] in t:
            flag = 1
        else:
            flag = 0

        if flag == charlen:
            break
    if flag != charlen:
        return -1
    else:
        return r - charlen

def gen_list():
    text = ''.join(map(lambda x : x.strip(), buf))
    l = 0
    ret = list()
    while True:
        r = find_next(text[l:])
        if r >= 0:
            word = text[(l + r) : (l + r + charlen)]
            ret.append(word)
            l = l + r + 1
        else :
            return ret

result = gen_list()
result = list(set(result))        # deduplicate
#f = open('/tmp/test', 'w')
#f.write(''.join(result))
#f.close()
pattern = "\\\\|".join(result)
if result:
    vim.command("let @/ = \"{0}\"".format(pattern))
	#vim.command("set hls")	# this don't work
    vim.command('call feedkeys(":set hls\<CR>n")')
EOF
endfunc

func! PinyinNext()
    call s:Pinyin(g:PinyinSearch_Dict, @/)
endfunc

func! PinyinSearch()
    let PinyinSearch_Chars = input('Input the Leader Chars: ')
    call s:Pinyin(g:PinyinSearch_Dict, PinyinSearch_Chars)
endfunc

" vim: set expandtab
