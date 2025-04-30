if exists("g:loaded_commy")
    finish
endif
let g:loaded_commy = 1

function! s:replace(string, pattern, replacement) abort
    let parts = split(a:string, a:pattern, 1)
    return join(parts, a:replacement)
endfunction

function! CommyAdd(l1, l2) abort range
    let column = -1
    let l = a:l1
    while l <= a:l2
        let line = getline(l)
        let c = match(line, '\S')

        if (c < column || column == -1) && !(c == -1 || strlen(line) == 0)
            let column = c
        endif
        let l += 1
    endwhile

    if column == -1
        return
    elseif column == 0
        let whitespace = ''
    endif

    let l = a:l1
    while l <= a:l2
        let line = getline(l)
        if column > 0
            let whitespace = line[:column-1]
        endif

        let line = line[column:]
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

        let pattern = s:replace(&commentstring, '%s', '\(.*\)')
        let pattern = '^' .. pattern .. '$'

        let newline = substitute(line, pattern, '\1', "")
        call setline(l, whitespace .. newline)
        let l += 1
    endwhile
endfunction

command -range CommyAdd call CommyAdd(<line1>, <line2>)
map TA :CommyAdd<CR>

command -range CommyRm call CommyRm(<line1>, <line2>)
map TD :CommyRm<CR>
