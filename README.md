## About hook.io-amqp-listener

A hook that listens to an amqp queue and forwards messages to the hook.io bus.

![AmqpListener Icon](http://github.com/scottyapp/hook.io-amqp-listener/raw/master/assets/amqp-listener114x114.png)

[![Build Status](https://secure.travis-ci.org/scottyapp/hook.io-amqp-listener.png)](http://travis-ci.org/scottyapp/hook.io-amqp-listener.png)


## Install

npm install -g hook.io-amqp-listener

## Usage

	./bin/hookio-amqp-listener

This starts a hook and reads the local config.json. It opens an amqp connection and listens to incoming messages

### Messages

amqp-listener::compress [in]

	source: the source file name. Required. This is the file that will be compressed.
	target: the target file name. Required.
	mode: 'gzip' or 'bzip2', defaults to 'gzip'

amqp-listener::uncompress [in]

	source: the source file name. Required. This is the file that will be uncompressed.
	target: the target file name. Required.

amqp-listener::error [out]

	code: code
	source:
	target:
	mode:

amqp-listener::compress-complete [out]

	code: code
	source:
	target:
	mode:

amqp-listener::uncompress-complete [out]

target : The target file name.

### Hook.io Schema support 

The package config contains experimental hook.io schema definitions. The definition is also exported as hook. Signatures will be served from a signature server (more to come).

### Coffeescript

	AmqpListener = require("hook.io-amqp-listener").AmqpListener
	hook = new AmqpListener(name: 'amqp-listener')
 
### Javascript

	var AmqpListener = require("hook.io-amqp-listener").AmqpListener;
	var hook = new AmqpListener({ name: 'amqp-listener' });

## Advertising :)

Check out http://freshfugu.com and http://scottyapp.com

Follow us on Twitter at @getscottyapp and @freshfugu and like us on Facebook please. Every mention is welcome and we follow back.

## Trivia

Listened to lots of M.I.A. and Soundgarden while writing this.

## Release Notes

### 0.0.1

* First version

## Internal Stuff

* npm run-script watch

# Publish new version

* Change version in package.json
* git tag -a v0.0.1 -m 'version 0.0.1'
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


