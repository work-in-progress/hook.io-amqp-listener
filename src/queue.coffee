amqp = require "amqp"

class exports.Queue
  connection: null

  isDirect:() =>
    @type == "direct"
    
  constructor: (@url = "",@type = "direct",@exchangeName = "node-conn-share1",@queueName = "node-q1") ->
    
  # TODO : Error Handling
  _openDirect: (cb) =>
    @connection.addListener "ready", =>
      console.log "CONNECTION: #{@connection} EXCHANGE NAME: #{@exchangeName} EXCHANGE TYPE: #{@type}"
      @exchange = @connection.exchange @exchangeName,type: @type
      console.log "A"
      @queue = @connection.queue @queueName, =>
         console.log "B"
         @queue.bind @exchange, "node-consumer-1"
         console.log "C"
         @queue.on "queueBindOk", =>
           console.log "D"
           @queue.subscribe (m, headers, deliveryInfo) =>
            console.log "#{deliveryInfo.routingKey}  Headers: #{headers}"
            cb(null)
 
     
  # Opens the queue (or at least tries to)
  open: (cb) =>
    @connection = amqp.createConnection url: @url
    if @isDirect()
      @_openDirect(cb)
    else
      cb new Error("Only direct queues supported at this time, sorry")
    
  # Closes the queue. Does nothing if it has not been opened before.
  close: (cb) =>
    @connection.end()
    @connection = null
    