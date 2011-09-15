rspec-rayo
============

This library extends the Rspec testing library for Rayo specific expectations. The library also provides classes for Tropo1 and Rayo drivers.

Howto Install
-------------

	gem install rspec-rayo

Example Driver Setup
--------------------

	ap "Starting RayoDriver to manage events over XMPP."
	@rayo = RSpecRayo::RayoDriver.new :username         => @config['rayo_server']['jid'],
	                                  :password         => @config['rayo_server']['password'],
	                                  :wire_logger      => Logger.new(@config['rayo_server']['wire_log']),
	                                  :transport_logger => Logger.new(@config['rayo_server']['transport_log'])

	ap "Starting Tropo1Driver to host scripts via DRb and launch calls via HTTP."
	@tropo1 = RSpecRayo::Tropo1Driver.new(@config['tropo1']['druby_uri'])

Custom Matchers
---------------

* have_executed_correctly
* have_dialed_correctly
* be_a_valid_complete_hangup_event
* be_a_valid_complete_error_event
* be_a_valid_complete_stopped_event

* be_a_valid_successful_ask_event
* be_a_valid_ask_noinput_event
* be_a_valid_ask_nomatch_event

* be_a_valid_offer_event
* be_a_valid_answered_event
* be_a_valid_hangup_event
* be_a_valid_ringing_event
* be_a_valid_redirect_event
* be_a_valid_reject_event

* be_a_valid_conference_offhold_event
* be_a_valid_speaking_event
* be_a_valid_finished_speaking_event
* be_a_valid_conference_complete_terminator_event

* be_a_valid_dtmf_event

* be_a_valid_successful_input_event
* be_a_valid_input_noinput_event
* be_a_valid_input_nomatch_event

* be_a_valid_joined_event
* be_a_valid_unjoined_event

* be_a_valid_output_event

* be_a_valid_complete_recording_event
* be_a_valid_stopped_recording_event

* be_a_valid_say_event

* be_a_valid_transfer_event
* be_a_valid_transfer_timeout_event


Copyright
---------

Copyright (c) 2011 Voxeo Corporation. See LICENSE.txt for further details.

