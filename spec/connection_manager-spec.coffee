vows = require 'vows'
assert = require 'assert'
ConnectionManager = require("../lib/connection_manager").ConnectionManager
main = require '../lib/index'
specHelper = require './spec_helper'

connectionManager = new ConnectionManager()

vows.describe("ConnectionManager")
  .addBatch 
    "WHEN creating a queue object": 
      topic:  () ->
        return connectionManager
      "THEN it's connections property must not be null": (cm) ->
        assert.isNotNull cm.connections
      "THEN it must have not have a specific connection": (err,amqpConnection) ->
         assert.equal connectionManager.connections[specHelper.testServer],undefined
 .addBatch 
    "WHEN connecting":
      topic:  () ->
        connectionManager.getConnection(specHelper.testServer,@callback)
        return
      "THEN it must not err": (err,amqpConnection) ->
        assert.isNull err
      "THEN it must invoke the callback with a connection": (err,amqpConnection) ->
        assert.isNotNull amqpConnection
      "THEN it must have a connection cache set up": (err,amqpConnection) ->
        assert.isNotNull connectionManager.connections[specHelper.testServer]
      "THEN it's queueCount must be 1": (err,amqpConnection) ->
        assert.equal connectionManager.connections[specHelper.testServer].queueCount,1      
  .addBatch 
    "WHEN connecting again":
      topic:  () ->
        connectionManager.getConnection(specHelper.testServer,@callback)
        return
      "THEN it must not err": (err,amqpConnection) ->
        assert.isNull err
      "THEN it's queueCount must be 2": (err,amqpConnection) ->
        assert.equal connectionManager.connections[specHelper.testServer].queueCount,2       
  .export module



