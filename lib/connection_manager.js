(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.ConnectionManager = (function() {
    function ConnectionManager() {
      this.getConnection = __bind(this.getConnection, this);      this.connections = {};
    }
    ConnectionManager.prototype.getConnection = function(url, cb) {
      var connection;
      if (!this.connections[url]) {
        this.connections[url] = {
          isReady: false,
          onReadyCb: [],
          queueCount: 0
        };
        connection = amqp.createConnection({
          url: url
        });
        this.connections[url].connection = connection;
        connection.addListener("ready", __bind(function() {
          var cx, _i, _len, _ref;
          this.connections[url].isReady = true;
          _ref = this.connections[url].onReadyCb;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            cx = _ref[_i];
            cx(null, this.connections[url].connection);
          }
          return this.connections[url].onReadyCb = [];
        }, this));
      }
      this.connections[url].queueCount++;
      if (this.connections[url].isReady) {
        return cb(null, this.connections[url].connection);
      } else {
        return this.connections[url].onReadyCb.push(cb);
      }
    };
    return ConnectionManager;
  })();
}).call(this);
