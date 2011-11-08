Hook = require('hook.io').Hook
util = require 'util'
colors = require 'colors'
path = require 'path'
fs = require "fs"
amqp = require "amqp"
QueueListener = require("./queue_listener").QueueListener
QueuePublisher = require("./queue_publisher").QueuePublisher
ConnectionManager = require("./connection_manager").ConnectionManager

require('pkginfo')(module,'version','hook')
  
class exports.AmqpListener extends Hook
  connectionManager : new ConnectionManager()
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
      
  
  _queueMessageReceived :(queue,m, headers, deliveryInfo) =>
    
    
    @emit "amqp-listener::received",
      queue : queue.queueName
      message : m
      contentType: deliveryInfo.contentType
      deliveryMode :deliveryInfo.deliveryMode
      deliveryTag: deliveryInfo.deliveryTag
      redelivered: deliveryInfo.redelivered
      exchange : deliveryInfo.exchange
      routingKey : deliveryInfo.routingKey
      consumerTag : deliveryInfo.consumerTag
      
    console.log "HELLO: #{deliveryInfo.routingKey}  Headers: #{JSON.stringify(headers)} Message: #{m} DELIVER: #{JSON.stringify(deliveryInfo)}"
  
  _add : (data) =>
    @connectionManager.getConnection data.connection, (err,amqpConnection) =>
      return cb(err) if err
      
      
      listener = new QueueListener amqpConnection,data.queueName,@_queueMessageReceived
      listener.open (err) =>
        if err
          @emit "amqp-listener::error", 
            data : data,
            error : err
        else
          @queues.push(listener)
      
      ###
      publisher = new QueuePublisher(amqpConnection,data.queueName,data.exchangeName,data.exchangeType)
      publisher.open (err) =>
        if(err)
          console.log "Publisher open callback with error #{err}"
        else
          publisher.publishAsJson frankSays : "YEAH, this is a message"
      ### 
  _remove : (data) =>
    # Implement remove

