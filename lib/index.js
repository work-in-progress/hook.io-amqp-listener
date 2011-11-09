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
    function AmqpListener(options) {
      this._add = __bind(this._add, this);
      this._queueMessageReceived = __bind(this._queueMessageReceived, this);      this.connectionManager = new ConnectionManager();
      this.queues = [];
      Hook.call(this, options);
      this.on("amqp-listener::add", __bind(function(data) {
        return this._add(data);
      }, this));
      this.on("hook::ready", __bind(function() {
        var queue, _i, _len, _ref, _results;
        _ref = this.queues || [];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          queue = _ref[_i];
          _results.push(this.emit("amqp-listener::add", queue));
        }
        return _results;
      }, this));
    }
    AmqpListener.prototype._queueMessageReceived = function(queue, m, headers, deliveryInfo) {
      return this.emit("amqp-listener::received", {
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
    return AmqpListener;
  })();
}).call(this);
