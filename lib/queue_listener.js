(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.QueueListener = (function() {
    QueueListener.prototype.messageReceived = null;
    function QueueListener(connection, queueName, messageReceived) {
      this.connection = connection;
      this.queueName = queueName;
      this.messageReceived = messageReceived;
      this.close = __bind(this.close, this);
      this.open = __bind(this.open, this);
    }
    QueueListener.prototype.open = function(cb) {
      var queueOpts;
      queueOpts = {
        durable: true,
        autoDelete: false
      };
      this.queue = this.connection.queue(this.queueName, queueOpts);
      this.queue.subscribe(__bind(function(m, headers, deliveryInfo) {
        if (this.messageReceived) {
          return this.messageReceived(this, m, headers, deliveryInfo);
        }
      }, this));
      return cb(null);
    };
    QueueListener.prototype.close = function(cb) {
      return this.messageReceived = null;
    };
    return QueueListener;
  })();
}).call(this);
