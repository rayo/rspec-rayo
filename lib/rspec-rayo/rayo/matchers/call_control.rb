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
    basic_validation event, Punchblock::Protocol::Rayo::Event::Answered
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
    basic_validation event, Punchblock::Protocol::Rayo::Event::End do
      unless event.reason == :hangup
        @error = "got #{event.reason.inspect} - expected :hangup"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  failure_message_for_should do |actual|
    "The hangup event was not valid: #{@error}"
  end

  description do
    "be a valid hangup event"
  end
end

RSpec::Matchers.define :be_a_valid_ringing_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::Ringing
  end

  failure_message_for_should do |actual|
    "The ring event was not valid: #{@error}"
  end

  description do
    "be a valid ringing event"
  end
end

RSpec::Matchers.define :be_a_valid_redirect_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::End do
      unless event.reason == :redirect
        @error = "got #{event.reason.inspect} - expected :redirect"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  failure_message_for_should do |actual|
    "The reject event was not valid: #{@error}"
  end

  description do
    "be a valid reject event"
  end
end

RSpec::Matchers.define :be_a_valid_reject_event do
  match_for_should do |event|
    basic_validation event, Punchblock::Protocol::Rayo::Event::End do
      unless event.reason == :reject
        @error = "got #{event.reason.inspect} - expected :reject"
        raise RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  failure_message_for_should do |actual|
    "The reject event was not valid: #{@error}"
  end

  description do
    "be a valid reject event"
  end
end
