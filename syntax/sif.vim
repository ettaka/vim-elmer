" Vim syntax highlighing for ElmerFEM Solver Input Files (SIF).
" 
" Author: Eelis Takala
" Original Date: November 2015
" email: eelis.takala@gmail.com 
" 
if exists("b:current_syntax")
	finish
endif

" Helper functions -------------------------{{{
function! AddToSet(set_list, element)
	if index(a:set_list,a:element)==-1
		call add(a:set_list, a:element)
	endif
endfunction

function! ListToString(set_list)
	let string=''
	for word in a:set_list
		let string=string . ' "' . word . '"'
	endfor
	return string
endfunction
" --------}}}
" Search for SOLVER.KEYWORDS file -------------------------------------- {{{
let complain=0
let filepaths=[]
let keysfound=0
call AddToSet(filepaths, $ELMER_HOME . '/share/elmersolver/lib/SOLVER.KEYWORDS')
call AddToSet(filepaths, $HOME . '/.vim/syntax/SOLVER.KEYWORDS')
call AddToSet(filepaths, $HOME . '/.vim/bundle/vim-elmer/syntax/SOLVER.KEYWORDS')
let filecontents=[]
for filepath in filepaths
	if filereadable(filepath)
		let filecontents=readfile(filepath)
		let keysfound=1
		break
	endif
endfor

if !keysfound
	echom "Warning: SOLVER.KEYWORDS not found!"
elseif complain && !filereadable(filepaths[0])
	echo "ELMER_HOME environment variable might not be set properly. Some keywords might be missing."
endif
" ------------------------}}}
" Search for keywords -------------------------------------- {{{
let sif_lists=[]
let sif_keys=[]
let sif_types=[]
for line in filecontents
	if line=~'^[A-Za-z].*' 
		let llist=split(line,':')	
		if len(llist)==3
			call AddToSet(sif_lists, tolower(llist[0]))
			call AddToSet(sif_types, tolower(llist[1]))
			let tmp_key=split(llist[2],"\'")
			call AddToSet(sif_keys, tolower(tmp_key[1]))
		endif
	endif 
endfor

call AddToSet(sif_keys, 'exported variable')
call AddToSet(sif_keys, 'permittivity of vacuum')
call AddToSet(sif_keys, 'mesh db')
call AddToSet(sif_keys, 'Check Keywords')
call AddToSet(sif_keys, 'include')
" }}}
" Match Keywords ------------------------------------{{{
for sif_key in sif_keys
	execute ('syntax match sifKeyword "\c' . sif_key . '"')
endfor
" ------------------------------------------------}}}
" Match Types --------------------------{{{
for sif_type in sif_types
	execute ('syntax match sifType "\c' . sif_type . '"')
endfor
" ------------------}}}
" Match numbers and strings -----------------------------{{{
syn match sifNumber	display "\<\d\+\(_\a\w*\)\=\>"
syn match sifFloatIll	display	"\c\<\d\+[deq][-+]\=\d\+\(_\a\w*\)\=\>"
" floating point number, starting with a decimal point
syn match sifFloatIll	display	"\c\.\d\+\([deq][-+]\=\d\+\)\=\(_\a\w*\)\=\>"
" floating point number, no digits after decimal
syn match sifFloatIll	display	"\c\<\d\+\.\([deq][-+]\=\d\+\)\=\(_\a\w*\)\=\>"
" floating point number, D or Q exponents
syn match sifFloatIll	display	"\c\<\d\+\.\d\+\([dq][-+]\=\d\+\)\=\(_\a\w*\)\=\>"
" floating point number
syn match sifFloat	display	"\c\<\d\+\.\d\+\(e[-+]\=\d\+\)\=\(_\a\w*\)\=\>"


syntax match sifBoolean "\ctrue"
syntax match sifBoolean "\cfalse"

syntax match sifOperator "="
syntax region sifString start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region sifSpline start=/\creal cubic/ skip=/\v\\./ end=/\cend/ fold contains=sifKeyword,sifFloat,sifFloatIll,sifNumber
syn region sifInlineMATC start="\$" end="$\|\$" contains=sifFloat,sifFloatIll,sifNumber,sifString,sifOperator

" -------------------------------------------------------}}}
" Match Operators-----------------------------{{{
syntax match sifOperator "\(=\|-\|+\)"
syntax region sifString start=/\v"/ skip=/\v\\./ end=/\v"/
" -------------------------------------------------------}}}
" Match Comments ----------------------{{{
syntax match sifComment "\v!.*$"
" ----------------}}}
" Match Lists ---------------------------------------------{{{
let test_lists=[]

call AddToSet(test_lists, 'initial condition')
call AddToSet(test_lists, 'boundary condition')
call AddToSet(test_lists, 'simulation')
call AddToSet(test_lists, 'header')
call AddToSet(test_lists, 'constants')
call AddToSet(test_lists, 'solver')
call AddToSet(test_lists, 'equation')
call AddToSet(test_lists, 'material')
call AddToSet(test_lists, 'body')
call AddToSet(test_lists, 'component')
for test_list in test_lists
	let cmd="syntax region sifListBlock matchgroup=sifLB start='\\c". test_list . "' end='^\\s\\{-}\\cEnd' fold contains=sifKeyword,sifString,sifNumber,sifType,sifFloat,sifFloatIll,sifOperator,sifBoolean,sifComment,sifSpline"
	execute(cmd)
endfor
" -----------------------------------------------------}}}
" Highlights -------------------------------------- {{{
highlight link sifString String
highlight link sifKeyword Keyword
highlight link sifList Structure
highlight link sifLB Structure
highlight link sifComment Comment
highlight link sifType Type 
highlight link sifNumber Number
highlight link sifFloat Float
highlight link sifFloatIll Float
highlight link sifOperator Operator
highlight link sifBoolean Boolean
highlight link sifSpline Structure
" }}}

let b:current_syntax = "sif"


