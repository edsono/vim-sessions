" sessions.vim: Sessions in project dir are auto saved
" Last modified: 27/11/2009
" Version:       0.1
" Maintainer:    Edson César <edsono@gmail.com>
" License:       This script is released under the Vim License.

if exists("g:loaded_sessions")
    finish
endif
let g:loaded_sessions=1

if !exists('g:sessions_code_path')
  let g:sessions_code_path = '$HOME/code'
endif

if !exists('g:sessions_path')
  let g:sessions_path = '$HOME/.vim/sessions'
endif

if !isdirectory(expand(g:sessions_path))
  call mkdir(expand(g:sessions_path))
endif

function s:ProjectName()
  return matchlist(getcwd(), expand(g:sessions_code_path) . '/\(\f\+\)$')
endfunction

function s:SessionName()
  return expand(g:sessions_path) . '/' . <SID>ProjectName()[1]. '.vim'
endfunction

function s:IsProject()
  return <SID>ProjectName() != []
endfunction

function! LoadSession()
  if <SID>IsProject() && argc() == 0
    silent! execute 'source ' . <SID>SessionName()
  endif
endfunction

function s:IsException()
  return match(expand('%'), '\.git\/COMMIT') >= 0  " Git commit message
endfunction

function! SaveSession()
  if <SID>IsProject() && !<SID>IsException()
    execute 'mksession! ' . <SID>SessionName()
  endif
endfunction

autocmd VimEnter * call LoadSession()
autocmd VimLeave * call SaveSession()
