amqp = require "amqp"

class exports.QueueListener
  messageReceived : null
    
  constructor: (@connection,@queueName,@messageReceived) ->

  # Opens the queue (or at least tries to)
  open: (cb) =>
    
    queueOpts = 
      durable : true
      autoDelete : false
      
    @queue = @connection.queue @queueName,queueOpts
    
    @queue.subscribe (m, headers, deliveryInfo) =>
      if @messageReceived
        @messageReceived(@,m,headers,deliveryInfo)
    cb(null)
    
    #console.log "Opening exchange #{@exchangeName} as #{@type}"
    #@exchange = @connection.exchange @exchangeName,type: @type
    
    #console.log "Opening queue #{@queueName} for #{@connection.serverProperties.product}"
    #@queue = @connection.queue @queueName, (err) ->
    #  console.log "Callback called"
      
    #console.log "Binding queue to #{@exchangeName} exchange"
    #@queue.bind @exchangeName,""
    #@queue.bind "#"
    #@queue.on "queueBindOk", =>
    #  console.log "Queue Bound OK"
    #  console.log "Subscribing to queue now"

    
  # Closes the queue. Does nothing if it has not been opened before.
  close: (cb) =>
    @messageReceived = null
    #@connection.end()
    #@connection = null
    