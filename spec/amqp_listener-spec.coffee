vows = require 'vows'
assert = require 'assert'

main = require '../lib/index'
specHelper = require './spec_helper'

vows.describe("AmqpListener")
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
  .export module


###
.addBatch 
  "WHEN adding a queue": 
    topic:  () ->
      specHelper.hookMeUp @callback

      specHelper.hook.emit "amqp-listener::compress",
        source : specHelper.fixturePath(specHelper.uncompressed)
        target : specHelper.tmpPath("test1.gz")
        mode : 'gzip'
      return
    "THEN it must be complete": (err,event,data) ->
      assert.equal event,"amqp-listener::compress-complete" 
###
