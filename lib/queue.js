(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.Queue = (function() {
    Queue.prototype.connection = null;
    Queue.prototype.messageReceived = null;
    Queue.prototype.isDirect = function() {
      return this.type === "direct";
    };
    function Queue(url, type, exchangeName, queueName) {
      this.url = url != null ? url : "";
      this.type = type != null ? type : "direct";
      this.exchangeName = exchangeName != null ? exchangeName : "amq.direct";
      this.queueName = queueName != null ? queueName : "queue";
      this.close = __bind(this.close, this);
      this.open = __bind(this.open, this);
      this._openDirect = __bind(this._openDirect, this);
      this.isDirect = __bind(this.isDirect, this);
    }
    Queue.prototype._openDirect = function(cb) {
      console.log("Calling Open Direct with Queue Name: " + this.queueName + ", Type: " + this.type + " for url " + this.url);
      return this.connection.addListener("ready", __bind(function() {
        console.log("Connection ready");
        console.log("Opening exchange " + this.exchangeName + " as " + this.type);
        this.exchange = this.connection.exchange(this.exchangeName, {
          type: this.type
        });
        console.log("Opening queue " + this.queueName);
        this.queue = this.connection.queue(this.queueName);
        console.log("Binding queue to " + this.exchangeName + " exchange");
        this.queue.bind(this.exchangeName, "#");
        this.queue.on("queueBindOk", __bind(function() {
          console.log("Queue Bound OK");
          console.log("Subscribing to queue now");
          this.queue.subscribe(__bind(function(m, headers, deliveryInfo) {
            if (this.messageReceived) {
              return this.messageReceived(this, m, headers, deliveryInfo);
            }
          }, this));
          return cb(null);
        }, this));
        return this.exchange.publish("", "Hello");
      }, this));
    };
    Queue.prototype.open = function(cb) {
      this.connection = amqp.createConnection({
        url: this.url
      });
      if (this.isDirect()) {
        return this._openDirect(cb);
      } else {
        return cb(new Error("Only direct queues supported at this time, sorry"));
      }
    };
    Queue.prototype.close = function(cb) {
      this.messageReceived = null;
      this.connection.end();
      return this.connection = null;
    };
    return Queue;
  })();
}).call(this);
