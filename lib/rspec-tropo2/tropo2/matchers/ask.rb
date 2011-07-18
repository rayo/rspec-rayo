RSpec::Matchers.define :be_a_valid_ask_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :success
      @error = "expected :noinput for reason - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid successful ask event"
  end
end

RSpec::Matchers.define :be_a_valid_noinput_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :noinput
      @error = "expected :noinput for reason - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid noinput ask event"
  end
end

RSpec::Matchers.define :be_a_valid_nomatch_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.is_a?(Punchblock::Protocol::Ozone::Command::Ask::Complete::NoMatch)
      @error = "expected Punchblock::Protocol::Ozone::Command::Ask::Complete::NoMatch for reason.class - got #{event.reason.class}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid nomatch ask event"
  end
end

RSpec::Matchers.define :be_a_valid_stopped_ask_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete '
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :stop
      @error = "expected :hangup for event.reason.name - got #{event.reason.name.inspect}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The ask event was not valid: #{@error}"
  end

  description do
    "be a valid stopped ask event"
  end
end
