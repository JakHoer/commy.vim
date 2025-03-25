if exists("g:loaded_commy")
    finish
endif
let g:loaded_commy = 1

function! s:replace(string, pattern, replacement) abort
    let parts = split(a:string, a:pattern, 1)
    return join(parts, a:replacement)
endfunction

function! CommyAdd(l1, l2) abort range
    let l = a:l1
    while l <= a:l2
        let line = getline(l)
        let whitespace = matchstr(line, '^\s*')
        let line = trim(line, " \t", 1)
        if strlen(line) > 0
            let newline = s:replace(&commentstring, "%s", line)
            call setline(l, whitespace .. newline)
        endif
        let l += 1
    endwhile
endfunction

function CommyRm(l1, l2) abort range
    let l = a:l1
    while l <= a:l2
        let line = getline(l)
        let whitespace = matchstr(line, '^\s*')
        let line = trim(line, " \t", 1)
        let pattern = printf('%s\|%s', &commentstring, trim(&commentstring))
        let pattern = substitute(pattern, '%s', '\\(.*\\)', "")
        let newline = substitute(line, pattern, '\1', "")
        call setline(l, whitespace .. newline)
        let l += 1
    endwhile
endfunction

command -range CommyAdd call CommyAdd(<line1>, <line2>)
map TA :CommyAdd<CR>

command -range CommyRm call CommyRm(<line1>, <line2>)
map TD :CommyRm<CR>
