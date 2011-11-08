Hook = require('hook.io').Hook
util = require 'util'
colors = require 'colors'
path = require 'path'
fs = require "fs"
amqp = require "amqp"
Queue = require("./queue").Queue

require('pkginfo')(module,'version','hook')
  
class exports.AmqpListener extends Hook
  queues: []
  
  constructor: (options) ->
    self = @
    Hook.call self, options
  
    self.on "hook::ready", ->  
  
      self.on "amqp-listener::add", (data)->
        self._add(data)

      self.on "amqp-listener::remove", (data)->
        self._remove(data)
      
      for queue in (self.queues || [])
        self.emit "amqp-listener::add", queue
      
  
  _queueMessageReceived :(queue,m, headers, deliveryInfo) ->
    console.log "HELLO: #{deliveryInfo.routingKey}  Headers: #{headers} Message: #{m}"
  
  _add : (data) =>
    queue = new Queue(data.connection,data.exchangeType,data.exchangeName,data.queueName)
    queue.messageReceived = @_queueMessageReceived
    queue.open (err) =>
      if err
        @emit "amqp-listener::error", 
          data : data,
          error : err
      else
        @queues.push(queue)
        
  _remove : (data) =>


