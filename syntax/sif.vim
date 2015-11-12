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
" Search for keywords -------------------------------------- {{{
let keyword_path='/home/eelis/.vim/syntax/'
let filecontents=readfile(keyword_path . "SOLVER.KEYWORDS")
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
  let cmd="syntax region sifListBlock matchgroup=sifLB start='\\c". test_list . "' end='\\c\\(::\\|End\\)' fold contains=sifKeyword,sifString,sifNumber,sifType,sifFloat,sifFloatIll,sifOperator,sifBoolean"
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
" }}}

let b:current_syntax = "sif"


