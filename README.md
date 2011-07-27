rspec-rayo
============

This library extends the Rspec testing library for Rayo specific expectations. The library also provides classes for Tropo1 and Rayo drivers.

Howto Install
-------------

	gem install rspec-rayo

Example Driver Setup
--------------------

	ap "Starting RayoDriver to manage events over XMPP."
	@rayo = RSpecRayo::RayoDriver.new({ :username         => @config['rayo_server']['jid'],
	                                              :password         => @config['rayo_server']['password'],
	                                              :wire_logger      => Logger.new(@config['rayo_server']['wire_log']),
	                                              :transport_logger => Logger.new(@config['rayo_server']['transport_log']) })
	                                              #:log_level        => Logger::DEBUG })
                             
	ap "Starting Tropo1Driver to host scripts via DRb and launch calls via HTTP."
	@tropo1 = RSpecRayo::Tropo1Driver.new(@config['tropo1']['druby_uri'])

Custom Matchers
---------------

	be_a_valid_ask_event
	be_a_valid_answer_event
	be_a_valid_call_event
	be_a_valid_control_event
	be_a_valid_hangup_event
	be_a_valid_say_event
	be_a_valid_stopped_say_event

Copyright
---------

Copyright (c) 2011 Voxeo Corporation. See LICENSE.txt for further details.

