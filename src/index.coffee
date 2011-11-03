Hook = require('hook.io').Hook
util = require 'util'
colors = require 'colors'
path = require 'path'
fs = require "fs"
spawn = require("child_process").spawn

require('pkginfo')(module,'version','hook')
  
AmqpListener = exports.AmqpListener = (options) ->
  self = @
  Hook.call self, options
  
  self.on "hook::ready", ->  
  
    self.on "amqp-listener::compress", (data)->
      self._compress(data)

    self.on "amqp-listener::uncompress", (data)->
      self._uncompress(data)
      
    for compress in (self.compresss || [])
      self.emit "amqp-listener::compress",
        source : compress.source
        target : compress.target
        mode : compress.mode

    for uncompress in (self.uncompresss || [])
      self.emit "amqp-listener::uncompress",
        source : uncompress.source
        target : uncompress.target
    
util.inherits AmqpListener, Hook

AmqpListener.prototype._runCommand = (cmd,args,eventName,data) ->
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

AmqpListener.prototype._compress = (data) ->
  console.log "Compressing #{data.source} to #{data.target}".cyan

  data.mode = 'gzip' unless data.mode == 'bzip2'
  
  data.target = path.normalize data.target
  if data.mode == 'gzip'
    @_runCommand "gzip",[ "-c", data.source ],"amqp-listener::compress-complete",data
  else
    @_runCommand "bzip2",[ "-c", data.source ],"amqp-listener::compress-complete",data    

      
AmqpListener.prototype._uncompress = (data) ->
  console.log "Uncompress for #{data.source}".cyan
  
  data.mode = 'gzip' unless data.mode == 'bzip2'
  
  data.target = path.normalize data.target
  
  if data.mode == 'gzip'
    @_runCommand "gunzip",[ "-c", data.source ],"amqp-listener::uncompress-complete",data
  else
    @_runCommand "bzip2",[ "-dc", data.source ],"amqp-listener::uncompress-complete",data    
  
