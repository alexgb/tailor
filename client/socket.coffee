socket = io.connect(location.origin)

# setup socket listener
socket.on 'newlog', (data) -> 
  tpl = $('#log-row-template').text()
  row = $(compile(tpl, data))
  row.find('.margin pre').data(time: data.time).each (i, el) ->
    drawRelativeTime(el);
  
  row.prependTo('#tailor')
  row.attr('style', 'display:none; opacity: 0; background-color:'+data.color+';')
  row.slideDown(200).animate({opacity: 1}, 200)

# draw relative time for el
drawRelativeTime = (el) ->
  $(el).text(relativeDate(Date.parse($(el).data('time'))))


# template compilation helper
compile = (tpl, data) ->
  matches = tpl.match(/{{(\w+)}}/g)
  
  for m in matches
    key = m.match(/\w+/)[0]
    tpl = tpl.replace(m, data[key])
    
  tpl
  

# adjust relative time labels
window.setInterval(() -> 
  $('.row .margin pre').each (i, el) ->
    drawRelativeTime(el);
, 1000)