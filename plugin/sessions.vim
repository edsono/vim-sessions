" sessions.vim: Sessions in project dir are auto saved
" Last modified: 2010-05-14
" Version:       0.1
" Author:        Edson César <edsono@gmail.com>
" Maintainers:   Edson César <edsono@gmail.com>,
"                Hallison Batista <hallison.batista@gmail.com>
" License:       This script is released under the Vim License.

if exists("g:sessions_loaded")
    finish
endif
let g:sessions_loaded = 1

if !exists("g:sessions_code_path")
  let g:sessions_code_path = expand("$HOME/code")
else
  let g:sessions_code_path = expand(g:sessions_code_path)
endif

if !exists("g:sessions_path")
  let g:sessions_path = expand("$HOME/.vim/sessions")
else
  let g:sessions_path = expand(g:sessions_path)
endif

if !isdirectory(g:sessions_path)
  echomsg "Creating sessions path in " . g:sessions_path . " ..."
  call mkdir(g:sessions_path)
endif

let s:project_path = ""
let s:project_name = ""
let s:session_file = ""

function s:InitProject()
  for path in split(g:sessions_code_path, ':')
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
    echomsg "Initializing session from " . g:sessions_path . " ..."
    let s:session_file = g:sessions_path . "/" . s:project_name . ".vim"
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
  return match(expand("%"), "\.git\/COMMIT") >= 0  " Git commit message
endfunction

function! SaveSession()
  if <SID>IsProject() && !<SID>IsException()
    "echo "Saving session " . s:session_file . " ..." | normal "<cr>"
    silent! execute "mksession! " . s:session_file
  endif
endfunction

autocmd VimEnter * call LoadSession()
autocmd VimLeave,BufWritePost * call SaveSession()
