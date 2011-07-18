require 'rspec/expectations'

def execution_expired?(event)
  if event == "execution expired"
    @error = 'event was not delivered to queue before read timeout'
    raise RSpec::Expectations::ExpectationNotMetError
  end
end

def uuid_match?(uuid, type)
  if uuid.match(/\A[\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12}/).nil?
    @error = "#{type} == #{uuid} - expected a GUID"
    raise RSpec::Expectations::ExpectationNotMetError
  end
end

%w{
  ask
  call_control
  conference
  dtmf
  say
  transfer
}.each { |matcher| require "rspec-tropo2/tropo2/matchers/#{matcher}" }

RSpec::Matchers.define :be_a_valid_complete_hangup_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Command::Event::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :hangup
      @error = "expected :hangup for reason.name - got #{reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "Validate an ask event"
  end
end

RSpec::Matchers.define :be_a_valid_control_event do
  match_for_should do |control_event|
    execution_expired? control_event

    # reply[:stanza]['iq']['type'].should eql "result"
  end

  failure_message_for_should do |actual|
    "The control event was not valid: #{@error}"
  end

  description do
    "Validate an control event"
  end
end

RSpec::Matchers.define :be_a_valid_redirect_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::End)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::End'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'

    unless event.reason == :redirect
      @error = "got :#{event.reason.to_s} - expected :redirect"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The reject event was not valid: #{@error}"
  end

  description do
    "Validate a reject event"
  end
end

RSpec::Matchers.define :be_a_valid_reject_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::End)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::End'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'

    unless event.reason == :reject
      @error = "got :#{event.reason.to_s} - expected :reject"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The reject event was not valid: #{@error}"
  end

  description do
    "Validate a reject event"
  end
end

RSpec::Matchers.define :be_a_valid_ringing_event do
  match_for_should do |event|
    execution_expired? event
    uuid_match? event.call_id, 'call_id'

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Ringing)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Ringing'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ring event was not valid: #{@error}"
  end

  description do
    "Validate a ring event"
  end
end
