## About hook.io-amqp-listener

A hook that listens to an amqp queue and forwards messages to the hook.io message bus.

Scenario: You have a ruby/java/whatever front end app and want to decouple long running tasks, so you
push messages into your amqp queue. Your backend processing is written in node.js, so you create a hook to do your backend work, and then connect amqp to your hook.io bus.

Caveat:

This is a very early version. Future versions will hopefully support the mapping of event names and acknowledging messages. Right now I just needed it to work.

![AmqpListener Icon](http://github.com/scottyapp/hook.io-amqp-listener/raw/master/assets/amqp-listener114x114.png)

[![Build Status](https://secure.travis-ci.org/scottyapp/hook.io-amqp-listener.png)](http://travis-ci.org/scottyapp/hook.io-amqp-listener.png)

## Credits

Thanks a ton to @michaelklishin for helping me with amqp.

## Install

npm install -g hook.io-amqp-listener

## Usage

	./bin/hookio-amqp-listener

This starts a hook and reads the local config.json. It opens an amqp connection and listens to incoming messages

### Messages

amqp-listener::add [in]
Adds a queue listener. Make sure the tuple connection,queueName is added only once, otherwise
all bets are off.

	connection : "amqp[s]://[user:password@]hostname[:port][/vhost]",
	queueName : "my-queue",


amqp-listener::error [out]

	data: the data causing the error
	error: The actual error

amqp-listener::received [out]
Message will be sent for each received event unless that event has been name mapped.

	queue: The queue name.
	message: The message received.
	contentType: The content type. The message is never pre processed.
  deliveryMode: Passed verbatim from the delivery info. 
  deliveryTag: Passed verbatim from the delivery info.
  redelivered: true if this message has been redelivered.
  exchange : The exchange this came from, or "" for the default exchange.
  routingKey : Passed verbatim from the delivery info.
  consumerTag : Passed verbatim from the delivery info.


### Hook.io Schema support 

The package config contains experimental hook.io schema definitions. The definition is also exported as hook. Signatures will be served from a signature server (more to come).

### Coffeescript

	AmqpListener = require("hook.io-amqp-listener").AmqpListener
	hook = new AmqpListener(name: 'amqp-listener')
 
### Javascript

	var AmqpListener = require("hook.io-amqp-listener").AmqpListener;
	var hook = new AmqpListener({ name: 'amqp-listener' });

## Advertising :)

Check out 

* http://scottyapp.com

Follow us on Twitter at 

* @getscottyapp
* @martin_sunset

and like us on Facebook please. Every mention is welcome and we follow back.


## Trivia

Listened to lots of M.I.A. and Soundgarden while writing this.

## Release Notes

### 0.0.2

* Move the .on code around a bit
* Made use of @ instead of self.

### 0.0.1

* First version

## Internal Stuff

* npm run-script watch

# Publish new version

* Change version in package.json
* git tag -a v0.0.2 -m 'version 0.0.2'
* git push --tags
* npm publish

## Contributing to hook.io-amqp-listener
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Martin Wawrusch. See LICENSE for
further details.


