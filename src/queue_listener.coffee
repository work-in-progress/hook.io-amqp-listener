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

  # Currently unused.
  # Basically just removes the messageReceived callback.
  close: (cb) =>
    @messageReceived = null
    