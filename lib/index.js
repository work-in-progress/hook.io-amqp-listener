(function() {
  var ConnectionManager, Hook, QueueListener, QueuePublisher, amqp, colors, fs, path, util;
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
  QueueListener = require("./queue_listener").QueueListener;
  QueuePublisher = require("./queue_publisher").QueuePublisher;
  ConnectionManager = require("./connection_manager").ConnectionManager;
  require('pkginfo')(module, 'version', 'hook');
  exports.AmqpListener = (function() {
    __extends(AmqpListener, Hook);
    AmqpListener.prototype.connectionManager = new ConnectionManager();
    AmqpListener.prototype.queues = [];
    function AmqpListener(options) {
      this._remove = __bind(this._remove, this);
      this._add = __bind(this._add, this);
      this._queueMessageReceived = __bind(this._queueMessageReceived, this);
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
      this.emit("amqp-listener::received", {
        queue: queue.queueName,
        message: m,
        contentType: deliveryInfo.contentType,
        deliveryMode: deliveryInfo.deliveryMode,
        deliveryTag: deliveryInfo.deliveryTag,
        redelivered: deliveryInfo.redelivered,
        exchange: deliveryInfo.exchange,
        routingKey: deliveryInfo.routingKey,
        consumerTag: deliveryInfo.consumerTag
      });
      return console.log("HELLO: " + deliveryInfo.routingKey + "  Headers: " + (JSON.stringify(headers)) + " Message: " + m + " DELIVER: " + (JSON.stringify(deliveryInfo)));
    };
    AmqpListener.prototype._add = function(data) {
      return this.connectionManager.getConnection(data.connection, __bind(function(err, amqpConnection) {
        var listener;
        if (err) {
          return cb(err);
        }
        listener = new QueueListener(amqpConnection, data.queueName, this._queueMessageReceived);
        return listener.open(__bind(function(err) {
          if (err) {
            return this.emit("amqp-listener::error", {
              data: data,
              error: err
            });
          } else {
            return this.queues.push(listener);
          }
        }, this));
        /*
              publisher = new QueuePublisher(amqpConnection,data.queueName,data.exchangeName,data.exchangeType)
              publisher.open (err) =>
                if(err)
                  console.log "Publisher open callback with error #{err}"
                else
                  publisher.publishAsJson frankSays : "YEAH, this is a message"
              */
      }, this));
    };
    AmqpListener.prototype._remove = function(data) {};
    return AmqpListener;
  })();
}).call(this);
