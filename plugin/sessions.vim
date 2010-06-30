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

function s:ProjectsPath()
  "@echomsg "Getting projects path ..."
  if !exists("g:sessions_project_path")
    "@echomsg "Setting default sessions project path ..."
    let g:sessions_project_path = "$HOME/code"
  endif
  return expand(g:sessions_project_path)
endfunction

function s:SessionsPath()
  "@echomsg "Getting sessions path ..."
  if !exists("g:sessions_path")
    "@echomsg "Setting default sessions path ..."
    let g:sessions_path = "$HOME/.vim/sessions"
  endif
  return expand(g:sessions_path)
endfunction

if !isdirectory(<SID>SessionsPath())
  "@echomsg "Creating sessions path in " . <SID>SessionsPath() . " ..."
  call mkdir(<SID>SessionsPath())
endif

function s:ProjectAttributes(index)
  "@echomsg "Getting project attribute ..."
  for path in split(<SID>ProjectsPath(), ':')
    let matches = matchlist(getcwd(), path . '/\(\(\w\|\-\)\+\)')
    if !empty(matches)
      return matches[a:index]
    else
      continue
    endif
  endfor
  return ""
endfunction

function s:ProjectPath() 
  "@echomsg "Getting project path ..."
  return <SID>ProjectAttributes(0)
endfunction

function s:ProjectName()
  "@echomsg "Getting project name ..."
  return <SID>ProjectAttributes(1)
endfunction

function s:IsProject()
  "@echomsg "Checking project in current directory ..."
  return !empty(<SID>ProjectName()) && !empty(<SID>ProjectPath())
endfunction

function s:ProjectSessionFile()
  "@echomsg "Getting project session file ..."
  if <SID>IsProject()
    return <SID>SessionsPath() . "/" . <SID>ProjectName() . ".vim"
  endif
  return ""
endfunction

function s:IsProjectPath()
  return !empty(<SID>ProjectPath())
endfunction

function s:LoadSession()
  if <SID>IsProjectPath() && argc() == 0
    "@echomsg "Loading session " . <SID>ProjectSessionFile() . " ..."
    silent! execute "source " . <SID>ProjectSessionFile()
  endif
endfunction

""@echomsg "Initializing session from " . <SID>SessionsPath() . " ..."

function s:IsNotException()
  return !(match(expand("%"), "\.git\/COMMIT") >= 0) " Git commit message
endfunction

function s:SaveSession()
  if <SID>IsProjectPath() && <SID>IsNotException()
    "@echomsg "Saving session file " . <SID>ProjectSessionFile() . " ..."
    silent! execute "mksession! " . <SID>ProjectSessionFile()
  endif
endfunction

function! VimSession(option)
  if a:option == "open"
    call <SID>LoadSession()
  elseif a:option == "save"
    call <SID>SaveSession()
  endif
  "@echomsg "Saida de VimSession com" . option
endfunction

autocmd VimEnter              * :call VimSession("open")
autocmd VimLeave,BufWritePost * :call VimSession("save")

