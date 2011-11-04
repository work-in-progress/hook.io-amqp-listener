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
      
  _runCommand : (cmd,args,eventName,data) =>
    
    ###
        fd = fs.openSync data.target, "w", 0644

        zip = spawn(cmd,args)

        zip.stdout.on "data", (data) =>
          fs.writeSync fd, data, 0, data.length, null

        zip.stderr.on "data", (data) =>
          console.log "ERROR: #{data}"
  
        zip.on "exit", (code) =>
          fs.closeSync fd

          #console.log "EXIT #{code}"
          if code != 0  
            try
              fs.unlinkSync data.target  # cleanup
            catch ignore
      
            @emit "amqp-listener::error", 
              source: data.source
              target: data.target
              mode: data.mode
              code: code
          else    
            @emit eventName, 
              source: data.source
              target: data.target
              mode: data.mode
    ###
  
  _add : (data) =>
    queue = new Queue(data.connection,data.exchangeType,data.exchangeName,data.queueName)
    queue.open (err) =>
      if err
        @emit "amqp-listener::error", 
          data : data,
          error : err
      else
        @queues.push(queue)
        
    ###
        data.mode = 'gzip' unless data.mode == 'bzip2'
  
        data.target = path.normalize data.target
        if data.mode == 'gzip'
          @_runCommand "gzip",[ "-c", data.source ],"amqp-listener::compress-complete",data
        else
          @_runCommand "bzip2",[ "-c", data.source ],"amqp-listener::compress-complete",data    
    ###
  _remove : (data) =>

    ###
        console.log "Uncompress for #{data.source}".cyan
  
        data.mode = 'gzip' unless data.mode == 'bzip2'
  
        data.target = path.normalize data.target
  
        if data.mode == 'gzip'
          @_runCommand "gunzip",[ "-c", data.source ],"amqp-listener::uncompress-complete",data
        else
          @_runCommand "bzip2",[ "-dc", data.source ],"amqp-listener::uncompress-complete",data    
    ###

