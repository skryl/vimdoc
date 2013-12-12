let s:path = expand('<sfile>:p:h')

function! s:Vimdoc()
let vimdoc = system("ruby " . s:path . "/vimdoc.rb --no-color")

" Open a new split and set it up.
vsplit __Vimdoc__
normal! ggdG
setlocal filetype=potionbytecode
setlocal buftype=nofile

call append(0, split(vimdoc, '\v\n'))
endfunction

command Vimdoc :call s:Vimdoc()
