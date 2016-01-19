" Forptran file settings ---------- {{{
augroup filetype_fortran
  autocmd!
	autocmd FileType fortran set foldmethod=syntax
  autocmd FileType fortran nnoremap <buffer> <localleader>c 0i!<esc>j
  autocmd FileType fortran nnoremap <buffer> <localleader>wf :execute(":call ElmerFortranRegion('FUNCTION')")<cr>7kf(a
  autocmd FileType fortran nnoremap <buffer> <localleader>ws :execute(":call ElmerFortranRegion('SUBROUTINE')")<cr>7kf(a
  autocmd FileType fortran nnoremap <buffer> <localleader>wm :execute(":call ElmerFortranRegion('MODULE')")<cr>4ka
	autocmd FileType fortran set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
augroup END
" }}}
" Elmer Sif file settings ---------- {{{
augroup filetype_sif
  autocmd!
	autocmd FileType sif set foldmethod=syntax
  autocmd FileType sif nnoremap <buffer> <localleader>c 0i!<esc>j
  autocmd FileType sif nnoremap <localleader>e :call ToggleEmpyLines()<cr>
augroup END
" }}}
" Fortran templates ------------- {{{
function! Add_with_lnum(lines, line)
	let new_lines=a:lines
	call add(new_lines, [len(new_lines), a:line])
	return new_lines
endfunction

function! ElmerFortranRegion(type)
	let name=expand(@")
	let lines=[]
	let decor='!-------------------------------------------------------------------'
	
	let lines=Add_with_lnum(lines, decor)
	if a:type=='MODULE'
	  let lines=Add_with_lnum(lines, " ".a:type." ".name)
	else
	  let lines=Add_with_lnum(lines, " ".a:type." ".name."()")
	endif
	let lines=Add_with_lnum(lines, decor)
	let lines=Add_with_lnum(lines, " IMPLICIT NONE")
	let lines=Add_with_lnum(lines, "")
	let lines=Add_with_lnum(lines, decor)
	let lines=Add_with_lnum(lines, " END ".a:type." ".name)
	let lines=Add_with_lnum(lines, decor)

	let lnum=line('.')
	for [i,line] in lines
		execute("normal! o")
	  call setline(lnum+i, line)
	endfor
endfunction
" ------------}}}

function! ToggleEmpyLines()
	let a:cursor_pos=line(".")
	let g:EmptyLines = get(g:, 'EmptyLines', 1)
  if g:EmptyLines==0
 		execute ":g/^$/d"
 		let g:EmptyLines = 1
 	else
 		execute ":%s/End/End\r"
 		let g:EmptyLines = 0
 	endif
	:call setpos(".", [0, a:cursor_pos, 1,0])
endfunction
