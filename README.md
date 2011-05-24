rspec-tropo2
============

This library extends the Rspec testing library for Tropo2 specific expectations. The library also provides classes for Tropo1 and Tropo2 drivers.

Howto Install
-------------

	gem install rspec-tropo2

Example Driver Setup
--------------------

	ap "Starting Tropo2Driver to manage events over XMPP."
	@tropo2 = Tropo2Utilities::Tropo2Driver.new({ :username         => @config['tropo2_server']['jid'],
	                                              :password         => @config['tropo2_server']['password'],
	                                              :wire_logger      => Logger.new(@config['tropo2_server']['wire_log']),
	                                              :transport_logger => Logger.new(@config['tropo2_server']['transport_log']) })
	                                              #:log_level        => Logger::DEBUG })
                             
	ap "Starting Tropo1Driver to host scripts via DRb and launch calls via HTTP."
	@tropo1 = Tropo2Utilities::Tropo1Driver.new(@config['tropo1']['druby_uri'])

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

