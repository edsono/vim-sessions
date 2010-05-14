" sessions.vim: Sessions in project dir are auto saved
" Last modified: 2010-05-13
" Version:       0.1
" Maintainer:    Edson César <edsono@gmail.com>
" License:       This script is released under the Vim License.

if exists("g:sessions_loaded")
    finish
endif
let g:sessions_loaded = 1

if !exists("g:sessions_code_path")
  let g:sessions_code_path = "$HOME/code"
endif

if !exists("g:sessions_path")
  let g:sessions_path = "$HOME/.vim/sessions"
endif

if !isdirectory(expand(g:sessions_path))
  echomsg "Creating sessions path in " . expand(g:sessions_path) . " ..."
  call mkdir(expand(g:sessions_path))
endif

let s:project_path = ""
let s:project_name = ""
let s:session_file = ""

function s:InitProject()
  for path in split(expand(g:sessions_code_path), ':')
    let matches = matchlist(getcwd(), path . '/\(\(\w\|\-\)\+\)')
    if ! empty(matches)
      echomsg "Initializing project placed in " . path . " ..."
      let s:project_path = matches[0]
      let s:project_name = matches[1]
      return 1
    else
      continue
    endif
  endfor
  return 0
endfunction

function s:IsProject()
  return !empty(s:project_name) && !empty(s:session_file)
endfunction

function s:InitSession()
  if <SID>InitProject()
    echomsg "Initializing session from " . expand(g:sessions_path) . " ..."
    let s:session_file = expand(g:sessions_path) . "/" . s:project_name . ".vim"
    return 1
  endif
  return 0
endfunction

function! LoadSession()
  if <SID>InitSession() && argc() == 0
    echomsg "Loading session " . s:session_file . " ..."
    if argv(0) == s:project_path
      echomsg "Changing to directory " . s:project_path . " ..."
      cd s:project_path
    endif
    silent! execute "source " . s:session_file
  endif
endfunction

function s:IsException()
  return match(expand('%'), '\.git\/COMMIT') >= 0  " Git commit message
endfunction

function! SaveSession()
  if <SID>IsProject() && !<SID>IsException()
    echo "Saving session " . s:session_file . " ..."
    silent! execute 'mksession! ' . s:session_file
  endif
endfunction

autocmd VimEnter * call LoadSession()
autocmd VimLeave * call SaveSession()
