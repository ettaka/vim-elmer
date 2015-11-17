augroup filetype_fortran_elmer
	autocmd!
  autocmd FileType fortran nnoremap <buffer> <localleader>wf :execute(":call ElmerMethod('FUNCTION')")<cr>jf(a
  autocmd FileType fortran nnoremap <buffer> <localleader>ws :execute(":call ElmerMethod('SUBROUTINE')")<cr>jf(a
augroup END

function! Add_with_lnum(lines, line)
	let new_lines=a:lines
	call add(new_lines, [len(new_lines), a:line])
	return new_lines
endfunction

function! ElmerMethod(type)
	let name=expand(@")
	let lines=[]
	let decor='!-------------------------------------------------------------------'
	
	let lines=Add_with_lnum(lines, decor)
	let lines=Add_with_lnum(lines, " ".a:type." ".name."()")
	let lines=Add_with_lnum(lines, decor)
	let lines=Add_with_lnum(lines, " IMPLICIT NONE")
	let lines=Add_with_lnum(lines, "")
	let lines=Add_with_lnum(lines, decor)
	let lines=Add_with_lnum(lines, " END ".a:type." ".name)
	let lines=Add_with_lnum(lines, decor)

	let lnum=line('.')
	for [i,line] in lines
	  call setline(lnum+i, line)
	endfor
endfunction

