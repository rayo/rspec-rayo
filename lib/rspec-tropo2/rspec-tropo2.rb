require 'rspec/expectations'

module Tropo2Helpers
  def execution_expired?(event)
    if event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
  end
  
  def uuid_match?(uuid, type)
    if uuid.match(/\A[\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12}/).nil?
      @error = type + ' == ' + uuid + " - expected a GUID"
      raise RSpec::Expectations::ExpectationNotMetError
    end
  end
  
  def validate_class(klass)
    if klass != Punchblock::Protocol::Ozone::Event
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event'
      raise RSpec::Expectations::ExpectationNotMetError
    end
  end
end

include Tropo2Helpers

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_answer_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    
    uuid_match?(event.call_id, 'call_id')
    
    if event.reason != :answer
      @error = "got :#{event.reason.to_s} - expected :answer"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The answer event was not valid: #{@error}"
  end

  description do
    "Validate a answer event"
  end
end

RSpec::Matchers.define :be_a_valid_ask_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')

    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for namespace_href - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:ask:complete:1'
      @error = "expected urn:xmpp:ozone:ext:1 for namespace_href - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_conference_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for xmlns - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_noinput_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for xmlns - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.name != :noinput
      @error = "expected :noinput for reason - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:ask:complete:1'
      @error = "expected urn:xmpp:ozone:ask:complete:1 for xmlns - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_nomatch_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for xmlns - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.name != :nomatch
      @error = "expected :noinput for reason - got #{event.reason}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:ask:complete:1'
      @error = "expected urn:xmpp:ozone:ask:complete:1 for xmlns - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

# Provides a custom matcher for validating a call event
RSpec::Matchers.define :be_a_valid_call_event do
  match_for_should do |event|
    execution_expired?(event)
    
    uuid_match?(event.call_id, 'call_id')
    
    if event.to.nil? == true
      @error = 'to is nil - expected a value'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    event.headers.each do |k,v|
      if v.nil?
        @error = "#{k.to_s} is nil - expected a value"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The call event was not valid: #{@error}"
  end
  
  description do
    "Validate a call event"
  end
end

RSpec::Matchers.define :be_a_valid_control_event do
  match_for_should do |control_event|
    execution_expired?(control_event)
    
    # reply[:stanza]['iq']['type'].should eql "result"
  end
  
  failure_message_for_should do |actual|
    "The control event was not valid: #{@error}"
  end

  description do
    "Validate an control event"
  end
end

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_hangup_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    
    if event.reason != :hangup
      @error = "got :#{event.reason.to_s} - expected :hangup"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.namespace_href != 'urn:xmpp:ozone:1'
      @error = "got namespace_href #{event.namespace_href} - expected urn:xmpp:ozone:1"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The hangup event was not valid: #{@error}"
  end

  description do
    "Validate a hangup event"
  end
end

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_say_hangup_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    
    if event.reason.name != :hangup
      @error = "got :#{event.reason.to_s} - expected :hangup"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:ext:complete:1'
      @error = "got namespace_href #{event.namespace_href} - expected urn:xmpp:ozone:ext:complete:1"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The hangup event was not valid: #{@error}"
  end

  description do
    "Validate a hangup event"
  end
end

RSpec::Matchers.define :be_a_valid_reject_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    
    if event.reason != :reject
      @error = "got :#{event.reason.to_s} - expected :reject"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The reject event was not valid: #{@error}"
  end

  description do
    "Validate a reject event"
  end
end

RSpec::Matchers.define :be_a_valid_ring_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    
    # Awaiting this fix to be a complete test: https://github.com/tropo/punchblock/issues/25
    # if event.namespace_href != 'urn:xmpp:ozone:info:1'
    #   @error = "expected urn:xmpp:ozone:info:1 for xmlns - got #{event.namespace_href}"
    #   raise RSpec::Expectations::ExpectationNotMetError
    # end
    
    if event.reason != :ring
      @error = "expected :ring for type - got :#{event.reason.to_s}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ring event was not valid: #{@error}"
  end

  description do
    "Validate a ring event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_ask_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.reason != :stop
      @error = "expected :stop for attributes[:reason] - got #{event.attributes[:reason]}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.namespace_href != 'urn:xmpp:ozone:ask:1'
      @error = "expected urn:xmpp:ozone:ask:1 for namespace_href - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an say event"
  end
end

RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'command_id')
    
    if event.reason.name != :success
      @error = "expected :success for reason - got #{event.reason}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:say:complete:1'
      @error = "expected urn:xmpp:ozone:say:complete:1 for nampespace_href - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_say_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.reason.name != :stop
      @error = "expected :stop for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:say:1'
      @error = "expected urn:xmpp:ozone:say:1 for xmlns - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "Validate an say event"
  end
end

RSpec::Matchers.define :be_a_valid_transfer_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for namespace_ref - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.name != :success
      @error = "expected :success for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:transfer:complete:1'
      @error = "expected urn:xmpp:ozone:transfer:complete:1 for reason.namespace_ref - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "Validate a transfer event"
  end
end

RSpec::Matchers.define :be_a_valid_transfer_timeout_event do
  match_for_should do |event|
    execution_expired?(event)
    
    validate_class(event.class)
    uuid_match?(event.call_id, 'call_id')
    uuid_match?(event.command_id, 'cmd_id')
    
    if event.namespace_href != 'urn:xmpp:ozone:ext:1'
      @error = "expected urn:xmpp:ozone:ext:1 for xmlns - got #{event.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.name != :timeout
      @error = "expected :timouet for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if event.reason.namespace_href != 'urn:xmpp:ozone:transfer:complete:1'
      @error = "expected urn:xmpp:ozone:transfer:complete:1 for xmlns - got #{event.reason.namespace_href}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    true if !@error
  end
  
  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "Validate a transfer event"
  end
end
