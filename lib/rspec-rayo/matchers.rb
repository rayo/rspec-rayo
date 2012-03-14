require 'rspec/expectations'

def match_type(object, type)
  unless object.is_a?(type)
    @error = "expected reason to be #{type}, got #{object}"
    raise RSpec::Expectations::ExpectationNotMetError
  end

  yield if block_given?

  object unless @error
end

%w{
  call_control
  dtmf
  input
  join
  output
  recording
}.each { |matcher| require "rspec-rayo/matchers/#{matcher}" }

RSpec::Matchers.define :have_executed_correctly do
  match_for_should do |command|
    command.await_completion
    match_type command, Punchblock::CommandNode do
      unless command.executing?
        @error = "expected status to be #{:executing.inspect}, got #{command.state_name}"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  failure_message_for_should do |actual|
    "The command failed to execute: #{@error}"
  end

  description do
    "execute correctly"
  end
end

RSpec::Matchers.define :have_dialed_correctly do
  match_for_should do |call|
    match_type call, RSpecRayo::Call
  end

  failure_message_for_should do |actual|
    "The command failed to execute: #{@error}"
  end

  description do
    "execute correctly"
  end
end

RSpec::Matchers.define :be_a_valid_complete_hangup_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Event::Complete::Hangup
    end
  end

  failure_message_for_should do |actual|
    "The complete hangup event was not valid: #{@error}"
  end

  description do
    "be a valid complete hangup event"
  end
end

RSpec::Matchers.define :be_a_valid_complete_error_event do
  chain :with_message do |message|
    @message = message
  end

  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Event::Complete::Error
      @error = "The error message was not correct. Expected '#{@message}', got '#{event.reason.details}'" if @message && event.reason.details != @message
    end
  end

  failure_message_for_should do |actual|
    "The complete error event was not valid: #{@error}"
  end

  description do
    "be a valid complete error event".tap do |d|
      d << " with message '#{@message}'" if @message
    end
  end
end

RSpec::Matchers.define :be_a_valid_complete_stopped_event do
  match_for_should do |event|
    match_type event, Punchblock::Event::Complete do
      match_type event.reason, Punchblock::Event::Complete::Stop
    end
  end

  failure_message_for_should do |actual|
    "The stopped event was not valid: #{@error}"
  end

  description do
    "be a valid stopped event"
  end
end
