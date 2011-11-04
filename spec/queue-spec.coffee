vows = require 'vows'
assert = require 'assert'
Queue = require("../lib/queue").Queue
main = require '../lib/index'
specHelper = require './spec_helper'

vows.describe("Queue")
  .addBatch
    "CLEANUP TEMP":
      topic: () ->
        specHelper.cleanTmpFiles []
      "THEN IT SHOULD BE CLEAN :)": () ->
        assert.isTrue true        
  .addBatch
    "SETUP HOOK" :
      topic: () -> 
        specHelper.setup @callback
        return
      "THEN IT SHOULD SET UP :)": () ->
        assert.isTrue true
  .addBatch 
    "WHEN creating a queue object": 
      topic:  () ->
        return new Queue("amqp://guest:guest@localhost:5672/scottyapp_dev","direct","exch","que")
      "THEN it must have it's url set": (q) ->
        assert.equal q.url,"amqp://guest:guest@localhost:5672/scottyapp_dev" 
      "THEN it must have it's type set to direct": (q) ->
        assert.equal q.exchangeType,"direct"
      "THEN it must have it's type set to direct": (q) ->
        assert.equal q.exchangeName,"exch"
      "THEN it must have it's type set to direct": (q) ->
        assert.equal q.queueName,"que"
  .export module



