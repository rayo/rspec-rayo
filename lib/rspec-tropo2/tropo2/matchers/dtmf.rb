RSpec::Matchers.define :be_a_valid_dtmf_event do
  match_for_should do |event|
    execution_expired? event

    if event.is_a?(Punchblock::Protocol::Ozone::Event::DTMF)
      true
    else
      @error = 'not an instance of Punchblock::Protocol::Ozone::Event::DTMF '
      raise RSpec::Expectations::ExpectationNotMetError
    end
  end

  failure_message_for_should do |actual|
    "The DTMF event was not valid: #{@error}"
  end

  description do
    "be a valid DTMF event"
  end
end
