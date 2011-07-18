RSpec::Matchers.define :be_a_valid_call_event do
  match_for_should do |event|
    execution_expired? event

    uuid_match? event.call_id, 'call_id'

    if event.to.nil?
      @error = 'to is nil - expected a value'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    event.headers.each do |k,v|
      if v.nil?
        @error = "#{k.to_s} is nil - expected a value"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The call event was not valid: #{@error}"
  end

  description do
    "be a valid call event"
  end
end

RSpec::Matchers.define :be_a_valid_answered_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::Answered)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::Answered'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'

    true unless @error
  end

  failure_message_for_should do |actual|
    "The answer event was not valid: #{@error}"
  end

  description do
    "be a valid answered event"
  end
end

RSpec::Matchers.define :be_a_valid_hangup_event do
  match_for_should do |event|
    execution_expired? event

    unless event.is_a?(Punchblock::Protocol::Ozone::Event::End)
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::End'
      raise RSpec::Expectations::ExpectationNotMetError
    end

    uuid_match? event.call_id, 'call_id'

    unless event.reason == :hangup
      @error = "got #{event.reason.inspect} - expected :hangup"
      raise RSpec::Expectations::ExpectationNotMetError
    end

    true unless @error
  end

  failure_message_for_should do |actual|
    "The hangup event was not valid: #{@error}"
  end

  description do
    "be a valid hangup event"
  end
end
