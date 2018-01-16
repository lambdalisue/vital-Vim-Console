let s:t_string = type('')

function! s:_vital_created(module) abort
  let a:module.prefix = ''
  let a:module.escape_marker =
        \ '=======================================' .
        \ 'Vital.Vim.Console.ESCAPE.' . localtime() .
        \ '======================================='
endfunction

function! s:echo(msg, ...) abort dict
  let hl = get(a:000, 0, 'None')
  let msg = s:_ensure_string(a:msg)
  let msg = s:_assign_prefix(a:msg, self.prefix)
  execute 'echohl' hl
  echo msg
  echohl None
endfunction

function! s:echon(msg, ...) abort dict
  let hl = get(a:000, 0, 'None')
  let msg = s:_ensure_string(a:msg)
  execute 'echohl' hl
  echon msg
  echohl None
endfunction

function! s:echomsg(msg, ...) abort dict
  let hl = get(a:000, 0, 'None')
  let msg = s:_ensure_string(a:msg)
  let msg = s:_assign_prefix(a:msg, self.prefix)
  execute 'echohl' hl
  for line in split(msg, '\r\?\n')
    echomsg line
  endfor
  echohl None
endfunction

function! s:input(hl, msg, ...) abort dict
  let msg = s:_ensure_string(a:msg)
  let msg = s:_assign_prefix(a:msg, self.prefix)
  let text = get(a:000, 0, '')
  if a:0 > 1
    let args = [
          \ type(a:2) == s:t_string
          \   ? a:2
          \   : 'customlist,' . get(a:2, 'name')
          \]
  else
    let args = []
  endif
  execute 'echohl' a:hl
  call inputsave()
  try
    return call('s:_input', [msg, text] + args, self)
  finally
    redraw | echo ''
    echohl None
    call inputrestore()
  endtry
endfunction

function! s:inputlist(hl, textlist) abort dict
  let textlist = map(copy(a:textlist), 's:_ensure_string(v:val)')
  execute 'echohl' a:hl
  call inputsave()
  try
    return inputlist(textlist)
  finally
    redraw | echo ''
    echohl None
    call inputrestore()
  endtry
endfunction

function! s:debug(msg) abort dict
  if !&verbose
    return
  endif
  call self.echomsg(a:msg, 'Comment')
endfunction

function! s:info(msg) abort dict
  let v:statusmsg = s:_ensure_string(a:msg)
  call self.echomsg(a:msg, 'Title')
endfunction

function! s:warn(msg) abort dict
  let v:warningmsg = s:_ensure_string(a:msg)
  call self.echomsg(a:msg, 'WarningMsg')
endfunction

function! s:error(msg) abort dict
  let v:errmsg = s:_ensure_string(a:msg)
  call self.echomsg(a:msg, 'ErrorMsg')
endfunction

function! s:ask(...) abort dict
  let result = call('s:input', ['Question'] + a:000, self)
  redraw
  return result
endfunction

function! s:select(msg, candidates, ...) abort dict
  let canceled = get(a:000, 0, '')
  let candidates = map(
        \ copy(a:candidates),
        \ 'v:key+1 . ''. '' . s:_ensure_string(v:val)'
        \)
  let result = self.inputlist('Question', [a:msg] + candidates)
  redraw
  return result <= 0 || result > len(a:candidates) ? canceled : a:candidates[result-1]
endfunction

function! s:confirm(msg, ...) abort dict
  call inputsave()
  echohl Question
  try
    let default = get(a:000, 0, '')
    if default !~? '^\%(y\%[es]\|n\%[o]\|\)$'
      throw 'vital: Vim.Console: An invalid default value has specified.'
    endif
    let choices = default =~? 'y\%[es]'
          \ ? 'Y[es]/n[o]'
          \ : default =~? 'n\%[o]'
          \   ? 'y[es]/N[o]'
          \   : 'y[es]/n[o]'
    let result = 'invalid'
    let prompt = printf('%s (%s): ', a:msg, choices)
    let completion = 'customlist,' . get(function('s:_confirm_complete'), 'name')
    while result !~? '^\%(y\%[es]\|n\%[o]\)$'
      let result = call('s:_input', [prompt, '', completion], self)
      if type(result) != s:t_string
        redraw | echo ''
        call self.echo('Canceled.', 'WarningMsg')
        return 0
      endif
      let result = empty(result) ? default : result
    endwhile
    redraw | echo ''
    return result =~? 'y\%[es]'
  finally
    echohl None
    call inputrestore()
  endtry
endfunction

function! s:_input(...) abort dict
  try
    execute printf(
          \ 'silent cnoremap <buffer> <Esc> <C-u>%s<CR>',
          \ self.escape_marker,
          \)
    let result = call('input', a:000)
    return result ==# self.escape_marker ? 0 : result
  finally
    silent cunmap <buffer> <Esc>
  endtry
endfunction

function! s:_confirm_complete(arglead, cmdline, cursorpos) abort
  return filter(['yes', 'no'], 'v:val =~# ''^'' . a:arglead')
endfunction

function! s:_ensure_string(x) abort
  return type(a:x) == s:t_string ? a:x : string(a:x)
endfunction

function! s:_assign_prefix(msg, prefix) abort
  return join(map(split(a:msg, '\r\?\n'), 'a:prefix . v:val'), "\n")
endfunction
