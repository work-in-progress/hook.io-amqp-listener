amqp = require "amqp"

# This is a helper class used for testing and not driving me insane.
# Usage is simple: You create an instance and then call open. Once opened you can publish.
class exports.QueuePublisher
    
  # exchangeName and exchangeType are willfully ignored for now.
  constructor: (@connection,@queueName,@exchangeName = null,@exchangeType = "direct") ->

  # Opens the queue (creates it if it does not exist as durable and autoDelete)
  # Right now exchange name and type are ignored, and don't even bug me about it. This stuff
  # already wasted too much of my time.
  open: (cb) =>
    console.log "Opening exchange #{if @exchangeName then @exchangeName else '(AMQP default)'} as #{@exchangeType}"
    
    queueOpts = 
      durable : true
      autoDelete : false
      
    @queue = @connection.queue @queueName,queueOpts
    cb(null)
      
  publish: (msg,options) =>
    @connection.publish @queueName,msg,options
  
  publishAsJson:(obj,options) =>
    options = {} unless options
    options.contentType = "application/json"
    @publish JSON.stringify(obj),options