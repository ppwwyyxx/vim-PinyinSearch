func s:Pinyin(table, char)
	call clearmatches()
python << EOF
import vim,sys
ENCODING = vim.eval("&fileencoding")
table = vim.eval("a:table");
chars = vim.eval("a:char").decode(ENCODING)
charlen = len(chars)
cur = vim.current; window = cur.window; buf = cur.buffer
dict_file = open(table, 'r')
Dict = {}
map(lambda x: Dict.__setitem__(x.split(' ')[0].decode(ENCODING), map(lambda u: u.strip(), x.split(' ')[1:])), dict_file.readlines())

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
        else :
            flag = 0

        if flag == charlen:
            break
    if flag != charlen:
        return -1
    else:
        return r - charlen

def Pinyin_Search():
    text = ''.join(map(lambda x : x.strip(), buf)).decode(ENCODING)
    l = 0
    ret = list()
    while True:
        r = find_next(text[l:])
        if r >= 0:
            word = text[(l + r) : (l + r + charlen)]
            ret.append(word.encode(ENCODING))
            l = l + r + 1
        else :
            break
    return ret

result = Pinyin_Search()
result = list(set(result))		# deduplicate
pattern = "\\\\|".join(result)
vim.command("let @/ = \"{0}\"".format(pattern))
vim.command("set hls")
vim.command("normal n")
EOF
endfunc

func PinyinNext()
    call s:Pinyin(g:PinyinSearch_Dict, @/)
endfunc

func PinyinSearch()
    let PinyinSearch_Chars = input('Input the Leader Chars: ')
	call s:Pinyin(g:PinyinSearch_Dict, PinyinSearch_Chars)
endfunc
