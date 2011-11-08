amqp = require "amqp"

# Manages all connections used.
# 
# WARNING THIS CODE IS RIDDLED WITH ERRORS AND NEEDS FIXING.
class exports.ConnectionManager
  connections: {}

  constructor: () ->

  # Obtains a connection for a given url, and invokes the callback with err, connection
  getConnection: (url,cb) =>
    if @connections[url]
      cb(null,@connections[url].connection)
    else
      connection = amqp.createConnection url: url
      connection.addListener "ready", =>
        @connections[url] = {}
        @connections[url].connection = connection
        cb(null,@connections[url].connection)
    