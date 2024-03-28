function! Call_api(command) abort
  if empty(a:command)
    echoerr 'error: command name is empty'
    return
  endif

  if executable('curl')
    let cmd = 'curl -H "Content-Type: application/json" -d "{\"contents\":[{\"parts\":[{\"text\":\"crate manpage about '.a:command.' of Clanguage and translate japanese\"}]}]}" -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key='.g:API_KEY.'"'
    let result = json_decode(system(cmd))
    if result['code'] == 200
      echo result['message']
    else
      echoerr result
    endif
  else
    echo 'error: curl is not installed'
  endif
endfunction

command! -nargs=1 Mang call Call_api(<f-args>)
