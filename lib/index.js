(function() {
  var Hook, colors, fs, path, util;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Hook = require('hook.io').Hook;
  util = require('util');
  colors = require('colors');
  path = require('path');
  fs = require("fs");
  require('pkginfo')(module, 'version', 'hook');
  exports.AmqpListener = (function() {
    __extends(AmqpListener, Hook);
    function AmqpListener(options) {
      this._add = __bind(this._add, this);
      this._runCommand = __bind(this._runCommand, this);      var self;
      self = this;
      Hook.call(self, options);
      self.on("hook::ready", function() {
        var queue, _i, _len, _ref, _results;
        self.on("amqp-listener::add", function(data) {
          return self._add(data);
        });
        self.on("amqp-listener::remove", function(data) {
          return self._remove(data);
        });
        _ref = self.queues || [];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          queue = _ref[_i];
          _results.push(self.emit("amqp-listener::add", queue));
        }
        return _results;
      });
    }
    AmqpListener.prototype._runCommand = function(cmd, args, eventName, data) {
      /*
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
          */
    };
    AmqpListener.prototype._add = function(data) {
      /*
              data.mode = 'gzip' unless data.mode == 'bzip2'
        
              data.target = path.normalize data.target
              if data.mode == 'gzip'
                @_runCommand "gzip",[ "-c", data.source ],"amqp-listener::compress-complete",data
              else
                @_runCommand "bzip2",[ "-c", data.source ],"amqp-listener::compress-complete",data    
          */
    };
    AmqpListener.prototype._remove = function(data) {
      /*
              console.log "Uncompress for #{data.source}".cyan
        
              data.mode = 'gzip' unless data.mode == 'bzip2'
        
              data.target = path.normalize data.target
        
              if data.mode == 'gzip'
                @_runCommand "gunzip",[ "-c", data.source ],"amqp-listener::uncompress-complete",data
              else
                @_runCommand "bzip2",[ "-dc", data.source ],"amqp-listener::uncompress-complete",data    
          */
    };
    return AmqpListener;
  })();
}).call(this);
