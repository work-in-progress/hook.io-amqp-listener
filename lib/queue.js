(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.Queue = (function() {
    Queue.prototype.connection = null;
    Queue.prototype.isDirect = function() {
      return this.type === "direct";
    };
    function Queue(url, type, exchangeName, queueName) {
      this.url = url != null ? url : "";
      this.type = type != null ? type : "direct";
      this.exchangeName = exchangeName != null ? exchangeName : "node-conn-share1";
      this.queueName = queueName != null ? queueName : "node-q1";
      this.close = __bind(this.close, this);
      this.open = __bind(this.open, this);
      this._openDirect = __bind(this._openDirect, this);
      this.isDirect = __bind(this.isDirect, this);
    }
    Queue.prototype._openDirect = function(cb) {
      return this.connection.addListener("ready", __bind(function() {
        console.log("CONNECTION: " + this.connection + " EXCHANGE NAME: " + this.exchangeName + " EXCHANGE TYPE: " + this.type);
        this.exchange = this.connection.exchange(this.exchangeName, {
          type: this.type
        });
        console.log("A");
        return this.queue = this.connection.queue(this.queueName, __bind(function() {
          console.log("B");
          this.queue.bind(this.exchange, "node-consumer-1");
          console.log("C");
          return this.queue.on("queueBindOk", __bind(function() {
            console.log("D");
            return this.queue.subscribe(__bind(function(m, headers, deliveryInfo) {
              console.log("" + deliveryInfo.routingKey + "  Headers: " + headers);
              return cb(null);
            }, this));
          }, this));
        }, this));
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
      this.connection.end();
      return this.connection = null;
    };
    return Queue;
  })();
}).call(this);
