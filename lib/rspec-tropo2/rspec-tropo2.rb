require 'rspec/expectations'

RSpec::Matchers.define :be_a_valid_ask_event do
  match_for_should do |ask_event|
    ap ask_event
    if ask_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    # reply.should_not eql "execution expired"
    # ask.should_not eql "execution expired"
    # 
    # reply[:stanza]['iq']['type'].should eql 'result'
    # ask[:stanza]['iq']['complete']['utterance'].should eql utterance
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_answer_event do
  match_for_should do |answer_event|
    ap answer_event
    if answer_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if answer_event.class != Punchblock::Protocol::Ozone::Message::Info
      @error = 'not an instance of Punchblock::Protocol::Ozone::Message::Info'
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

# Provides a custom matcher for validating a call event
RSpec::Matchers.define :be_a_valid_call_event do
  match_for_should do |call_event|
    if call_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout' if call_event == "execution expired"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if call_event.class != Punchblock::Call
      @error = 'not an instance of Punchblock::Call'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if call_event.id.match(/\A[\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12}/).nil?
      @error = 'id == ' + call_event.id + " - expected a GUID"
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
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
  match_for_should do |ask_event|
    ap ask_event
    if ask_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    # reply[:stanza]['iq']['type'].should eql "result"
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

# Provides a custom matcher for validating a hangup event
RSpec::Matchers.define :be_a_valid_hangup_event do
  match_for_should do |hangup_event|
    if hangup_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    if hangup_event.class != Punchblock::Protocol::Ozone::Message::End
      @error = 'not an instance of Punchblock::Protocol::Ozone::Message::End'
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

RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |ask_event|
    ap say_event
    if say_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
    # reply[:stanza]['iq']['type'].should eql 'result'
    # say[:stanza]['iq']['type'].should eql 'set'
    # say[:stanza]['iq']['complete']['reason'].should eql 'SUCCESS'
  end
  
  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_say_event do
  match_for_should do |sau_event|
    ap say_event
    if say_event == "execution expired"
      @error = 'event was not delivered to queue before read timeout'
      raise RSpec::Expectations::ExpectationNotMetError
    end
    
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