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
end

include Tropo2Helpers

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_answer_event do
  match_for_should do |answer_event|
    execution_expired?(answer_event)
    
    uuid_match?(answer_event.call_id, 'call_id')
    
    if answer_event.type != :answer
      @error = "got :#{answer_event.type.to_s} - expected :answer"
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
  match_for_should do |ask_event|
    execution_expired?(ask_event)
    
    if ask_event.class != Punchblock::Protocol::Ozone::Complete
      @error = 'not an instance of Punchblock::Protocol::Ozone::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    uuid_match?(ask_event.call_id, 'call_id')
    uuid_match?(ask_event.cmd_id, 'cmd_id')
    
    if ask_event.xmlns != 'urn:xmpp:ozone:ask:1'
      @error = "expected urn:xmpp:ozone:ask:1 for xmlns - got #{ask_event.xmlns}"
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
  match_for_should do |call_event|
    execution_expired?(call_event)
    
    if call_event.class != Punchblock::Call
      @error = 'not an instance of Punchblock::Call'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    uuid_match?(call_event.call_id, 'call_id')
    
    if call_event.to.nil? == true
      @error = 'to is nil - expected a value'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    call_event.headers.each do |k,v|
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
  match_for_should do |hangup_event|
    execution_expired?(hangup_event)
    
    if hangup_event.class != Punchblock::Protocol::Ozone::End
      @error = 'not an instance of Punchblock::Protocol::Ozone::End'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    uuid_match?(hangup_event.call_id, 'call_id')
    
    if hangup_event.type != :hangup
      @error = "got :#{hangup_event.type.to_s} - expected :hangup"
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
  match_for_should do |reject_event|
    execution_expired?(reject_event)
    
    uuid_match?(reject_event.call_id, 'call_id')
    
    if reject_event.type != :reject
      @error = "got :#{reject_event.type.to_s} - expected :reject"
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

RSpec::Matchers.define :be_a_valid_successful_say_event do
  match_for_should do |say_event|
    execution_expired?(say_event)
    
    if say_event.class != Punchblock::Protocol::Ozone::Complete
      @error = 'not an instance of Punchblock::Protocol::Ozone::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    uuid_match?(say_event.call_id, 'call_id')
    uuid_match?(say_event.cmd_id, 'cmd_id')
    
    if say_event.attributes[:reason] != 'SUCCESS'
      @error = "expected :success for attributes[:reason] - got #{say_event.attributes[:reason]}"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if say_event.xmlns != 'urn:xmpp:ozone:say:1'
      @error = "expected urn:xmpp:ozone:say:1 for xmlns - got #{say_event.xmlns}"
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
  match_for_should do |sau_event|
    execution_expired?(say_event)
    
    # reply[:stanza]['iq']['type'].should eql 'result'
    # say[:stanza]['iq']['type'].should eql 'set'
    # say[:stanza]['iq']['complete']['reason'].should eql 'STOP'
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end