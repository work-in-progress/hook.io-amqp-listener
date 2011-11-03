vows = require 'vows'
assert = require 'assert'

main = require '../lib/index'
specHelper = require './spec_helper'

vows.describe("integration_task")
  .addBatch
    "CLEANUP TEMP":
      topic: () ->
        specHelper.cleanTmpFiles ['test1.gz','test2.bz2','test3.txt','test4.txt']
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
    "WHEN gzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback

        specHelper.hook.emit "amqp-listener::compress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test1.gz")
          mode : 'gzip'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"amqp-listener::compress-complete" 
  .addBatch 
    "WHEN bzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.emit "amqp-listener::compress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test2.bz2")
          mode : 'bzip2'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"amqp-listener::compress-complete" 
  .addBatch 
    "WHEN gunzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.emit "amqp-listener::uncompress",
          source : specHelper.fixturePath(specHelper.compressedGzip)
          target : specHelper.tmpPath("test3.txt")
          mode : 'gzip'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"amqp-listener::uncompress-complete" 
  .addBatch 
    "WHEN bunzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.on "amqp-listener::uncompress-complete", (data) =>
          @callback(null,data)
        specHelper.hook.emit "amqp-listener::uncompress",
          source : specHelper.fixturePath(specHelper.compressedBz2)
          target : specHelper.tmpPath("test4.txt")
          mode : 'bzip2'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"amqp-listener::uncompress-complete" 
  .export module
