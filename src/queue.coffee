amqp = require "amqp"

class exports.Queue
  connection: null
  messageReceived : null

  isDirect:() =>
    @type == "direct"
    
  constructor: (@url = "",@type = "direct",@exchangeName = "amq.direct",@queueName = "queue") ->
    
  # TODO : Error Handling
  _openDirect: (cb) =>
    console.log "Calling Open Direct with Queue Name: #{@queueName}, Type: #{@type} for url #{@url}"
    @connection.addListener "ready", =>
      console.log "Connection ready"
      
      console.log "Opening exchange #{@exchangeName} as #{@type}"
      @exchange = @connection.exchange @exchangeName,type: @type
      
      console.log "Opening queue #{@queueName}"
      @queue = @connection.queue @queueName

      console.log "Binding queue to #{@exchangeName} exchange"
      @queue.bind @exchangeName,"#"
      
      @queue.on "queueBindOk", =>
        console.log "Queue Bound OK"
        console.log "Subscribing to queue now"
        @queue.subscribe (m, headers, deliveryInfo) =>
          console.log "Received a message"
            if @messageReceived
              @messageReceived(@,m,headers,deliveryInfo)
        cb(null)
 
      @exchange.publish "","Hello" 
     
  # Opens the queue (or at least tries to)
  open: (cb) =>
    @connection = amqp.createConnection url: @url
    if @isDirect()
      @_openDirect(cb)
    else
      cb new Error("Only direct queues supported at this time, sorry")
    
  # Closes the queue. Does nothing if it has not been opened before.
  close: (cb) =>
    @messageReceived = null
    @connection.end()
    @connection = null
    