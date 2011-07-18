RSpec::Matchers.define :be_a_valid_transfer_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete '
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :success
      @error = "expected :success for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "be a valid transfer event"
  end
end

RSpec::Matchers.define :be_a_valid_transfer_timeout_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Complete)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Complete '
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'
    uuid_match? event.command_id, 'cmd_id'

    unless event.reason.name == :timeout
      @error = "expected :timouet for reason.name - got #{event.reason.name}"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The transfer event was not valid: #{@error}"
  end

  description do
    "be a valid transfer timeout event"
  end
end
