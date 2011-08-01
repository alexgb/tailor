socket = io.connect(location.origin)

socket.on 'newlog', (data) -> 
  row = $('<pre>').attr('class', 'row').prependTo('#tailor').text(data.text)
  row.attr('style', 'display:none; opacity: 0;')
  row.slideDown(200).animate({opacity: 1}, 200)
  