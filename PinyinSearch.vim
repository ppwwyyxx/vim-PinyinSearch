function Line_Move(table, char)
python << EOF
ENCODING = 'utf8'
def pinyin_match(table, line, char):
    file = open(table, 'r')
    dict = {}
    map(lambda x: dict.__setitem__(x.split(' ')[0].decode(ENCODING),
		map(lambda u: u.strip(), x.split(' ')[1:])), file.readlines())

    lineList = list(line)
    charList = list(char)

    flag = r = 0
    for i in lineList:
        r += 1
        try:
        	t = dict[i]
        except KeyError:
        	t = i

        if charList[flag] in t:
        	flag += 1
        elif charList[0] in t:
        	flag = 1
        else:
        	flag = 0

        if flag == len(charList):
        	break
    if flag == 0:
        return -1
    else:
        return r - flag

#fout = open("out.txt", 'a')
import vim
table = vim.eval("a:table"); char = vim.eval("a:char").decode(ENCODING)
cur = vim.current; w = cur.window; b = cur.buffer
pos = w.cursor
line = b[pos[0] - 1][pos[1]:]
line = line.decode(ENCODING)
r = pinyin_match(table, line[1:], char)
#fout.write(table + '   ' + char + '   ' + line[1:] + '\n')
#fout.write(str(r) + '\n')
#fout.close()
if r >= 0:
	vim.command("normal {0}l".format(r + 1))
else :
	for i in xrange(len(b) - pos[0]):
		line = b[pos[0] + i].strip().decode(ENCODING)
		r = pinyin_match(table, line, char)
		if r >= 0 :
			vim.command("normal {0}G".format(pos[0] + i + 1))
			if r > 0 :
				vim.command("normal {0}l".format(r))
			break
EOF
endfunc

let g:PinyinSearch_Chars = ''
function PinyinSearch()
	let old_chars = g:PinyinSearch_Chars
	let g:PinyinSearch_Chars = input('Input the First Chars: ')
	if g:PinyinSearch_Chars == ''
		let g:PinyinSearch_Chars = old_chars
	endif

	let line = getline('.')[getpos('.')[2] - 1:]
	let old_gdefault=&gdefault
	set nogdefault
	let line = substitute(line, '"', '\\"' , "g")
	let g:PinyinSearch_Chars = substitute(g:PinyinSearch_Chars, '"', '\\"' , "g")
	let &gdefault = old_gdefault
	call Line_Move(g:PinyinSearch_Dict, g:PinyinSearch_Chars)
endfunction
