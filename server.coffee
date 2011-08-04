opts = require('optimist')
  .usage('Start the Tailor server.\nUsage:  \t$0 [files]\nExample:\t$0 /var/log/*.log')
  .options 'h',
    alias     : 'help'
    boolean   : true
    describe  : 'show this help message'
  .options 'p', 
    alias     : 'port'
    default   : 3030
    describe  : 'port for http server'
  .options 'u', 
    alias     : 'user'
    describe  : 'server basic auth, requires -u'
  .options 'w', 
    alias     : 'password'
    describe  : 'server basic auth, requires -w'

argv = opts.argv

if argv.h
  opts.showHelp()
  process.exit()

port      = argv.p
auth_user = argv.u
auth_pass = argv.w
files     = argv._

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
app.configure () ->
  app.set('views', "#{__dirname}/server/views")
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.compiler(src: "#{__dirname}/public", enable: ['less']))
  app.use(express.compiler(src: "#{__dirname}/client", dest: "#{__dirname}/public", enable: ['coffeescript']))
  app.use(express.static("#{__dirname}/public"))
  if auth_user && auth_pass
    app.use(express.basicAuth (user, pass) ->
      user == auth_user && pass == auth_pass
    ,'Protected Resource')
  app.use(express.errorHandler())

  
# app routes
app.get '/', (req, res) ->
  res.render 'index', files: files


# app listen
app.listen(port)


# socket
io = socketIo.listen(app)
io.configure 'production', () ->
  io.set('log level', 1)

# tail
files.forEach (file, fileIndex) ->
  tail = new Tail(file.path)
  tail.on 'line', (data) ->
    io.sockets.emit('newlog', {text: data, time: new Date(), fileIndex: fileIndex, color: file.color.hexString()})


console.log("Tailor started, listening on port #{app.address().port}")