amqp = require "amqp"

connection = amqp.createConnection {url: "amqp://guest:guest@localhost:5672/scottyapp_dev"}

recvCount = 0
connection.addListener "ready", ->
  console.log "connected to " + connection.serverProperties.product
  exchange1 = connection.exchange("node-conn-share1",
    type: "direct"
  )
  exchange2 = connection.exchange("node-conn-share2",
    type: "direct"
  )
  console.log Object.keys(connection.exchanges).length
  exchange2.destroy()
  q1 = connection.queue("node-q1", ->
    q2 = connection.queue("node-q2", ->
      q1.bind exchange1, "node-consumer-1"
      q1.on "queueBindOk", ->
        q2.bind exchange1, "node-consumer-2"
        q2.on "queueBindOk", ->
          console.log  Object.keys(connection.queues).length
          q1.on "basicConsumeOk", ->
            exchange1.publish "node-consumer-1", "foo"
            exchange1.publish "node-consumer-1", "foo"
            exchange1.publish "node-consumer-2", "foo"

          q2.on "basicConsumeOk", ->
            exchange1.publish "node-consumer-1", "foo"
            exchange1.publish "node-consumer-2", "foo"
            setTimeout (->
              q2.destroy()
              connection.end()
            ), 10000

          #q1.subscribe (m, headers, deliveryInfo) ->
          #  console.log "#{deliveryInfo.routingKey}  Headers: #{headers}"
          #  recvCount++

          q2.subscribe (m, headers, deliveryInfo) ->
            console.log  deliveryInfo.routingKey
            recvCount++
    )
  )

process.addListener "exit", ->
  console.log Object.keys(connection.exchanges).length
  console.log Object.keys(connection.queues).length
  console.log recvCount
  
###
recvCount = 0
body = "hello world"
connection.addListener "ready", ->
  console.log "connected to " + connection.serverProperties.product
  exchange = connection.exchange("node-json-fanout",
    type: "fanout"
  )
  q = connection.queue("node-json-queue", ->
    origMessage1 =
      two: 2
      one: 1

    origMessage2 =
      foo: "bar"
      hello: "world"

    origMessage3 =
      coffee: "café"
      tea: "thé"

    q.bind exchange, "*"
    q.subscribe((json, headers, deliveryInfo) ->
      recvCount++
      
      console.log "RESEIVED"
      
      switch deliveryInfo.routingKey
        when "message.json1"
          console.log "1"
        when "message.json2"
          console.log "2"
        when "message.json3"
          console.log "3s"
        else
          throw new Error("unexpected routing key: " + deliveryInfo.routingKey)
    ).addCallback ->
      console.log "publishing 3 json messages"
      exchange.publish "message.json1", origMessage1
      exchange.publish "message.json2", origMessage2,
        contentType: "application/json"

      exchange.publish "message.json3", origMessage3,
        contentType: "application/json"

      setTimeout (->
        connection.end()
      ), 1000
  )

process.addListener "exit", ->
  console.log recvCount

###
###
recvCount = 0
body = "hello world"
connection.addListener "ready", ->
  console.log "connected to " + connection.serverProperties.product
  connection.exchange "node-simple-fanout",
    type: "fanout"
  , (exchange) ->
    connection.queue "node-simple-queue", (q) ->
      q.bind exchange, "*"
      q.on "queueBindOk", ->
        q.on "basicConsumeOk", ->
          console.log "publishing message"
          exchange.publish "message.text", body,
            contentType: "text/plain"

          setTimeout (->
            connection.end()
          ), 10000

        q.subscribeRaw (m) ->
          console.log "--- Message (" + m.deliveryTag + ", '" + m.routingKey + "') ---"
          console.log "--- contentType: " + m.contentType
          recvCount++
          size = 0
          m.addListener "data", (d) ->
            size += d.length

          m.addListener "end", ->
            console.log body.length
            m.acknowledge()

process.addListener "exit", ->
  console.log recvCount
###  
  
###
recvCount = 0
body = "hello world"
connection.addListener "ready", ->
  console.log "connected to " + connection.serverProperties.product
  q = connection.queue("node-default-exchange", ->
    q.bind "#"
    q.on "queueBindOk", ->
      q.on "basicConsumeOk", ->
        console.log "publishing 2 msg messages"
        connection.publish "message.msg1",
          two: 2
          one: 1

        connection.publish "message.msg2",
          foo: "bar"
          hello: "world"

        setTimeout (->
          console.log "TIMING OUT"
          connection.end()
        ), 10000

      q.subscribe
        routingKeyInPayload: true
      , (msg) ->
        recvCount++
        switch msg._routingKey
          when "message.msg1"
            console.log "received X"
            console.log msg.one
          when "message.msg2"
            console.log "received Y"
            console.log msg.hello
          else
            throw new Error("unexpected routing key: " + msg._routingKey)
  )

process.addListener "exit", ->
  console.log recvCount
  
global.conn = connection
###