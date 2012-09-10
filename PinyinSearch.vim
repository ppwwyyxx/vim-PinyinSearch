function Pinyin(table, char, op)
python << EOF
import vim,sys
ENCODING = 'utf-8'

def find_next(line):
    """
        return the location
    """
    flag = r = 0
    for i in line:
        r += 1
        try:
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

def Pinyin_Next():
    pos = w.cursor
    line = b[pos[0] - 1][pos[1]:].decode(ENCODING)
    r = find_next(line[1:])
    if r >= 0:
        vim.command("normal {0}l".format(r + 1))
    else :
        for i in xrange(len(b) - pos[0]):
            line = b[pos[0] + i].strip().decode(ENCODING)
            r = find_next(line)
            if r >= 0 :
                vim.command("normal {0}G".format(pos[0] + i + 1))
                if r > 0 :
                    vim.command("normal {0}l".format(r))
                break
    return

def Pinyin_Search():
    text = ''.join(map(lambda x : x.strip(), b)).decode(ENCODING)
    l = 0
    while True:
        r = find_next(text[l:])
        if r >= 0:
            word = text[(l + r) : (l + r + charlen)]
            vim.command("call matchadd('Search', '{0}')".format(word.encode('utf-8')))
            l = l + r + 1
        else :
            break

op = int(vim.eval("a:op"))
table = vim.eval("a:table"); chars = vim.eval("a:char").decode(ENCODING)
charlen = len(chars)
cur = vim.current; w = cur.window; b = cur.buffer
dict_file = open(table, 'r')
Dict = {}
map(lambda x: Dict.__setitem__(x.split(' ')[0].decode(ENCODING), map(lambda u: u.strip(), x.split(' ')[1:])), dict_file.readlines())
if op == 0 :
	Pinyin_Next()
else :
	Pinyin_Search()

EOF
endfunc

let g:PinyinSearch_Chars = ''
function PinyinSearch()
	call clearmatches()
    let old_chars = g:PinyinSearch_Chars
    let g:PinyinSearch_Chars = input('Input the First Chars: ')
    if g:PinyinSearch_Chars == ''
        let g:PinyinSearch_Chars = old_chars
        if g:PinyinSearch_Chars == ''
            return
        endif
    endif

    let line = getline('.')[getpos('.')[2] - 1:]
    let old_gdefault=&gdefault
    set nogdefault
    let line = substitute(line, '"', '\\"' , "g")
    let g:PinyinSearch_Chars = substitute(g:PinyinSearch_Chars, '"', '\\"' , "g")
    let &gdefault = old_gdefault

    call Pinyin(g:PinyinSearch_Dict, g:PinyinSearch_Chars, flag)
endfunction

"function PinyinNext()
