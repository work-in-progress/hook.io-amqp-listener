(function() {
  var amqp;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  amqp = require("amqp");
  exports.ConnectionManager = (function() {
    ConnectionManager.prototype.connections = {};
    function ConnectionManager() {
      this.getConnection = __bind(this.getConnection, this);
    }
    ConnectionManager.prototype.getConnection = function(url, cb) {
      var connection;
      if (this.connections[url]) {
        return cb(null, this.connections[url].connection);
      } else {
        connection = amqp.createConnection({
          url: url
        });
        return connection.addListener("ready", __bind(function() {
          this.connections[url] = {};
          this.connections[url].connection = connection;
          return cb(null, this.connections[url].connection);
        }, this));
      }
    };
    return ConnectionManager;
  })();
}).call(this);
