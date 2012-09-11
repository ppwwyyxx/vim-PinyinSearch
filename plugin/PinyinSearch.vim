function Pinyin(table, char, op)
python << EOF
import vim,sys
ENCODING = 'utf-8'

op = int(vim.eval("a:op"))
table = vim.eval("a:table");
chars = vim.eval("a:char").decode(ENCODING)
charlen = len(chars)
cur = vim.current; w = cur.window; b = cur.buffer
dict_file = open(table, 'r')
Dict = {}
map(lambda x: Dict.__setitem__(x.split(' ')[0].decode(ENCODING), map(lambda u: u.strip(), x.split(' ')[1:])), dict_file.readlines())

def find_next(line):
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
        return 1
    else :
        for i in xrange(len(b) - pos[0]):
            line = b[pos[0] + i].strip().decode(ENCODING)
            r = find_next(line)
            if r >= 0 :
                vim.command("normal {0}G".format(pos[0] + i + 1))
                if r > 0 :
                    vim.command("normal {0}l".format(r))
                return 1
    return 0

def Pinyin_Prev():
    pos = w.cursor
    line = b[pos[0] - 1][:pos[1]].decode(ENCODING)[::-1]
    global chars
    chars = chars[::-1]
    r = find_next(line)                        # the reverse part don't include itself
    if r >= 0:
        vim.command("normal {0}h".format(r + charlen))        
        return 1
    else :
        for i in xrange(pos[0] - 2, -1, -1):
            line = b[i].strip().decode(ENCODING)[::-1]
            r = find_next(line)
            if r >= 0 :
                vim.command("normal {0}G$".format(i + 1))
                if r > 0 :
                    vim.command("normal {0}h".format(r + charlen - 1))
                return 1
    return 0


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
if op == 0 :
    vim.command("return {0}".format(Pinyin_Next()))
elif op == 1 :
    vim.command("return {0}".format(Pinyin_Prev()))
else :
    Pinyin_Search()
EOF
endfunc

let g:PinyinSearch_Chars = ''

function PinyinInitialize()
    let g:old_gdefault=&gdefault
    set nogdefault
    let g:PinyinSearch_Chars = substitute(g:PinyinSearch_Chars, '"', '\\"' , "g")
    let &gdefault = g:old_gdefault
endfunc

function PinyinSearch()
    let old_chars = g:PinyinSearch_Chars
    let g:PinyinSearch_Chars = input('Input the Leader Chars: ')
    call clearmatches()
    if g:PinyinSearch_Chars == ''
        call RestoreUserMaps("UserMap")
        return 
    endif
    call PinyinInitialize()

    let flag = 2
    call Pinyin(g:PinyinSearch_Dict, g:PinyinSearch_Chars, flag)
    call SaveUserMaps("n","","n","UserMap")
    call SaveUserMaps("n","","N","UserMap")
    nnoremap n :call PinyinNext(0)<CR><CR>
    nnoremap N :call PinyinNext(1)<CR><CR>
endfunction

function PinyinNext(flag)
    let old_chars = g:PinyinSearch_Chars
    let g:PinyinSearch_Chars = input('Input the Leader Chars: ')
    if g:PinyinSearch_Chars == ''
        let g:PinyinSearch_Chars = old_chars
        if g:PinyinSearch_Chars == ''
            return
        endif
    endif
    call PinyinInitialize()

    let ret = Pinyin(g:PinyinSearch_Dict, g:PinyinSearch_Chars, a:flag)
    if ret == 0
        redraw!
        echohl warningmsg
        echomsg 'Word Not Found'
    endif
endfunction



" The Following part are from http://www.vim.org/scripts/script.php?script_id=1066
" SaveUserMaps: this function sets up a script-variable (s:restoremap) {{{2
"          which can be used to restore user maps later with
"          call RestoreUserMaps()
"
"          mapmode - see :help maparg for details (n v o i c l "")
"                    ex. "n" = Normal
"                    The letters "b" and "u" are optional prefixes;
"                    The "u" means that the map will also be unmapped
"                    The "b" means that the map has a <buffer> qualifier
"                    ex. "un"  = Normal + unmapping
"                    ex. "bn"  = Normal + <buffer>
"                    ex. "bun" = Normal + <buffer> + unmapping
"                    ex. "ubn" = Normal + <buffer> + unmapping
"          maplead - see mapchx
"          mapchx  - "<something>" handled as a single map item.
"                    ex. "<left>"
"                  - "string" a string of single letters which are actually
"                    multiple two-letter maps (using the maplead:
"                    maplead . each_character_in_string)
"                    ex. maplead="\" and mapchx="abc" saves user mappings for
"                        \a, \b, and \c
"                    Of course, if maplead is "", then for mapchx="abc",
"                    mappings for a, b, and c are saved.
"                  - :something  handled as a single map item, w/o the ":"
"                    ex.  mapchx= ":abc" will save a mapping for "abc"
"          suffix  - a string unique to your plugin
"                    ex.  suffix= "DrawIt"
fun! SaveUserMaps(mapmode,maplead,mapchx,suffix)
"  call Dfunc("SaveUserMaps(mapmode<".a:mapmode."> maplead<".a:maplead."> mapchx<".a:mapchx."> suffix<".a:suffix.">)")

  if !exists("s:restoremap_{a:suffix}")
   " initialize restoremap_suffix to null string
   let s:restoremap_{a:suffix}= ""
  endif

  " set up dounmap: if 1, then save and unmap  (a:mapmode leads with a "u")
  "                 if 0, save only
  let mapmode  = a:mapmode
  let dounmap  = 0
  let dobuffer = ""
  while mapmode =~ '^[bu]'
   if     mapmode =~ '^u'
    let dounmap = 1
    let mapmode = strpart(a:mapmode,1)
   elseif mapmode =~ '^b'
    let dobuffer = "<buffer> "
    let mapmode  = strpart(a:mapmode,1)
   endif
  endwhile
"  call Decho("dounmap=".dounmap."  dobuffer<".dobuffer.">")
 
  " save single map :...something...
  if strpart(a:mapchx,0,1) == ':'
"   call Decho("save single map :...something...")
   let amap= strpart(a:mapchx,1)
   if amap == "|" || amap == "\<c-v>"
    let amap= "\<c-v>".amap
   endif
   let amap                    = a:maplead.amap
   let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|:silent! ".mapmode."unmap ".dobuffer.amap
   if maparg(amap,mapmode) != ""
    let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
    let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|:".mapmode."map ".dobuffer.amap." ".maprhs
   endif
   if dounmap
    exe "silent! ".mapmode."unmap ".dobuffer.amap
   endif
 
  " save single map <something>
  elseif strpart(a:mapchx,0,1) == '<'
"   call Decho("save single map <something>")
   let amap       = a:mapchx
   if amap == "|" || amap == "\<c-v>"
    let amap= "\<c-v>".amap
"    call Decho("amap[[".amap."]]")
   endif
   let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|silent! ".mapmode."unmap ".dobuffer.amap
   if maparg(a:mapchx,mapmode) != ""
    let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
    let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|".mapmode."map ".dobuffer.amap." ".maprhs
   endif
   if dounmap
    exe "silent! ".mapmode."unmap ".dobuffer.amap
   endif
 
  " save multiple maps
  else
"   call Decho("save multiple maps")
   let i= 1
   while i <= strlen(a:mapchx)
    let amap= a:maplead.strpart(a:mapchx,i-1,1)
    if amap == "|" || amap == "\<c-v>"
     let amap= "\<c-v>".amap
    endif
    let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|silent! ".mapmode."unmap ".dobuffer.amap
    if maparg(amap,mapmode) != ""
     let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
     let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|".mapmode."map ".dobuffer.amap." ".maprhs
    endif
    if dounmap
     exe "silent! ".mapmode."unmap ".dobuffer.amap
    endif
    let i= i + 1
   endwhile
  endif
"  call Dret("SaveUserMaps : restoremap_".a:suffix.": ".s:restoremap_{a:suffix})
endfun

" ---------------------------------------------------------------------
" RestoreUserMaps: {{{2
"   Used to restore user maps saved by SaveUserMaps()
fun! RestoreUserMaps(suffix)
"  call Dfunc("RestoreUserMaps(suffix<".a:suffix.">)")
  if exists("s:restoremap_{a:suffix}")
   let s:restoremap_{a:suffix}= substitute(s:restoremap_{a:suffix},'|\s*$','','e')
   if s:restoremap_{a:suffix} != ""
"       call Decho("exe ".s:restoremap_{a:suffix})
    exe "silent! ".s:restoremap_{a:suffix}
   endif
   unlet s:restoremap_{a:suffix}
  endif
"  call Dret("RestoreUserMaps")
endfun

