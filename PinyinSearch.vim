function PinyinSearch()
	let chars = input('Input the First Chars: ')
	redraw!
	if chars == ''
		sil!exe 'sil!return "' . "\<Esc>"  . '"'
	endif

	let line = getline('.')[getpos('.')[2] - 1:]
	let old_gdefault=&gdefault
	set nogdefault
	let line = substitute(line, '"', '\\"' , "g")
	let chars = substitute(chars, '"', '\\"' , "g")
	let &gdefault = old_gdefault

	let r = system(g:PinyinSearch_Python . ' ' . g:PinyinSearch_Dict . '  "' . line . '" "' . chars . '"')

	if r == '' || r == '0'
		echohl warningmsg
		echomsg 'Not Found ' . chars
		echohl normal

		sil!exe 'sil!return "' . "\<Esc>"  . '"'
	else

		sil!exe 'sil!return "' . r . '"'
	endif
endfunction
