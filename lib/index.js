(function() {
  var Hook, Queue, amqp, colors, fs, path, util;
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
  amqp = require("amqp");
  Queue = require("./queue").Queue;
  require('pkginfo')(module, 'version', 'hook');
  exports.AmqpListener = (function() {
    __extends(AmqpListener, Hook);
    AmqpListener.prototype.queues = [];
    function AmqpListener(options) {
      this._remove = __bind(this._remove, this);
      this._add = __bind(this._add, this);
      var self;
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
    AmqpListener.prototype._queueMessageReceived = function(queue, m, headers, deliveryInfo) {
      return console.log("HELLO: " + deliveryInfo.routingKey + "  Headers: " + headers + " Message: " + m);
    };
    AmqpListener.prototype._add = function(data) {
      var queue;
      queue = new Queue(data.connection, data.exchangeType, data.exchangeName, data.queueName);
      queue.messageReceived = this._queueMessageReceived;
      return queue.open(__bind(function(err) {
        if (err) {
          return this.emit("amqp-listener::error", {
            data: data,
            error: err
          });
        } else {
          return this.queues.push(queue);
        }
      }, this));
    };
    AmqpListener.prototype._remove = function(data) {};
    return AmqpListener;
  })();
}).call(this);
