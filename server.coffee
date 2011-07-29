argv      = require('optimist').argv
port      = argv.port || argv.p || 3000
files     = argv._
env       = process.env.NODE_ENV || 'development'

Tail      = require('tail').Tail
express   = require('express')
socketIo  = require('socket.io')


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
files.forEach (file) ->
  tail = new Tail(file)
  tail.on 'line', (data) ->
    io.sockets.emit('newlog', {text: data})


console.log("Tailf started, listening on port #{app.address().port}")