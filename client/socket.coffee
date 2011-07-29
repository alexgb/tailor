socket = io.connect(location.origin)

socket.on 'newlog', (data) -> 
  el = document.getElementById('tailor-out')
  el.textContent += "#{data.text}\n"
