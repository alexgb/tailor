argv      = require('optimist').argv
port      = argv.port || argv.p || 3000
files     = argv._
env       = process.env.NODE_ENV || 'development'

Tail      = require('tail').Tail
express   = require('express')
socketIo  = require('socket.io')
Color     = require('color')


# prepare files
files = files.map (file, index) ->
  path:   file
  color:  Color().hsv(360/files.length * index, 70, 80)

# app
app = express.createServer()

# configure
app.configure () ->
  app.set('views', "#{__dirname}/server/views")
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.compiler(src: "#{__dirname}/public", enable: ['less']))
  app.use(express.compiler(src: "#{__dirname}/client", dest: "#{__dirname}/public", enable: ['coffeescript']))
  app.use(express.static("#{__dirname}/public"))
  
app.configure 'development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', () ->
  app.use(express.errorHandler) 
  
  
# routes
app.get '/', (req, res) ->
  res.render 'index', files: files


# listen
app.listen(port)


# socket
io = socketIo.listen(app)


# tail
files.forEach (file, fileIndex) ->
  tail = new Tail(file.path)
  tail.on 'line', (data) ->
    io.sockets.emit('newlog', {text: data, time: new Date(), fileIndex: fileIndex, color: file.color.hexString()})


console.log("Tailor started, listening on port #{app.address().port}")