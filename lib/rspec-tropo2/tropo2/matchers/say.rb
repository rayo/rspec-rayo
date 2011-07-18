RSpec::Matchers.define :be_a_valid_say_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete '
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'command_id'

    unless event.reason.name == :success
      @error = "expected :success for reason - got #{event.reason}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid successful say event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_say_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete '
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :stop
      @error = "expected :stop for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The say event was not valid: #{@error}"
  end

  description do
    "be a valid stopped say event"
  end
end

RSpec::Matchers.define :be_a_valid_say_hangup_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'

    unless event.reason.name == :hangup
      @error = "got :#{event.reason.to_s} - expected :hangup"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The hangup event was not valid: #{@error}"
  end

  description do
    "Validate a hangup event"
  end
end
