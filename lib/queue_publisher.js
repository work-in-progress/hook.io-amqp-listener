(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.QueuePublisher = (function() {
    function QueuePublisher(connection, queueName, exchangeName, exchangeType) {
      this.connection = connection;
      this.queueName = queueName;
      this.exchangeName = exchangeName != null ? exchangeName : null;
      this.exchangeType = exchangeType != null ? exchangeType : "direct";
      this.publishAsJson = __bind(this.publishAsJson, this);
      this.publish = __bind(this.publish, this);
      this.open = __bind(this.open, this);
    }
    QueuePublisher.prototype.open = function(cb) {
      var queueOpts;
      console.log("Opening exchange " + (this.exchangeName ? this.exchangeName : '(AMQP default)') + " as " + this.exchangeType);
      queueOpts = {
        durable: true,
        autoDelete: false
      };
      this.queue = this.connection.queue(this.queueName, queueOpts);
      return cb(null);
    };
    QueuePublisher.prototype.publish = function(msg, options) {
      return this.connection.publish(this.queueName, msg, options);
    };
    QueuePublisher.prototype.publishAsJson = function(obj, options) {
      if (!options) {
        options = {};
      }
      options.contentType = "application/json";
      return this.publish(JSON.stringify(obj), options);
    };
    return QueuePublisher;
  })();
}).call(this);
