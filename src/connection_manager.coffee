amqp = require "amqp"

# Manages all connections used.
class exports.ConnectionManager

  constructor: () ->
    @connections = {}
    
  # Obtains a connection for a given url, and invokes the callback with err, connection
  getConnection: (url,cb) =>
    unless @connections[url]
      @connections[url] = 
        isReady : false
        onReadyCb : []
        queueCount : 0

      connection = amqp.createConnection url: url
      @connections[url].connection = connection

      connection.addListener "ready", =>
        @connections[url].isReady = true
        for cx in @connections[url].onReadyCb
          cx(null,@connections[url].connection)
        @connections[url].onReadyCb = []
        
    @connections[url].queueCount++
    if @connections[url].isReady
      cb(null,@connections[url].connection)
    else
      @connections[url].onReadyCb.push cb
    