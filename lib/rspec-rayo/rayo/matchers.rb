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

def match_type(object, type)
  unless object.is_a?(type)
    @error = "expected reason to be #{type}, got #{object}"
    raise RSpec::Expectations::ExpectationNotMetError
  end
end

def basic_validation(object, klass, validate_command_id = false)
  execution_expired? object

  match_type object, klass

  uuid_match? object.call_id, 'call_id'
  uuid_match? object.command_id, 'cmd_id' if validate_command_id

  yield if block_given?

  true unless @error
end

%w{
  ask
  call_control
  conference
  dtmf
  input
  output
  recording
  say
  transfer
}.each { |matcher| require "rspec-rayo/rayo/matchers/#{matcher}" }

RSpec::Matchers.define :be_a_valid_complete_hangup_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Complete, true do
      match_type event.reason, Punchblock::Protocol::Rayo::Event::Complete::Hangup
    end
  end

  failure_message_for_should do |actual|
    "The complete hangup event was not valid: #{@error}"
  end

  description do
    "be a valid complete hangup event"
  end
end
