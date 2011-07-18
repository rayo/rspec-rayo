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

    unless event.reason.is_a?(Punchblock::Protocol::Ozone::Event::Complete::Hangup)
      @error = "got #{event.reason.class} - expected Punchblock::Protocol::Ozone::Event::Complete::Hangup"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid complete hangup event"
  end
end
