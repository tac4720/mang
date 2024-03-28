
function! Call_api_interactively(command) abort
  if empty(a:command)
    echoerr 'error: command name is empty'
    return
  endif

  if !executable('curl')
    echoerr 'error: curl is not installed'
    return
  endif

  if empty(g:API_KEY)
    echoerr 'error: API_KEY is not set'
    return
  endif

  let cmd = 'curl -s -H "Content-Type: application/json" -d "{\"contents\":[{\"parts\":[{\"text\":\"crate manpage about '.a:command.' of Clanguage and translate japanese\"}]}]}" -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='.g:API_KEY.'"'
  let result = system(cmd)
  if v:shell_error
    echoerr 'error: ' . result
    return
  endif

  " 新しいバッファを作成して、APIの返答を表示
  enew
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nowrap
  setlocal nonumber
  setlocal nolist
  setlocal modifiable
  setlocal nomodified
  call append(0, split(result, '\n'))
  call setline(1, 'Result for command "' . a:command . '":')
endfunction

" コマンド "Mang" を定義して、APIにリクエストを送信して結果を表示
command! -nargs=1 Mang call Call_api_interactively(<f-args>)