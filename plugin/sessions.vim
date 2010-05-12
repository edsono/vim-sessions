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
  " echomsg "Creating sessions path in " . expand(g:sessions_path) . ' ...'
  call mkdir(expand(g:sessions_path))
endif

function s:ProjectName()
  for path in split(expand(g:sessions_code_path), ':')
    let matches = matchlist(getcwd(), path . '/\(\f\+\)$')
    " echomsg "Recover project name " . path . " ..."
    if ! empty(matches)
      return matches
    else
      continue
    endif
  endfor
  return []
endfunction

function s:SessionName()
  " echomsg "Recover session name ..."
  return expand(g:sessions_path) . '/' . <SID>ProjectName()[1]. '.vim'
endfunction

function s:IsProject()
  " echomsg "Checking project ..."
  return <SID>ProjectName() != []
endfunction

function! LoadSession()
  " echomsg "Loading session ..."
  if <SID>IsProject() && argc() == 0
    " echomsg "Found session " . <SID>SessionName() . " ..."
    silent! execute 'source ' . <SID>SessionName()
  endif
endfunction

function s:IsException()
  return match(expand('%'), '\.git\/COMMIT') >= 0  " Git commit message
endfunction

function! SaveSession()
  " echomsg "Saving session ..."
  if <SID>IsProject() && !<SID>IsException()
    execute 'mksession! ' . <SID>SessionName()
  endif
endfunction

autocmd VimEnter * call LoadSession()
autocmd VimLeave * call SaveSession()
